class Curate < ActiveRecord::Base

  def self.nowCurate id
    now=Time.now.in_time_zone("Seoul")
    q = self
    .where('"curates"."startDate" <= ? <= "curates"."endDate"', now)
    .where("dayOfWeek LIKE ? OR dayOfWeek LIKE ?", "%#{now.wday}%", "%#{8}%")
    .where("time LIKE ? OR time LIKE ?", "%#{now.hour+1}%", "%#{00}%")
    list=[]
    7.times do |num|
      sq=q.where(show: num+1)
      if sq.where(language: id).length==0
        sq=sq.where(language: 0)
      else
        sq=sq.where(language: id)
      end
      list.append(sq)
    end
    return list
  end

end
