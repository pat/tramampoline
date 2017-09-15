source 'https://rubygems.org'

ruby '2.3.5'

gem 'rails', '3.2.22.5'

gem 'decent_exposure',  '1.0.1'
gem 'formtastic',       '1.2.3'
gem 'haml',             '4.0.3'
gem 'hominid',          '3.0.2'
gem 'lu-tze',           '0.2.0', :require => 'lu_tze'
gem 'pg',               '0.18.4'
gem 'test-unit',        '~> 3.0'
gem 'will_paginate',    '3.0.4'

group :staging, :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'cucumber-rails', '1.0.2', :require => false
  gem 'email_spec',     '1.1.1'
  gem 'rspec-rails',    '2.6.1'
  gem 'sass'
end

group :test do
  gem 'capybara',         '1.1.1'
  gem 'database_cleaner', '0.6.7'
  gem 'escape_utils',     '0.2.3'
  gem 'faker',            '0.3.1'
  gem 'fakeweb',          '1.3.0'
  gem 'fakeweb-matcher', '1.2.2', :require => 'fakeweb_matcher'
  gem 'machinist',        '2.0.0.beta2'
  gem 'timecop',          '0.3.5'
end
