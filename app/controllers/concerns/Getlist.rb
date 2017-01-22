module Getlist
  extend ActiveSupport::Concern
  def languageHash
    return {
        0 => ['EN','#fbadb9'],
        4 => ['한글','#f15c63'],
        2 => ['汉语','#fb8354'],
        6 => ['ES','#ffb533'],
        7 => ['DE','#9aca40'],
        8 => ['ITA', '#85c9f0'],
        9 => ['PO','#4b92c8'],
        10 => ['FR','#ddc1fc']
      }
  end
  
  def restCategoryHash
    
    return{
      0 => ['한식','Korean'] ,
      1 => ['일식','Japanese'],
      2 => ['양식','Western'],
      3 => ['중식','Chinese'],
      4 => ['치킨','Chicken'],
      5 => ['고기','Meat'],
      6 => ['분식/면','Snack']
    }
  end
end