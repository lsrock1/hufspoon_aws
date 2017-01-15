module Getlist
  extend ActiveSupport::Concern
  def languageHash
    return {
        0 => ['EN','red'],
        4 => ['한글','yellow darken-1'],
        2 => ['汉语','green'],
        6 => ['ES','blue'],
        7 => ['DE','orange'],
        8 => ['ITA', 'light-blue'],
        9 => ['PO','teal'],
        10 => ['FR','amber']
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