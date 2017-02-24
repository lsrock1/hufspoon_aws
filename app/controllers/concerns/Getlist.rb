module Getlist
  extend ActiveSupport::Concern
  def languageHash
    return {
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
      '한식' => ['Korean',"Korean","Korean","Korean","한식"],
      '일식' => ['Japanese',"Japanese","Japanese","Japanese","일식"],
      '양식' => ['Western',"Western","Western","Western","양식"],
      '중식' => ['Chinese','Chinese','Chinese','Chinese',"중식"],
      '치킨' => ['Chicken','Chicken','Chicken','Chicken',"치킨"],
      '고기' => ['Meat','Meat','Meat','Meat',"고기"],
      '분식/면' => ['Snack','Snack','Snack','Snack',"분식/면"]
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