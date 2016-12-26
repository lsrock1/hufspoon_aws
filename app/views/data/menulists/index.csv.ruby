result=''
result << "순서,한국어,독음,영어,일어,간체,번체,아랍어,스페인어,독일어,이탈리아어,포르투갈어,프랑스어,사진주소,좋아요"
result << "\r"
@menulist.each do |m|
  m=m.attributes.values[0..14]
  m.insert(12,m.delete_at(14))
  result << m.join(',')
  result << "\r"
end

result.encode('utf-8')