module OhomeHelper
  def tab_lists(language,select_language,food)
    select_language = select_language==4 ? 0 : 1
    language[food].append('active')
    capture do
      language.collect{|key,value|
      concat(
        content_tag(:li,class: 'tab col s3') do
          content_tag(:a,value[select_language],class: value[2] ,target: "_self",href: "/rests?num="+key.to_s)
        end
        )
      }
    end
  end
end
