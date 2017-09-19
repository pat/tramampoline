source 'https://rubygems.org'

ruby '2.4.2'

gem 'rails', '~> 5.1.4'

gem 'decent_exposure',  '~> 3.0'
gem 'formtastic',       '~> 2.1'
gem 'haml',             '~> 5.0.3'
gem 'hominid',          '3.0.2'
gem 'lu-tze',           '0.2.0', :require => 'lu_tze'
gem 'pg',               '~> 0.21.0'

group :staging, :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'cucumber-rails', '1.5.0', :require => false
  gem 'email_spec',     '~> 2.1'
  gem 'rspec-rails',    '~> 3.6'
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
