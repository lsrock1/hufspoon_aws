class Rest < ActiveRecord::Base
    belongs_to :map
    has_many :rmenu
end
