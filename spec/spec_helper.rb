require 'rubygems'

require 'bundler/setup'
Bundler.require :default

require "#{File.dirname(__FILE__)}/../lib/is_paranoid"
require 'active_record'
require 'active_support/all'
require 'yaml'

require 'rspec'

def connect(environment)
  conf = YAML::load(File.open(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.establish_connection(conf[environment])
end

# Open ActiveRecord connection
connect('test')
load(File.dirname(__FILE__) + "/schema.rb")
