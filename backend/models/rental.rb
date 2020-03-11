class Rental < ApplicationModel
  attribute :id
  attribute :car_id
  attribute :start_date, Date
  attribute :end_date, Date
  attribute :distance

  def car
    Car.find car_id
  end

  def price_with_no_decrease
    price = rental_days * car.price_per_day + distance * car.price_per_km
  end

  def price
    total_date_with_decreases = if rental_days > 10
                                  1 + 3 * 0.9 + 6 * 0.7 + (rental_days - 10) * 0.5
                                elsif rental_days > 4
                                  1 + 3 * 0.9 + (rental_days - 4) * 0.7
                                elsif rental_days > 1
                                  1 + (rental_days - 1) * 0.9
                                else
                                  1
                                end
    (total_date_with_decreases * car.price_per_day + distance * car.price_per_km).round
  end

  def rental_days
    (end_date - start_date).floor + 1
  end

  def commission_fee
    price * 30 / 100
  end

  def insurance_fee
    commission_fee * 50 / 100
  end

  def assistance_fee
    rental_days * 100
  end

  def drivy_fee
    commission_fee - (insurance_fee + assistance_fee)
  end

  def options
    return [] unless Option.all_record
    Option.all_record.select{ |option| option["rental_id"] == id }.map do |option|
      Option.new option
    end
  end

  def gps_fee
    option = options.detect { |opt| opt.type ==  "gps" }
    option ? option.price_per_day * rental_days : 0
  end

  def baby_seat_free
    option = options.detect { |opt| opt.type ==  "baby_seat" }
    option ? option.price_per_day * rental_days : 0
  end

  def additional_insurance_fee
    option = options.detect { |opt| opt.type ==  "additional_insurance" }
    option ? option.price_per_day * rental_days : 0
  end

  def actions
    [
      {
        who: "driver",
        type: "debit",
        amount: price + gps_fee + baby_seat_free + additional_insurance_fee
      },
      {
        who: "owner",
        type: "credit",
        amount: price - commission_fee + baby_seat_free + gps_fee
      },
      {
        who: "insurance",
        type: "credit",
        amount: insurance_fee
      },
      {
        who: "assistance",
        type: "credit",
        amount: assistance_fee
      },{
        who: "drivy",
        type: "credit",
        amount: drivy_fee + additional_insurance_fee
      }
    ]
  end
end
