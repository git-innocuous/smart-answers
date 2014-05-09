class StatePensionDateV2 < Struct.new(:gender, :start_date, :end_date, :pension_date)
  def match?(dob, sex)
    same_gender?(sex) and born_in_range?(dob)
  end

  def same_gender?(sex)
    gender == sex or :both == gender
  end

  def born_in_range?(dob)
    dob >= start_date and dob <= end_date
  end
end

class StatePensionQueryV2 < Struct.new(:dob, :gender)
  def self.find(dob, gender)
    state_pension_query = new(dob, gender)
    result = state_pension_query.run
    state_pension_query.account_for_leap_year(result.pension_date)
  end

  def run
    state_pension_dates.find{|p| p.match?(dob, gender)}
  end

  # Handle the case where the person's d.o.b. is 29th Feb
  # on a leap year and that the pension elligibility date falls
  # on a non-leap year. ActiveSupport will helpfully adjust the 
  # date back to 28th Feb, but the calculation should forward to
  # the 1st March according to DWP rules.
  #
  def account_for_leap_year(date)
    if leap_year_date?(dob) and !leap_year_date?(date) 
      date += 1
    end
    date
  end
  
  def leap_year_date?(date)
    date.month == 2 and date.day == 29
  end

  def state_pension_dates
    pension_dates_static + pension_dates_dynamic
  end

  def pension_dates_dynamic
    [
      StatePensionDateV2.new(:female, Date.new(1890,1,1), Date.new(1950, 4, 5), 60.years.since(dob)),
      StatePensionDateV2.new(:male, Date.new(1890,1,1), Date.new(1953, 12, 5), 65.years.since(dob)),
      StatePensionDateV2.new(:both, Date.new(1954,10,6), Date.new(1960, 4, 5), 66.years.since(dob)),
      StatePensionDateV2.new(:both, Date.new(1960,4,6), Date.new(1960, 5, 5), 66.years.since(dob) + 1.month),
      StatePensionDateV2.new(:both, Date.new(1960,5,6), Date.new(1960, 6, 5), 66.years.since(dob) + 2.months),
      StatePensionDateV2.new(:both, Date.new(1960,6,6), Date.new(1960, 7, 5), 66.years.since(dob) + 3.months),
      StatePensionDateV2.new(:both, Date.new(1960,7,6), Date.new(1960, 8, 5), 66.years.since(dob) + 4.months),
      StatePensionDateV2.new(:both, Date.new(1960,8,6), Date.new(1960, 9, 5), 66.years.since(dob) + 5.months),
      StatePensionDateV2.new(:both, Date.new(1960,9,6), Date.new(1960, 10, 5), 66.years.since(dob) + 6.months),
      StatePensionDateV2.new(:both, Date.new(1960,10,6), Date.new(1960, 11, 5), 66.years.since(dob) + 7.months),
      StatePensionDateV2.new(:both, Date.new(1960,11,6), Date.new(1960, 12, 5), 66.years.since(dob) + 8.months),
      StatePensionDateV2.new(:both, Date.new(1960,12,6), Date.new(1961, 1, 5), 66.years.since(dob) + 9.months),
      StatePensionDateV2.new(:both, Date.new(1961,1,6), Date.new(1961, 2, 5), 66.years.since(dob) + 10.months),
      StatePensionDateV2.new(:both, Date.new(1961,2,6), Date.new(1961, 3, 5), 66.years.since(dob) + 11.months),
      StatePensionDateV2.new(:both, Date.new(1961,3,6), Date.new(1977, 4, 5), 67.years.since(dob)),
      StatePensionDateV2.new(:both, Date.new(1977,4,6), Date.today + 1, 68.years.since(dob))
    ]
  end
  
  def self.has_month_offset?(dob) 
    dob >= Date.new(1960,4,6) and dob <= Date.new(1961,3,5)
  end

  def pension_dates_static
    @@pension_dates_static ||= YAML.load_file(Rails.root.join("lib", "data", "state_pension_dates_v2.yml"))
  end
end
