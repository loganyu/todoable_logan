Gem::Specification.new do |s|
  s.name        = 'todoable_logan'
  s.version     = '0.0.1'
  s.date        = '2019-02-16'
  s.summary     = "Wrapper for the Teachable Todoable API"
  s.authors     = ["Logan Yu"]
  s.email       = 'yu.logan@gmail.com'
  s.files       = ["lib/todoable_logan.rb"]
  s.homepage    =
    'https://rubygems.org/gems/todoable_logan'
  s.license       = 'MIT'
  s.add_dependency('rest-client', '~> 1.8.0')
  s.add_dependency('json', '~> 1.8.3')

  s.add_development_dependency "rspec", "~> 3.4.0"
end