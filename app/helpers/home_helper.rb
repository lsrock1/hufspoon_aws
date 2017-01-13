module HomeHelper
  def menu_cache_key menu
    "menus-#{menu['name']}-#{menu['update']}-#{menu['id']}"
  end
  
  def lan_button(language,day)
    capture do
      language.collect{|key,value|
      concat(
        content_tag(:li) do
          content_tag(:a,value[0],class: "btn-floating align-center "+value[1],href: '/'+key.to_s+'/'+day.to_s)
        end
        )
      }
    end
  end
end
