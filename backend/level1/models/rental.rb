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
    price = rental_days * car.price_per_day + distance * car.price_per_km
  end
end
