module EmployersHelper

  def cities_collection
    @cities.map {|c| [c["name"], c["slug"]]}
  end

  def label_with_icon(slug, text)
    "<i class='mdi mdi-#{slug}'></i><span>#{text}</span>".html_safe
  end
end
