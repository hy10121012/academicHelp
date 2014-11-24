module WelcomeHelper
  def get_maker_count(count)
    count*3+120
  end

  def get_taker_count(count)
    count*3+120
  end

  def get_task_count(count)
    count*3+10
  end

  def get_turnover_count(turnover)
    turnover*3+2000
  end
end
