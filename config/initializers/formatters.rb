Time::DATE_FORMATS[:date_with_hour] = lambda { |time|
  time.strftime("%B #{time.day.ordinalize} %Y, %l%p")
}

Time::DATE_FORMATS[:day_of_month] = lambda { |time|
  time.strftime("#{time.day.ordinalize} of %B")
}

Date::DATE_FORMATS[:day_and_date_and_year] = lambda { |date|
  date.strftime("%A %B #{date.day.ordinalize} %Y")
}

Date::DATE_FORMATS[:day_and_date] = lambda { |date|
  date.strftime("%A #{date.day.ordinalize} of %B")
}

Date::DATE_FORMATS[:day] = lambda { |date|
  date.strftime("%A")
}

Date::DATE_FORMATS[:ordinal_day] = lambda { |date|
  date.day.ordinalize
}

Date::DATE_FORMATS[:ordinal_date_and_month] = lambda { |date|
  date.strftime("%B #{date.day.ordinalize}")
}

Time::DATE_FORMATS[:ordinal_date_and_month] = lambda { |time|
  time.strftime("%B #{time.day.ordinalize}")
}
