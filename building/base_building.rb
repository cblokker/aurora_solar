# NOTE: Assumed dated_employees format:
# "2022-10-01"=> {
#  
# }

require 'pry'


class BaseBuilding
  INSTALL_TIME = 1 # Here just to indicate install time is always 1 day.

  attr_reader :name, :employees, :is_scheduled
  attr_writer :employees, :is_scheduled

  def initialize(name:, employees: [], is_scheduled: false)
    @name = name
    @employees = employees
    @is_scheduled = is_scheduled
  end

  def valid_scheduling_rules?(dated_employees); end

  def schedule_employees!(dated_employees)
    return if is_scheduled?
    return unless valid_scheduling_rules?(dated_employees)

    assign_employees!(dated_employees)

    @is_scheduled = true
  end

  def is_scheduled?
    is_scheduled
  end
end


class CommercialBuilding < BaseBuilding
  def valid_scheduling_rules?(dated_employees)
    dated_employees.values.flatten.size >= 8 &&
    dated_employees[:certified_installer].size >= 2 &&
    dated_employees[:installer_pending_certification].size >= 2
  end

  def assign_employees!(dated_employees)
    employees << dated_employees[:certified_installer].pop
    employees << dated_employees[:certified_installer].pop
    employees << dated_employees[:installer_pending_certification].pop
    employees << dated_employees[:installer_pending_certification].pop

    # Note: This will exhaust certified_installers faster than laborers
    #       A more random selection may keep a more even spread
    4.times do
      employees << dated_employees[:certified_installer].pop ||
                   dated_employees[:installer_pending_certification].pop ||
                   dated_employees[:laborer].pop
    end
  end
end


class SingleStoryHome < BaseBuilding
  def valid_scheduling_rules?(dated_employees)
    dated_employees[:certified_installer].size >= 1
  end

  def assign_employees!(dated_employees)
    employees << dated_employees[:certified_installer].pop
  end
end


class TwoStoryHome < BaseBuilding
  def valid_scheduling_rules?(dated_employees)
    dated_employees[:certified_installer].size >= 1 && (
      dated_employees[:laborer].size >= 1 ||
      dated_employees[:installer_pending_certification].size >= 1
    )
  end

  def assign_employees!(dated_employees)
    employees << dated_employees[:certified_installer].pop
    employees << dated_employees[:laborer].pop ||
                 dated_employees[:installer_pending_certification].pop
  end
end

