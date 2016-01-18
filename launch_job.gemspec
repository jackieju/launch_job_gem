Gem::Specification.new do |s|
  s.name        = 'launch_job'
  s.version     = '0.0.1'
  s.date        = '2016-01-05'
  s.summary     = "Help launch a ruby backend job!"
  s.description = "Help launch a ruby backend job!"
  s.authors     = ["Ju Weihua (Jackie Ju)"]
  s.email       = 'jackie.ju@gmail.com'
  s.files       = ["lib/launch_job.rb"]
  s.homepage    =
    'http://rubygems.org/gems/launch_job'
  s.license       = 'MIT'
  # add executables
  #s.executables << 'launch_job'
  # dependency
  s.add_dependency 'ps_grep'

end
