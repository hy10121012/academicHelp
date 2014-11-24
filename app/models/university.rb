class University < ActiveRecord::Base

  def self.find_unis_by_name_and_country(input, country)
    where("name like '%#{input}%' and country_id=#{country}").limit(5)
  end

  def self.find_uni_by_name_and_country(uni, country)
    unis = where("name like '%#{uni}%' and country_id=#{country}").limit(1)
    if(unis.size==1)
      unis[0]
    else
      false
    end
  end
end
