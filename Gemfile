def next?
  File.basename(__FILE__) == "Gemfile.next"
end
source 'https://rubygems.org'

gemspec

gem 'next_rails'
gem 'rspec'
gem 'pry-byebug'
gem 'pg', '~> 1.5.6'
gem 'ruby3-backward-compatibility'
gem 'bigdecimal'
gem 'base64'
gem 'logger'
gem 'benchmark'
gem 'mutex_m'

if next?
  source 'https://gems.railslts.com' do
    gem 'rails', '~> 4.2'
  end
else
  source 'https://gems.railslts.com' do
    gem 'rails', '~> 3.2'
  end
end
