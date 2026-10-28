# frozen_string_literal: true

source 'https://rubygems.org'
gemspec

# parallel 2.x requires Ruby >= 3.3; pin to the 1.x line (>= 2.7) so the
# RuboCop toolchain still installs on the Ruby 3.2 CI job (gem supports >= 3.2).
gem 'parallel', '< 2.0'
