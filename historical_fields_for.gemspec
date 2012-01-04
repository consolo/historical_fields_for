Gem::Specification.new do |s|
  s.name = 'historical_fields_for'
  s.version = '1.0.0'
  s.author = 'Taylor Redden'
  s.email = 'developers@consoloservices.com'
  s.summary = 'Historical Fields'
  s.description = 'Tracks fields historically over time when they get updated. Note, this should be placed after all the other before_save calls, that might set values and such.'
  s.homepage = 'https://redmine.consoloservices.com'
  s.require_path = '.'
  s.files = [ 'historical_fields_for.rb' ]
  s.add_dependency 'activerecord', '~> 2.3'
end