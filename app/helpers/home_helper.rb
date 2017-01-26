module HomeHelper
  def menu_cache_key menu
    "menus-#{menu['name']}-#{menu['update']}-#{menu['id']}"
  end
  
  def tabs(day)
    hash={
      0 =>[['Around HUFS']],
      6 =>[['humanities']]
    }
    hash[day]= hash[day] ? hash[day] : [['humanities','active'],['faculty'],['skylounge']]
    capture do
      hash[day].collect{|name|
        concat (content_tag(:li,class: "tab col s3") do
          content_tag(:a,name[0].titleize,class: name[1],href: '#'+name[0])
        end)
      }
    end
  end
  
  def lan_button(language,day)
    capture do
      language.collect{|key,value|
      concat(
        content_tag(:li) do
          content_tag(:a,value[0],class: "btn-floating align-center ",style: "background-color: #{value[1]};",href: '/'+key.to_s+'/'+day.to_s)
        end
        )
      }
    end
  end
  
  def card_top(menu)
      content_tag(:div,class: 'card-content') do
        concat content_tag(:a,content_tag(:i,'&#xE561;'.html_safe,class: "material-icons rotate red-text text-lighten-1",'data-angle' => 0))
        concat content_tag(:span,menu['name'].titleize,class: 'card-title')
        concat content_tag(:a,content_tag(:i,'alarm_on'.html_safe,class: 'material-icons grey-text alarm right','data-id' => menu['main'].id, style: "display:none;"))
        concat content_tag(:div,"#{menu['time']} / #{menu['price']}",class: "caf_times")
        concat content_tag(:div,menu['menu'].shift.titleize,class: "caf_rep")
        concat(content_tag(:p) do
          concat card_content(menu['menu'])
        end)
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
      content_tag(:div,class: 'card-image') do
        concat image_tag(menu['main'].u_picture,class: 'u_picture')
      end
    end
  end
  
  def card_bottom_left(menu)
    content_tag(:div, class: "card-bottom-left") do
      concat(content_tag(:p) do
        if menu['ingre']!=nil
          concat menu['ingre'].map{|item| item.titleize}.join(",")
        end
        concat "&nbsp;".html_safe
      end)
    end
  end
  
  def card_bottom_middle(menu)
    content_tag(:div, class: "card-bottom-middle") do
      concat(content_tag(:p) do
        concat "#{menu['kcal']}"
        concat "&nbsp;".html_safe
      end)
    end
  end
  
  def card_bottom_right(menu)
    if cookies[menu['main'].kname.to_sym]=="1"||session[menu['main'].kname.to_sym]=="1"
      content_tag(:div, class: "card-bottom-right like white red-text text-lighten-3",id: menu['main'].id) do
        concat (content_tag(:p) do
          concat content_tag(:i,'favorite',class: "material-icons")
          concat "&nbsp;&nbsp;".html_safe
          concat menu['main'].u_like
        end)
      end
    elsif cookies[menu['main'].kname.to_sym]=="0"||session[menu['main'].kname.to_sym]=="0"
      content_tag(:div, class: "card-bottom-right like white grey-text",id: menu['main'].id) do
        concat (content_tag(:p) do
          concat content_tag(:i,'favorite_border',class: "material-icons")
          concat "&nbsp;&nbsp;".html_safe
          concat menu['main'].u_like
        end)
      end
    elsif cookies[menu['main'].kname.to_sym]==nil||session[menu['main'].kname.to_sym]==nil
      content_tag(:div, class: "card-bottom-right like white grey-text",id: menu['main'].id) do
        concat (content_tag(:p) do
          concat content_tag(:i,'favorite_border',class: "material-icons")
          concat "&nbsp;&nbsp;".html_safe
          concat menu['main'].u_like
        end)
      end
    end
  end
end
