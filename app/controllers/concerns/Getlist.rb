module Getlist
  extend ActiveSupport::Concern
  def languageHash
    return {#숫자 => 언어, 버튼색, 언어풀네임(영어로), 배경이미지
        4 => ["한국어",'#f15c63','korean'],
        2 => ["汉语",'#fb8354','chinese'],
        7 => ["Deutsch",'#9aca40','germany'],
        0 => ["English",'#fbadb9','english'],
        6 => ["Español",'#ffb533','spanish'],
        11 => ["Esperanto",'#ddc1fc','esperanto'],
        10 => ["Français",'#ddc1fc','france'],
        8 => ["Italiano", '#85c9f0','italia'],
        9 => ["Português",'#4b92c8','portugal'],
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