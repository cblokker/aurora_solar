require_relative 'scheduler'
require "test/unit"


# 1. Test assignment of single story homes
# 1.a All buildings have expected employee types
# 1.b No employee is working on 2 buildings in same day
employees1 = []
buildings1 = []

5.times do |i|
  employees1 << CertifiedInstaller.new(name: "Bob-#{i}")
end


25.times do |i|
  buildings1 << SingleStoryHome.new(name: "Building-#{i}")
end

pp schedule(buildings1, employees1)



# # 2. Test assignment of two story homes
# # 2.a All buildings have expected employee types
# # 2.b No employee is working on 2 buildings in same day
employees2 = []
buildings2 = []

5.times do |i|
  employees2 << CertifiedInstaller.new(name: "Installer-#{i}",)
  employees2 << Laborer.new(name: "Laborer-#{i}",)
  employees2 << InstallerPendingCertification.new(name: "PendingInstaller-#{i}",)
end


45.times do |i|
  buildings2 << TwoStoryHome.new(name: "TwoStoryHome-#{i}")
end

pp schedule(buildings2, employees2)



# 3. Test assignment of commerical buildings
# 3.a All buildings have expected employee types
# 3.b No employee is working on 2 buildings in same day
employees3 = []
buildings3 = []

5.times do |i|
  employees3 << CertifiedInstaller.new(name: "Installer-#{i}",)
  employees3 << Laborer.new(name: "Laborer-#{i}",)
  employees3 << InstallerPendingCertification.new(name: "PendingInstaller-#{i}",)
end


45.times do |i|
  buildings3 << CommercialBuilding.new(name: "CommercialBuilding-#{i}")
end

pp schedule(buildings3, employees3)


# 4. Test assignment of mix of building types & employee types
# 4.a All buildings have expected employee types
# 4.b No employee is working on 2 buildings in same day
employees4 = []
buildings4 = []

12.times do |i|
  employees4 << CertifiedInstaller.new(name: "Installer-#{i}",)
  employees4 << Laborer.new(name: "Laborer-#{i}",)
  employees4 << InstallerPendingCertification.new(name: "PendingInstaller-#{i}",)
end


24.times do |i|
  buildings4 << CommercialBuilding.new(name: "CommercialBuilding-#{i}")
  buildings4 << TwoStoryHome.new(name: "TwoStoryHome-#{i}")
  buildings4 << SingleStoryHome.new(name: "SingleStoryHome-#{i}")
end

pp schedule(buildings4, employees4)


# 5. Test unavailable days
# 5.a For employee with unavailable days, ensure he gets assigned to projects
#     on days that he's available, and not on projects on days he's unavailable


# 6. Todo: Unit test Employee & Building classes as well

