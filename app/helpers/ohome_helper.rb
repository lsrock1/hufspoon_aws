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
  
  def oLan_button
    capture do
      @languageHash.collect{|key,value|
      concat(
        content_tag(:li) do
          content_tag(:a, value[0], class: "btn-floating align-center ", style: "background-color: #{value[1]};", href: "/rests?q=#{@q}&language=#{key}")
        end
        )
      }
    end
  end
end
