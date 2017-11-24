module EmployersHelper

  def label_with_icon(slug, text)
    "<i class='mdi mdi-#{slug}'></i><span>#{text}</span>".html_safe
  end
end
