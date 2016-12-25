result=''
result << "식당,이름,종류,페이지구성,사진종류,대표메뉴,대표메뉴(영),주소,전화번호,영업시간,위도,경도"
result << "\r"
result << "메뉴,이름,이름(영),설명,가격,종류,페이지"
result << "\r"
@rests.each do |r|
  result << 'rest,'+r.attributes.values[2..10].join(',')+','+r.map.lat.to_s+','+r.map.lon.to_s
  result << "\r"
  r.rmenu.each do|menu|
    result << 'menu,'+menu.attributes.values[2..7].join(',')
    result << "\r"
  end
end

result.encode('euc-kr')