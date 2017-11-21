module EmployersHelper

  def cities_collection
    @cities.map {|c| [c["name"], c["slug"]]}
  end
end
