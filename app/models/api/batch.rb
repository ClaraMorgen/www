module Api
  class Batch
    include CloudinaryHelper
    def initialize(json)
      @json = json
    end

    def price
      @price ||= Money.new(@json["price_cents"], @json["price_currency"])
    end

    def method_missing(name)
      @json[name.to_s]
    end

    def as_json(options = {})
      @json
    end

    def cover_image_url
      @cover_image_url ||= cloudinary_url("#{@json['cover_image']}.jpg")
    end

    def analytics_slug
      if @json['id'] == 68 # HEC Paris
        @json['analytics_slug'] + '-hec'
      else
        @json['analytics_slug']
      end
    end
  end
end
