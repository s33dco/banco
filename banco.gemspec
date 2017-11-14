Gem::Specification.new do |s| 
  s.name         = "banco"
  s.version      = "1.0.0"
  s.licenses     = ['MIT']
  s.summary      = "Make your bank's .csv file statement more readable"
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README'))
  s.author       = "s33d"
  s.email        = "code@s33d.co"
  s.files         = Dir["{bin,lib,spec}/**/*"] + %w(LICENSE README)
  s.homepage     = "https://github.com/s33dco/banco"
  s.test_files    = Dir["spec/**/*"]
  s.executables   = [ 'banco' ]
  s.required_ruby_version = '>=1.9'
  s.add_development_dependency 'rspec', '~>2.8'
  s.post_install_message = "Thanks for installing, hope your numbers are positive!"
end