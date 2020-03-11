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
    rental_days = (end_date - start_date).floor + 1
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
end
