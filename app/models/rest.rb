class Rest < ActiveRecord::Base
    include SearchCop
  
    belongs_to :map
    has_many :rmenu, dependent: :destroy
    
    search_scope :search do
      attributes :food, :name
      attributes :rmenu => ["rmenu.menuname","rmenu.emenuname","rmenu.cmenuname"]
    end
end
