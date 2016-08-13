class OhomeController < ApplicationController
  def rightindex
    @id=params[:id]
    @num=params[:num]
    @lat=params[:lat]
    @lon=params[:lon]
    unless @id=="0"
      @re=Rest.find(@id)
    end
  end
  
  def index
    @one=Curate.find_by(:show => "1")
    @two=Curate.find_by(:show => "2")
    @three=Curate.find_by(:show => "3")
    @four=Curate.find_by(:show => "4")
    @five=Curate.find_by(:show => "5")
    @six=Curate.find_by(:show => "6")
  end
  
  def leftindex
    @beforeid=params[:beforeid]
    if @beforeid!=nil&&@beforeid!="0"
      @beforemark=Rest.find(@beforeid)
      @beforemap=Map.find(@beforemark.map_id)
    end
    @israndom="0"
    @dis=params[:dis]
    @num=params[:num] #음식종류별 화면
    @lat=params[:lat] #위도
    @lon=params[:lon] #경도
    @all=[]
    if @num=="1" #korean
      n="한식"
    elsif @num=="2" #japanese
      n="일식"
    elsif @num=="3" #western
      n="양식"
    elsif @num=="4" #chinese
      n="중식"
    elsif @num=="5"
     n="치킨"
    elsif @num=="6"
    n="고기"
    elsif @num=="7"
     n="분식/면"
    end
    if @num!="0"
      Map.all.each do|m|
       temp=[]
       string=[]
       restaurants=m.rests.where(:food => n)
       if restaurants.length>0 #한식,중식,일식으로 레스토랑 검색
         temp.append(m.lat)
         temp.append(m.lon)
         restaurants.each do|e|
          string.append([e.id,e.name])
         end
         temp.append(string)
         @all.append(temp)
       end
      end
    end
    

    # if @dis=="3"
    #   if @num=="0"
    #   offset = rand( Rest.count)
    #   randomrest = Rest.offset(offset).first
       
    #   else
    #     randomrest=Rest.where(:food => n)
    #     offset=rand(randomrest.count)
    #     randomrest=randomrest.offset(offset).first
        
        
    #   end
    #   if randomrest!=nil
    #   randmap=Map.find(randomrest.map_id)
    #   @lat=randmap.lat
    #   @lon=randmap.lon
    #   @randid=randomrest.id
    #   @randname=randomrest.name
    #   end
    #   @dis="1"
    #   @israndom="1"
    # end
    
  end
  
  def search
    key=params[:keyword]
    @keyword=key
    all=Rmenu.where("menuname like ?", "%" + key + "%")
    result=all.map {|i| i.rest_id }
    result=result.uniq
    
    @result=Rest.where(id: result)
  end
  
  
end
