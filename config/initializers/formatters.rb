Time::DATE_FORMATS[:date_with_hour] = lambda { |time|
  time.strftime("%B #{time.day.ordinalize} %Y, %l%p")
}

Date::DATE_FORMATS[:day_and_date] = lambda { |date|
  date.strftime("%A %B #{date.day.ordinalize} %Y")
}

Date::DATE_FORMATS[:ordinal_date_and_month] = lambda { |date|
  date.strftime("%B #{date.day.ordinalize}")
}

Time::DATE_FORMATS[:ordinal_date_and_month] = lambda { |time|
  time.strftime("%B #{time.day.ordinalize}")
}
