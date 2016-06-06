class Map < ActiveRecord::Base
    has_many:rests, dependent: :destroy
end
