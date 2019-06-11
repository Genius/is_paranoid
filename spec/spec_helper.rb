require 'rubygems'

require 'bundler/setup'
Bundler.require :default

require "#{File.dirname(__FILE__)}/../lib/is_paranoid"
require 'active_record'
require 'active_support/all'
require 'yaml'
require 'spec'

module Arel
  module Visitors
    class DepthFirst < Arel::Visitors::Visitor
      alias_method :visit_Integer, :terminal
    end

    class Dot < Arel::Visitors::Visitor
      alias_method :visit_Integer, :visit_String
    end

    class ToSql < Arel::Visitors::Visitor
      alias_method :visit_Integer, :literal
    end
  end
end


def connect(environment)
  conf = YAML::load(File.open(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.establish_connection(conf[environment])
end

# Open ActiveRecord connection
connect('test')
load(File.dirname(__FILE__) + "/schema.rb")
