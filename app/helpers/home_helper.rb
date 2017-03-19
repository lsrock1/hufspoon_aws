module HomeHelper
  def menu_cache_key menu
    "menus-#{menu['name']}-#{menu['update']}-#{menu['id']}-bride"
  end
  
  def list_cache_key menu_list, lan
    "list-#{menu_list.map{|menu| menu[1]['update']}.reduce :+}-#{lan}"
  end
  
  def tabs
    hash={
      0 =>[['Around HUFS']],
      6 =>[['humanities']]
    }
    hash[@w]= hash[@w] ? hash[@w] : [['humanities','active'],['faculty'],['skylounge']]
    capture do
      hash[@w].collect{|name|
        concat (content_tag(:li, class: :tab) do
          content_tag(:a, class: "#{name[1]}", href: "##{name[0]}") do
            concat content_tag(:i, "restaurant", class: "material-icons")
            concat tag(:br)
            concat content_tag(:span, name[0].titleize)
          end
        end)
      }
      concat (content_tag(:li, class: :tab) do
        content_tag(:a, href: "#language") do
          concat content_tag(:i, :translate, class: "material-icons")
          concat tag(:br)
          concat content_tag(:span, "LANGUAGE")
        end
      end)
    end
  end
  
  def lan_button
    left=-90
    content_tag(:ul) do
      @languageHash.collect.with_index{|value, index|
      concat(
        content_tag(:li) do
          content_tag(:a, value[1][0], class: "btn-floating align-center", style: "background-color: #{value[1][1]}; background-image: url(#{image_url(value[1][3])}); background-size: cover; background-repeat: no-repeat;", onclick: "languageChange(#{value[0]}, #{@day})")
        end
        )
      if (index+1)%6==0&&index>0
        concat("</ul><ul style='left: #{left}px;'>".html_safe)
        left=left-90
      elsif index==@languageHash.length-1&&admin_signed_in?
        concat(
          content_tag(:li) do
            content_tag(:a, content_tag(:i, 'refresh', class: 'material-icons'), class: 'btn-floating black align-center', href: '/refresh/#{@day}')
          end
        )
      end
      }
    end
  end
  
  def card_top(menu)
    content_tag(:div,class: 'card-content card_top') do
      concat content_tag(:div, menu['name'].titleize,class: 'card-title')
      concat content_tag(:span,"#{menu['time']} / #{menu['price']}",class: "grey-text")
    end
  end
  
  def card_middle(menu)
    content_tag(:div,class: 'card-content card_middle') do
      concat (content_tag(:div) do
        concat content_tag(:span,menu['menu'][0].titleize,class: "caf_main")
        concat content_tag(:span,"#{menu['kcal']}",class: 'right grey-text' )
      end)
      concat(content_tag(:div,class: 'caf_menu') do
        concat card_content(menu['menu'][1..-1])
      end)
      concat (content_tag(:div,class: 'caf_ingre') do
        if menu['ingre']!=nil
          concat menu['ingre'].map{|item| item.titleize}.join(",")
        end
      end)
    end
  end
  
  def card_bottom(menu)
    content_tag(:div,class: 'card-action card-icon') do
      concat content_tag(:div,content_tag(:i,'alarm_on'.html_safe,class: 'material-icons'),class:  'grey-text alarm','data-id' => menu['main'].id,'data-name' => menu['menu'][0], 'data-kname' => menu['main']['kname'], style: "display:none;")
      concat like_icon(menu)
    end
  end
  
  def card_content(menu)
    length=0
    html=''
    menu.each do |item|
      if menu[0]!=item
        length+=item.length+3
        if length>=32
          html+='<br/>'
          length=0
          length+=item.length+3
        else
          html+=" , "
        end
      else
        length+=item.length+3
      end
      html += item.titleize
    end
    return html.html_safe
  end
  
  def card_img(menu)
    if menu['main'].u_picture!=nil&&menu['main'].u_picture!=""
      content_tag(:div,class: 'card-image c-image') do
        concat image_tag(menu['main'].u_picture,class: 'u_picture')
      end
    else
      content_tag(:div,"",class: "divider")
    end
  end
  
  def like_icon(menu)
    if cookies[menu['main'].kname.to_sym]=="1"||session[menu['main'].kname.to_sym]=="1"
      content_tag(:div,class: 'like red-text text-lighten-3','data-id' => menu['main'].id,'data-name' => menu['main']['kname']) do
        concat content_tag(:i,'favorite',class: "material-icons")
        concat "&nbsp;&nbsp;".html_safe
        concat menu['main'].u_like
      end
    elsif cookies[menu['main'].kname.to_sym]=="0"||session[menu['main'].kname.to_sym]=="0"
      content_tag(:div,class: 'like grey-text','data-id' => menu['main'].id,'data-name' => menu['main']['kname']) do
        concat content_tag(:i,'favorite_border',class: "material-icons")
        concat "&nbsp;&nbsp;".html_safe
        concat menu['main'].u_like
      end
    elsif cookies[menu['main'].kname.to_sym]==nil||session[menu['main'].kname.to_sym]==nil
      content_tag(:div,class: 'like grey-text', 'data-id' => menu['main'].id,'data-name' => menu['main']['kname']) do
        concat content_tag(:i,'favorite_border', class: "material-icons")
        concat "&nbsp;&nbsp;".html_safe
        concat menu['main'].u_like
      end
    end
  end
  
  def curate(list)
    unless list.blank?
    capture do
      list.collect{|n|
        concat(content_tag(:div,class: :card) do
          concat(content_tag(:div,class: 'card-image') do
            concat(content_tag(:a,image_tag(n.address),href: "#{n.keyword}"))
          end)
        end)
      }
    end
    end
  end
end
