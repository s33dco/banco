# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name         = 'banco'
  s.version      = '2.0.0'
  s.licenses     = ['MIT']
  s.summary      = 'Summarise bank statement CSV files from the command line'
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README.md'))
  s.author       = 's33d'
  s.email        = 'code@s33d.co'
  s.files = Dir['{bin,lib}/**/*'] + %w[LICENSE README.md CHANGELOG.md]
  s.homepage = 'https://github.com/s33dco/banco'
  s.executables = ['banco']
  s.required_ruby_version = '>= 3.2'
  s.add_dependency 'csv'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.13'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-performance'
  s.add_development_dependency 'rubocop-rspec'
  s.post_install_message = 'Thanks for installing, hope your numbers are positive!'
  s.metadata['rubygems_mfa_required'] = 'true'
end
