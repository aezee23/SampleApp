class Datacard

  @@records ||= Record.includes( church: [:church_group] ).where(
    day: (Date.today.last_year.beginning_of_month..Date.today)
  )

  @@index ||= 1

  @@colors =  [
    "rgba(0, 174, 115, 1)",
    "rgba(143, 54, 223, 1)",
    "rgba(230, 71, 89, 1)",
    "rgba(196, 184, 22, 1)",
    "rgba(94, 57, 67, 1)",
    "rgba(0, 115, 175, 1)",
    "rgba(10, 97, 68, 1)",
    "rgba(229, 126, 48, 1)",
    "rgba(103, 20, 223, 1)",
    "rgba(190, 111, 89, 1)",
    "rgba(156, 124, 22, 1)",
    "rgba(54, 87, 67, 0.89)",
    "rgba(40, 85, 175, 1)",
    "rgba(50, 67, 68, 1)",
    "rgba(179, 151, 48, 1)",
    "rgba(143, 54, 153, 1)",
    "rgba(230, 71, 189, 1)",
    "rgba(196, 184, 92, 1)",
    "rgba(94, 57, 157, 0.89)",
    "rgba(0, 115, 105, 1)",
    "rgba(10, 97, 20, 1)",
    "rgba(29, 196, 48, 1)"
  ]

  def initialize(month_start=Date.today.last_year.strftime("%b%Y"), month_end=Date.today.strftime("%b%Y"), options="")
    @month_start = Date.parse(month_start)
    @month_end = Date.parse(month_end)
    @group = options if !options.blank?
    @idx = @@index
    @@index += 1
    if options.blank?       
      @records = @@records.select{ |record| (@month_start..@month_end-1).include?(record.day) }
                          .select{ |record| record.church.sunday_meeting } 
    elsif options.split(":")[0] == 'church'
      @records = @@records.select{ |record| (@month_start..@month_end-1).include?(record.day) }
                        .select{ |record| record.church.name.strip == options.split(":")[1].strip }
    elsif options.split(":")[0] == 'region'
      @records = @@records.select{ |record| (@month_start..@month_end-1).include?(record.day) }
                        .select{ |record| record.church.church_group.region == options.split(":")[1] }
    elsif options.split(":")[0] == 'church_group'
      @records = @@records.select{ |record| (@month_start..@month_end-1).include?(record.day) }
                        .select{ |record| record.church.church_group.name == options.split(":")[1] }                  
    elsif options.split(":")[0] == 'city'
      @records = @@records.select{ |record| (@month_start..@month_end-1).include?(record.day) }
                        .select{ |record| record.church.city == options.split(":")[1] }
    elsif idx = options.split(":").find_index("attribute")
      @records = @@records.select{ |record| (@month_start..@month_end-1).include?(record.day) }
                          .select{ |record| record.church.sunday_meeting } 
      @attribute = [options.split(":")[idx+1].to_sym]
    end
    set_properties
  end

  def set_properties
    attributes.each { |attr| instance_variable_set("@#{attr.to_s}", avg(attr)) }
  end

  def to_json
    data.to_json
  end

  def data
    data = attributes.each_with_object({}) { |attr, hash| hash[attr] = avg(attr) }    
    data[:start_date] = @month_start.strftime("%d%b%Y")
    data[:end_date] = @month_end.strftime("%d%b%Y")
    data[:name] = @month_end - @month_start < 14 ? "Latest": "#{@month_start.strftime("%d%b%y")} - #{@month_end.strftime("%d%b%y")}"
    data[:grouping] = @group ? @group.split(":")[0].capitalize : "None"
    data[:group_name] = @group ? @group.split(":")[1] : "All UK"
    data[:color] = @@colors[(@idx -1) % @@colors.count]
    data[:show] = false
    data  
  end

  def self.records
    @@records
  end

  def self.colors
    @@colors
  end

  private

  def attributes
    @attribute ? @attribute : [:sunday_att, :first_timers, :new_converts, :nbs, :nbs_finish, :baptised, :fnb]
  end

  def sum(attribute)
    @records.map do |record| 
      record[attribute] || 0
    end.inject(&:+)
  end

  def weeks
    @records.map(&:day).uniq.count
  end

  def avg(attribute)
    divisor = weeks > 5 ? diff_months(@month_start, @month_end) : 1
    if attribute == :sunday_att
      divisor = [ weeks, 1].max
    end
    (sum(attribute).to_f / divisor).round(0)
  end

  def diff_months(date1, date2)
    if date1.day == date2.day
      (date2.year * 12 + date2.month) - (date1.year * 12 + date1.month)
    else
      (date2.year * 12 + date2.month + (date2.day.to_f / days_in_month(date2.month, date2.year))) - (date1.year * 12 + date1.month + (date1.day.to_f / days_in_month(date1.month, date1.year)))
    end
  end

  def days_in_month(month, year = Time.now.year)
    days = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    return 29 if month == 2 && Date.gregorian_leap?(year)
    days[month]
  end

end