class SysProperty < ActiveRecord::Base

  def self.get_maker_benchmark
    obj = where(:name=>'maker_rate');
    if(obj.size>0)
      return obj[0].value
    else
      return 0.05
    end
  end

  def self.get_taker_benchmark
    obj = where(:name=>'taker_rate');
    if(obj.size>0)
      return obj[0].value
    else
      return 0.04
    end
  end

end
