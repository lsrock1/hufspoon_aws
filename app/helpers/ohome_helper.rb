module OhomeHelper
  def oLan_collection
    @languageHash[@language][:active] = "active"
    content_tag(:div, class: :collection) do 
      @languageHash.collect do |key, item|
        concat content_tag(:a, item[:showName], class: "collection-item #{item[:active]}", onclick: "languageChange(#{key})")
      end
    end
  end
end
