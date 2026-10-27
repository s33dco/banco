# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name         = 'banco'
  s.version      = '1.0.3'
  s.licenses     = ['MIT']
  s.summary      = "Make your bank's .csv file statement more readable"
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README.md'))
  s.author       = 's33d'
  s.email        = 'code@s33d.co'
  s.files = Dir['{bin,lib,spec}/**/*'] + %w[LICENSE README.md]
  s.homepage = 'https://github.com/s33dco/banco'
  s.executables   = ['banco']
  s.required_ruby_version = '>= 3.2'
  s.add_dependency 'bigdecimal'
  s.add_dependency 'csv'
  s.add_development_dependency 'rspec', '~> 3.13'
  s.add_development_dependency 'rake'
  s.post_install_message = 'Thanks for installing, hope your numbers are positive!'
end
