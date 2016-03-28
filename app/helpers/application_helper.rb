module ApplicationHelper

def median(array)
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

def mweek(date_or_time, start_day = :sunday)

  date = date_or_time
  week_start_format = start_day == :sunday ? '%U' : '%W'

  month_week_start = Date.new(date.year, date.month, 1)
  month_week_start_num = month_week_start.strftime(week_start_format).to_i
  month_week_start_num += 1 if month_week_start.wday > 4 # Skip first week if doesn't contain a Thursday

  month_week_index = date.strftime(week_start_format).to_i - month_week_start_num
  month_week_index + 1 # Add 1 so that first week is 1 and not 0

end

def sortable(column, title = nil)
  title ||= column.titleize
  css_class = column == sort_column ? "current #{sort_direction}" : nil
  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
end

  def date_of_last(day)
  date  = Date.parse(day)
  delta = date > Date.today ? -7 : 0
  date + delta
end

def date_of_next(day)
  date  = Date.parse(day)
  delta = date > Date.today ? 0 : 7
  date + delta
end
end
