# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "is_paranoid"
  s.version = "0.9.6"

  s.authors = ["Jeffrey Chupp"]
  s.date = "2009-09-26"
  s.description = ""
  s.email = "jeff@semanticart.com"
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = %w[.gitignore CHANGELOG MIT-LICENSE README.textile Rakefile VERSION.yml init.rb is_paranoid.gemspec lib/is_paranoid.rb spec/database.yml spec/is_paranoid_spec.rb spec/models.rb spec/schema.rb spec/spec.opts spec/spec_helper.rb]
  s.homepage = "https://github.com/Genius/is_paranoid"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = "ActiveRecord 2.3 compatible gem allowing you to hide and restore records without actually deleting them. Yes, like acts_as_paranoid, only with less code and less complexity."
  s.test_files = [
    "spec/is_paranoid_spec.rb",
    "spec/models.rb",
    "spec/schema.rb",
    "spec/spec_helper.rb"
  ]
end
