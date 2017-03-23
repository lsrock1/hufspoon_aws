class Curate < ActiveRecord::Base

  def self.nowCurate id
    now = Time.now.in_time_zone("Seoul")
    baseQuery = self
    .where('"curates"."startDate" <= ?', now)
    .where('? <= "curates"."endDate"',now)
    .where('"curates"."dayOfWeek" LIKE ? OR "curates"."dayOfWeek" LIKE ?', "%#{now.wday}%", "%#{8}%")
    .where("time LIKE ? OR time LIKE ?", "%#{now.hour+1}%", "%#{00}%")
    result = {}
    placeToRecord = Hash.new{|hash, key| hash[key] = Hash.new{|hash, key| hash[key] = Array.new}}
    placeQuery = baseQuery.where(show: [1, 2, 3, 4, 5, 6, 7], language: [id, 0])
    placeQuery.each{|item| placeToRecord[item.show][item.language].append(item)}
    placeToRecord.each do |key, value|
      if value[id].length > 0
        result[key] = value[id]
      else
        result[key] = value[0]
      end
    end
    return result
  end

end
