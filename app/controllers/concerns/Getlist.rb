module Getlist
  extend ActiveSupport::Concern
  def languageHash
    return {#숫자 => 언어, 버튼색, 언어풀네임(영어로), 배경이미지
        0 => ['EN','#fbadb9','english'],
        4 => ['한글','#f15c63','korean'],
        2 => ['汉语','#fb8354','chinese'],
        6 => ['ES','#ffb533','spanish'],
        7 => ['DE','#9aca40','germany'],
        8 => ['ITA', '#85c9f0','italia'],
        9 => ['PO','#4b92c8','portugal'],
        10 => ['FR','#ddc1fc','france'],
        11 => ['EP','#ddc1fc','esperanto','flag.png']
      }
  end
  
  def restCategoryHash
    return{#쿼리 => [영어,독음,중국어,일어,한국어]
      "한식" => ["Korean", "Korean","韩式","Korean","한식"],
      "세계" => ["World", "World","世界","World","세계"]
    }
  end
  
  def oLanguageHash
    return {
        0 => ['EN','#fbadb9','english'],
        4 => ['한글','#f15c63','korean'],
        2 => ['汉语','#fb8354','chinese']
      }
  end
end