class Menulist < ActiveRecord::Base
  
  def self.gettrans kname,id
    menu=self.find_by(kname: kname)
    if nil==menu
      self.new(:kname => kname,
        :ename => kname,
        :ername => kname,
        :jnamea => kname,
        :cname => kname,
        :cnameb => kname,
        :aname => kname,
        :spanish => kname,
        :germany => kname,
        :italia => kname,
        :portugal => kname,
        :french => kname).save()
      return kname
    else
      if id==0#영어
        word= menu.ename
      elsif id==1#일본어
        word= menu.jnamea
      elsif id==2#중국어 간체
        word= menu.cname
      elsif id==3# 중국어 번체
        word= menu.cnameb
      elsif id==4#한국어
        word= kname
      elsif id==5#아랍어
        word= menu.aname
      elsif id==6 #스페인어 
        word= menu.spanish
      elsif id==7 #독일어
        word= menu.germany
      elsif id==8 #이탈리아어
        word= menu.italia
      elsif id==9 #포르투갈어
        word= menu.portugal
      elsif id==10
        word= menu.french
      end
      if word!=""&&word!=nil
        return word
      else
        return kname
      end
    end
  end
  
end
