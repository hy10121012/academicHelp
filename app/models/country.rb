class Country < ActiveRecord::Base
  has_one :currency
end
