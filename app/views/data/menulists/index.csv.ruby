result=''
result << "순서,한국어,독음,영어,일어,간체,번체,아랍어,스페인어,독일어,이탈리아어,포르투갈어,프랑스어,사진주소,좋아요"
result << "\r"
@menulist.each do |m|
  m=[m.id.to_s,m.kname,m.ername,m.ename,m.jnamea,m.cname,m.cnameb,m.aname,m.spanish,m.germany,m.italia,m.portugal,m.french,m.u_picture,m.u_like.to_s]
  result << m.join(',)
  result << "\r"
end

result.encode('utf-8')