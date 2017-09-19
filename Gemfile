source 'https://rubygems.org'

ruby '2.3.5'

gem 'rails', '~> 4.2.9'

gem 'decent_exposure',  '~> 3.0'
gem 'formtastic',       '~> 2.1'
gem 'haml',             '4.0.7'
gem 'hominid',          '3.0.2'
gem 'lu-tze',           '0.2.0', :require => 'lu_tze'
gem 'pg',               '~> 0.19.0'
gem 'will_paginate',    '3.0.4'

group :staging, :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'cucumber-rails', '1.5.0', :require => false
  gem 'email_spec',     '1.1.1'
  gem 'rspec-rails',    '~> 2.6'
  gem 'sass'
end

group :test do
  gem 'capybara',         '~> 2.0'
  gem 'database_cleaner', '~> 1.6.1'
  gem 'escape_utils',     '0.2.3'
  gem 'faker',            '0.3.1'
  gem 'machinist',        '2.0.0.beta2'
  gem 'timecop',          '0.3.5'
  gem 'test-unit'
  gem 'webmock'
end
