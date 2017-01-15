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
          content_tag(:a,value[0],class: "btn-floating align-center "+value[1],href: '/'+key.to_s+'/'+day.to_s)
        end
        )
      }
    end
  end
  
  def card_top(menu)
    capture do
      concat content_tag(:span,menu['name'].titleize,class: "card-title card-time")
      concat content_tag(:div,'',class: :divider)
      concat(content_tag(:div,class: :section) do
        concat content_tag(:div,"#{menu['time']} / #{menu['price']}",class: "caf_times")
        concat content_tag(:div,menu['menu'].shift.titleize,class: "caf_rep")
        concat(content_tag(:p) do
          concat card_content(menu['menu'])
        end)
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
  
  def card_img(img)
    if img!=nil&&img!=""
      image_tag(img,height: 150,class: :u_picture)
    end
  end
  
  def card_bottom_left(ingre)
    content_tag(:div, class: "card-bottom-left") do
      concat(content_tag(:p) do
        if ingre!=nil
          concat ingre.map{|item| item.titleize}.join(",")
        end
        concat "&nbsp;".html_safe
      end)
    end
  end
  
  def card_bottom_middle(kcal)
    content_tag(:div, class: "card-bottom-middle") do
      concat(content_tag(:p) do
        concat kcal||""
        concat "&nbsp;".html_safe
      end)
    end
  end
  
  def card_bottom_right(main)
    if cookies[main.kname.to_sym]=="1"||session[main.kname.to_sym]=="1"
      content_tag(:div, class: "card-bottom-right like white red-text text-lighten-3",id: main.id) do
        concat content_tag(:i,'favorite',class: "material-icons")
        concat "&nbsp;&nbsp;".html_safe
        concat main.u_like
      end
    elsif cookies[main.kname.to_sym]=="0"||session[main.kname.to_sym]=="0"
      content_tag(:div, class: "card-bottom-right like white grey-text",id: main.id) do
        concat content_tag(:i,'favorite_border',class: "material-icons")
        concat "&nbsp;&nbsp;".html_safe
        concat main.u_like
      end
    elsif cookies[main.kname.to_sym]==nil||session[main.kname.to_sym]==nil
      content_tag(:div, class: "card-bottom-right like white grey-text",id: main.id) do
        concat content_tag(:i,'favorite_border',class: "material-icons")
        concat "&nbsp;&nbsp;".html_safe
        concat main.u_like
      end
    end
  end
end
