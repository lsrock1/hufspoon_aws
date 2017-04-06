module OhomeHelper
  def oLan_collection
    @languageHash[@language].append("active")
    content_tag(:div, class: :collection) do 
      @languageHash.collect do |key, item|
        concat content_tag(:a, item[0], class: "collection-item #{item[2]}", onclick: "languageChange(#{key})")
      end
    end
  end
end
