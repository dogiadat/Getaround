class Option < ApplicationModel
  attribute :id
  attribute :rental_id
  attribute :type

  def price_per_day
    case type
    when "gps"
      500
    when "baby_seat"
      200
    when "additional_insurance"
      1000
    end
  end
end
