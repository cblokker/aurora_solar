require 'date'
Dir["./employee/*.rb"].each {|file| require file }
Dir["./building/*.rb"].each {|file| require file }

# Note: Expected output is in the format:
# "2022-09-28"=> {
# #<TwoStoryHome:0x00007fdf9e920088
#     @employees=
#      [#<CertifiedInstaller:0x00007fdf9e923120
#        @name="Installer-1",
#        @scheduled_days=[],
#        @unavailable_days=[]>,
#       #<Laborer:0x00007fdf9e920470
#        @name="Laborer-7",
#        @scheduled_days=[],
#        @unavailable_days=[]>],
#     @is_scheduled=true,
#     @name="TwoStoryHome-0">,
#    #<SingleStoryHome:0x00007fdf9e92be88
#     @employees=
#      [#<CertifiedInstaller:0x00007fdf9e9235f8
#        @name="Installer-0",
#        @scheduled_days=[],
#        @unavailable_days=[]>],
#     @is_scheduled=true,
#     @name="SingleStoryHome-0">],
#  } ... "2022-09-29"=> {...}


# {date: {buildingObject, buildingObject, ...}, ...}
# where building object has the list of employees working on the building for
# that given day

def schedule(buildings, employees)
  start_date = Date.today
  end_date = start_date + 5
  schedule = Hash.new { |l, m| l[m] = [] }

  available_employees = available_employees_by_date(employees, start_date, end_date)

  buildings.each do |building|
    work_week(start_date..end_date).each do |day|
      if building.schedule_employees!(available_employees[day.to_s])
        schedule[day.to_s] << building
      end
    end
  end

  schedule
end


def work_week(range)
  range.select { |d| (1..7).include?(d.wday) }
end


# Consider creating an EmployeeEnumerator class that can 'pluck' out Employees
def available_employees_by_date(employees, start_date, end_date)
  result = Hash.new{ |h, k| h[k] = Hash.new { |l, m| l[m] = []} }

  employees.each do |employee|
    work_week(start_date..end_date).each do |day|
      if employee.has_availability?(day)
        result[day.to_s][employee.class.name.underscore.to_sym] << employee
      end
    end
  end

  result
end



# monkey patch - indead of including ActiveSupport::Inflector
class String
  def underscore
    word = self.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
end


