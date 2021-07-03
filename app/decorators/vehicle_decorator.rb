class VehicleDecorator
  delegate :id, :name, :photos, :folders, :vin, :odometer, :engine_type, to: :vehicle

  def initialize(vehicle)
    @vehicle = vehicle
  end

  def photos?
    photos.exists?
  end

  def photo_thumb_url
    return unless photos?

    photos.first.photo.thumb.url
  end

  private

  attr_reader :vehicle
end
