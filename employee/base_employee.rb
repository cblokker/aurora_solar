class BaseEmployee
  attr_reader :name, :unavailable_days, :scheduled_days 

  def initialize(name:, unavailable_days: [], scheduled_days: [])
    @name = name
    @unavailable_days = unavailable_days
    @scheduled_days = scheduled_days
  end

  def has_availability?(date)
    !unavailable_days.include?(date) ||
    !scheduled_days.include?(date)
  end
end


class CertifiedInstaller < BaseEmployee
end

class InstallerPendingCertification < BaseEmployee
end

class Laborer < BaseEmployee
end

# Note: Could define weekends within unavailable_days for flexibility, instead
#       of having that logic in work_week() method

# Note: scheduled_days is not being used here
