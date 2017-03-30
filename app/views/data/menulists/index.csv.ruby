result=''
result << Menulist.column_names.join(",")
result << "\r"
@menulist.each do |m|
  result << m.as_json.values.join(',')
  result << "\r"
end

result.encode('utf-8')