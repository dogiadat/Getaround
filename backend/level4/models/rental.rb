class Rental < ApplicationModel
  attribute :id
  attribute :car_id
  attribute :start_date, Date
  attribute :end_date, Date
  attribute :distance

  def car
    Car.find car_id
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

  def actions
    [
      {
        who: "driver",
        type: "debit",
        amount: price
      },
      {
        who: "owner",
        type: "credit",
        amount: price - commission_fee
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
        amount: drivy_fee
      }
    ]
  end
end
