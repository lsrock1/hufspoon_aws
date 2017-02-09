result=''
result << "식당,이름,종류,페이지구성,사진,대표메뉴,대표메뉴(영),주소,전화번호,영업시간,위도,경도"
result << "\r"
result << "메뉴,이름,이름(영),설명,가격,종류,페이지"
result << "\r"
@rests.each do |r|
  result << ['rest',r.name,r.food,r.page,r.picture,r.re_menu,r.ere_menu,r.chinese,r.address,r.phone,r.open,r.map.lat.to_s,r.map.lon.to_s].join(',')
  result << "\r"
  r.rmenu.each do|menu|
    result << ['menu',menu.menuname,menu.cmenuname,menu.emenuname,menu.content,menu.picture,menu.cost.to_s,menu.category.to_s,menu.pagenum.to_s].join(',')
    result << "\r"
  end
end

result.encode('utf-8')