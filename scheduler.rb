require 'date'
Dir["./employee/*.rb"].each {|file| require file }
Dir["./building/*.rb"].each {|file| require file }

# Note: Expected output is in the format:
# {"2022-09-27"=> [
#   {
#     :name => "CommercialBuilding-0",
#     :employees=> [
#       "Installer-11",
#       "Installer-10",
#       "PendingInstaller-11",
#       "PendingInstaller-10",
#       "Installer-9",
#       "Installer-8",
#       "Installer-7",
#       "Installer-6"
#     ]
#    },
#    {
#      :name => "TwoStoryHome-0",
#      :employees => [
#        "Installer-5",
#        "Laborer-11"
#      ]
#    }, ... {}

def schedule(buildings, employees)
  start_date = Date.today
  end_date = start_date + 5
  schedule = Hash.new { |l, m| l[m] = [] }

  available_employees = available_employees_by_date(employees, start_date, end_date)

  buildings.each do |building|
    work_week(start_date..end_date).each do |day|
      if building.schedule_employees!(available_employees[day.to_s])
        schedule[day.to_s] << building.present
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


