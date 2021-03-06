module HomeHelper
  def menu_cache_key menu
    "menus-#{menu[:name]}-#{menu[:update]}-#{menu[:id]}-bride"
  end
  
  def list_cache_key menu_list, lan
    "list-#{menu_list.map{|menu| menu[1][:update]}.reduce :+}-#{lan}"
  end
  
  def tabs
    hash = {
      0 =>[["AroundHUFS"], ["MENU_Preview"]],
      6 =>[["humanities"]]
    }
    array = hash[@w] ? hash[@w] : [["humanities", "active"], ["faculty"], ["skylounge"]]
    content_tag(:div, class: "toolbar z-depth-2") do
      content_tag(:ul, class: :tabs) do
        array.collect{|name|
          concat (content_tag(:li, class: :tab) do
            content_tag(:a, class: "#{name[1]}", href: "##{name[0]}", onclick: "ga('send', 'event', 'click', '#{name[0]}');") do
              concat content_tag(:i, "restaurant", class: "material-icons")
              concat tag(:br)
              concat content_tag(:span, name[0].titleize)
            end
          end)
        }
        concat (content_tag(:li, class: :tab) do
          content_tag(:a, href: "#language", onclick: "ga('send', 'event', 'click', 'language');") do
            concat content_tag(:i, :translate, class: "material-icons")
            concat tag(:br)
            concat content_tag(:span, "LANGUAGES")
          end
        end)
      end
    end
  end
  
  def lan_collection
    @languageHash[@id][:active] = "active"
    content_tag(:div, class: :collection) do 
      @languageHash.collect do |key, item|
        concat content_tag(:a, item[:showName], class: "collection-item #{item[:active]}", onclick: "languageChange(#{key}, #{@day})")
      end
      if admin_signed_in?
        concat content_tag(:a, "새로고침", class: "collection-item", href: "/refresh/#{@day}")
      end
    end
  end
  
  def card_top menu
    content_tag(:div, class: "card-content card_top") do
      concat content_tag(:div, menu[:name].titleize, class: "card-title")
      concat content_tag(:span, "#{menu[:time]} / #{menu[:price]}", class: "grey-text")
    end
  end
  
  def card_middle menu
    content_tag(:div, class: "card-content card_middle") do
      concat (content_tag(:div) do
        concat content_tag(:span, menu[:menu][0].titleize, class: "caf_main")
        concat content_tag(:span, "#{menu[:kcal]}", class: "right grey-text" )
      end)
      concat(content_tag(:div, class: "caf_menu") do
        concat card_content(menu[:menu][1..-1])
      end)
      concat (content_tag(:div, class: "caf_ingre") do
        if menu[:ingre] != nil
          concat menu[:ingre].map{|item| item.titleize}.join(",")
        end
      end)
    end
  end
  
  def card_bottom menu
    content_tag(:div, class: "card-action card-icon") do
      concat content_tag(:div, content_tag(:i, "alarm_on".html_safe, class: "material-icons"), class: "grey-text alarm", "data-id" => menu[:main].id, "data-name" => menu[:menu][0], "data-kname" => menu[:main]["kname"], style: "display: none;")
      concat like_icon(menu)
    end
  end
  
  def card_content menu
    length = 0
    html = ""
    menu.each do |item|
      if menu[0] != item
        length += item.length+3
        if length >= 32
          html += "<br/>"
          length = 0
          length += item.length + 3
        else
          html += " , "
        end
      else
        length += item.length + 3
      end
      html += item.titleize
    end
    return html.html_safe
  end
  
  def snack_image menu
    
  end
  
  def card_img menu
    if menu[:main].u_picture != nil && menu[:main].u_picture != ""
      content_tag(:div, class: "card-image c-image") do
        concat image_tag(menu[:main].u_picture, class: "u_picture")
      end
    else
      content_tag(:div, "", class: "divider")
    end
  end
  
  def like_icon menu
    if cookies[menu[:main].kname.to_sym] == "1" || session[menu[:main].kname.to_sym] == "1"
      content_tag(:div, class: "like red-text text-lighten-3", "data-id" => menu[:main].id, "data-name" => menu[:main]["kname"]) do
        concat content_tag(:i, "favorite", class: "material-icons")
        concat "&nbsp; &nbsp;".html_safe
        concat menu[:main].u_like
      end
    elsif cookies[menu[:main].kname.to_sym] == "0" || session[menu[:main].kname.to_sym] == "0"
      content_tag(:div, class: "like grey-text", "data-id" => menu[:main].id, "data-name" => menu[:main]["kname"]) do
        concat content_tag(:i, "favorite_border", class: "material-icons")
        concat "&nbsp; &nbsp;".html_safe
        concat menu[:main].u_like
      end
    elsif cookies[menu[:main].kname.to_sym] == nil || session[menu[:main].kname.to_sym] == nil
      content_tag(:div, class: "like grey-text", "data-id" => menu[:main].id, "data-name" => menu[:main]["kname"]) do
        concat content_tag(:i, "favorite_border", class: "material-icons")
        concat "&nbsp; &nbsp;".html_safe
        concat menu[:main].u_like
      end
    end
  end
  
  def curate list
    unless list.blank?
      capture do
        list.collect{|n|
          concat(content_tag(:div, class: :card) do
            concat(content_tag(:div, class: "card-image") do
              concat(content_tag(:a, image_tag(n.address), href: "#{n.keyword}", onclick: "ga('send', 'event', 'click', '#{n.keyword}', '#{@current_language}');"))
            end)
          end)
        }
      end
    end
  end

end
