require 'rubygems'
require "#{File.dirname(__FILE__)}/../lib/is_paranoid"
require 'activerecord'
require 'rails2_ruby2'
require 'rails2_ruby2/rails_init'
require 'yaml'
require 'spec'

def connect(environment)
  conf = YAML::load(File.open(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.establish_connection(conf[environment])
end

# Open ActiveRecord connection
connect('test')
load(File.dirname(__FILE__) + "/schema.rb")
