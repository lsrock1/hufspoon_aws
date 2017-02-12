class Curate < ActiveRecord::Base
  def self.nowCurate
    now=Time.now.in_time_zone("Seoul")
    q = self
    .where('startDate <= ?', now)
    .where('endDate >= ?', now)
    .where("dayOfWeek LIKE ? OR dayOfWeek LIKE ?", "%#{now.wday}%", "%#{8}%")
    .where("time LIKE ? OR time LIKE ?", "%#{now.hour+1}%", "%#{00}%")
    list=[]
    7.times do |num|
      list.append(q.where(show: num+1))
    end
    return list
  end
end
