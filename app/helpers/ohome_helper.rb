module OhomeHelper
  def tab_lists
    capture do
      @restCategoryHash.collect{|key,value|
      concat(
        content_tag(:li,class: 'tab') do
          content_tag(:a, value[@language], class: (@restCategoryHash[@q]==value)&&'active' ,target: "_self",href: "/rests?q=#{key}")
        end
        )
      }
    end
  end

  def oLan_collection
    @languageHash[@language][:active] = "active"
    content_tag(:div, class: :collection) do 
      @languageHash.collect do |key, item|
        concat content_tag(:a, item[:showName], class: "collection-item #{item[:active]}", onclick: "languageChange(#{key})")
      end
    end
  end
end
