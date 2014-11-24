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

  def self.get_env_stage
    obj = where(:name=>'env_stage');
    if(obj.size>0)
      return obj[0].value.to_i
    else
      return 1
    end
  end

  def self.get_instance_email_address
    obj = where(:name=>'instance_email_address');
    if(obj.size>0)
      return obj[0].value
    else
      return'info@zhuxiewang.com'
    end

  end

end
