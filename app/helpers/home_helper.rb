module HomeHelper
  def menu_cache_key menu
    "menus-#{menu['name']}-#{menu['update']}-#{menu['id']}-bride"
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
    content_tag(:div,class: 'card-content card_top') do
      concat content_tag(:span, menu['name'].titleize,class: 'card-title')
      concat tag('br')
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
      concat content_tag(:div,content_tag(:i,'alarm_on'.html_safe,class: 'material-icons'),class:  'grey-text alarm','data-id' => menu['main'].id,'data-name' => menu['menu'][0], style: "display:none;")
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
    end
  end
  
  def like_icon(menu)
    if cookies[menu['main'].kname.to_sym]=="1"||session[menu['main'].kname.to_sym]=="1"
      content_tag(:div,class: 'like red-text text-lighten-3','data-id' => menu['main'].id,'data-name' => menu['menu'][0]) do
        concat content_tag(:i,'favorite',class: "material-icons")
        concat "&nbsp;&nbsp;".html_safe
        concat menu['main'].u_like
      end
    elsif cookies[menu['main'].kname.to_sym]=="0"||session[menu['main'].kname.to_sym]=="0"
      content_tag(:div,class: 'like grey-text','data-id' => menu['main'].id,'data-name' => menu['menu'][0]) do
        concat content_tag(:i,'favorite_border',class: "material-icons")
        concat "&nbsp;&nbsp;".html_safe
        concat menu['main'].u_like
      end
    elsif cookies[menu['main'].kname.to_sym]==nil||session[menu['main'].kname.to_sym]==nil
      content_tag(:div,class: 'like grey-text', 'data-id' => menu['main'].id,'data-name' => menu['menu'][0]) do
        concat content_tag(:i,'favorite_border', class: "material-icons")
        concat "&nbsp;&nbsp;".html_safe
        concat menu['main'].u_like
      end
    end
  end
end
