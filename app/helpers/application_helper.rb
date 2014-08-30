module ApplicationHelper
  DATE_FORMAT = "%Y%m%d"

  def int_to_date(date_i)
    Date.strptime(date_i.to_s,DATE_FORMAT)
  end

end
