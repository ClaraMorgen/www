require 'roar/json/hal'
require 'roar/coercion'

module BaseRepresenter
  include Roar::JSON::HAL
  include Roar::Hypermedia
  include Roar::Coercion

  property :id
  property :updated_at, type: DateTime
end
