#!/usr/bin/env ruby
require 'ftools'

def camelize(lower_case_and_underscored_word)
  lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
end

puts "\n\nPlease enter the name of your gem:"
gem_name = gets.chomp

if gem_name !~ /^\s*$/
  module_name = camelize(gem_name)
else
  puts "I need a gem name that is not blank... c'mon..."
  exit(1)
end

puts "\nPlease enter your name:"
author_name = gets.chomp

puts "\nPlease enter your email:"
author_email = gets.chomp

puts "The git write URL is the git location where you will be storing your gem,"
puts "this needs read and write access, so be sure to enter the right one, for"
puts "example, git@github.com:rubyx/nugget.git"
puts "\nPlease enter the git write URL for your gem:"
giturl = gets.chomp

giturl =~ /^git@github.com:(\w+\/\w+).git$/
if $1
  git_path = $1
else
  puts "Does not look like a git read and write URL, sorry."
  exit(1)
end

puts "\n\nThank you, building the gem structure now\n"

##############################################################
## Directory Structure
puts "Making directory structure..."

File.makedirs("#{gem_name}/lib/#{gem_name}")
File.makedirs("#{gem_name}/spec")
File.makedirs("#{gem_name}/spec/#{gem_name}")

##############################################################
## Library Files
puts "Making top level library files..."

File.open("#{gem_name}/README.md", 'w') do |f|
  file_contents=<<ENDFILE
#{gem_name} readme
=========================

Decription
--------------------------

Usage
--------------------------

ENDFILE
  f.write(file_contents)
end

File.open("#{gem_name}/CHANGELOG", 'w') do |f|
  file_contents=<<ENDFILE

ENDFILE
  f.write(file_contents)
end

File.open("#{gem_name}/lib/#{gem_name}.rb", 'w') do |f|
  file_contents=<<ENDFILE
# encoding: utf-8
module #{module_name}
  require '#{gem_name}/version'
  require '#{gem_name}/base'
end
ENDFILE
  f.write(file_contents)
end

File.open("#{gem_name}/lib/#{gem_name}/base.rb", 'w') do |f|
  file_contents=<<ENDFILE
# encoding: utf-8
module #{module_name}
  class Base
    # Put your code here
  end
end
ENDFILE
  f.write(file_contents)
end

##############################################################
## Version Files
puts "Making version files..."

File.open("#{gem_name}/lib/VERSION", 'w') do |f|
  file_contents=<<ENDFILE
major:0
minor:0
patch:0
build:
ENDFILE
  f.write(file_contents)
end

File.open("#{gem_name}/lib/#{gem_name}/version.rb", 'w') do |f|
  file_contents=<<ENDFILE
# encoding: utf-8
module #{module_name}
  module VERSION

    version = {}
    File.read(File.join(File.dirname(__FILE__), '../', 'VERSION')).each_line do |line|
      type, value = line.chomp.split(":")
      next if type =~ /^\s+$/  || value =~ /^\s+$/
      version[type] = value
    end

    MAJOR = version['major']
    MINOR = version['minor']
    PATCH = version['patch']
    BUILD = version['build']

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')

    def self.version
      STRING
    end

  end
end
ENDFILE
  f.write(file_contents)
end


##############################################################
## Gemspec File
puts "Making #{gem_name}gemspec..."

File.open("#{gem_name}/#{gem_name}.gemspec", 'w') do |f|
  file_contents=<<ENDFILE
require File.dirname(__FILE__) + "/lib/#{gem_name}/version"

Gem::Specification.new do |s|
  s.name        = "mail"
  s.version     = #{module_name}::VERSION::STRING
  s.author      = ["#{author_name}"]
  s.email       = ["#{author_email}"]
  s.homepage    = "http://github.com/#{git_path}"
  s.description = ""  # Please fill in a short description
  s.summary     = ""  # Please fill in a longer summary

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "CHANGELOG.md"]

  # s.add_dependency('other_gem', ">= version")

  s.add_development_dependency "rspec"

  s.require_path = 'lib'
  s.files = %w(README.md Rakefile) + Dir.glob("lib/**/*")
end
ENDFILE
  f.write(file_contents)
end

##############################################################
## RakeFile
puts "Making Rakefile..."

File.open("#{gem_name}/Rakefile", 'w') do |f|
  file_contents=<<ENDFILE
begin
  require "rubygems"
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("1.0.0")
  raise RuntimeError, "Your bundler version is too old for Mail" +
   "Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end

require File.expand_path('../spec/environment', __FILE__)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

require "#{gem_name}/version"

task :build do
  system "gem build #{gem_name}.gemspec"
end

task :release => :build do
  system "gem push #{gem_name}-#{module_name}::VERSION::STRING}"
end
ENDFILE
  f.write(file_contents)
end

##############################################################
## Gemfile
puts "Making Gemfile..."
File.open("#{gem_name}/Gemfile", 'w') do |f|
  file_contents=<<ENDFILE
source :rubygems

# Add your run time dependencies here

group :test do
  gem "ZenTest"
  gem "rake"
  gem "bundler"
  gem "rspec"
  gem "diff-lcs"
  case
  when defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    # Skip it
  when RUBY_PLATFORM == 'java'
    # Skip it
  when RUBY_VERSION < '1.9'
    gem "ruby-debug"
  else
    # Skip it
  end
end
ENDFILE
  f.write(file_contents)
end

##############################################################
## Spec Folder
puts "Making Specs..."
File.open("#{gem_name}/spec/environment.rb", 'w') do |f|
  file_contents=<<ENDFILE
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
ENDFILE
  f.write(file_contents)
end

File.open("#{gem_name}/spec/spec_helper.rb", 'w') do |f|
  file_contents=<<ENDFILE
# encoding: utf-8
require File.expand_path('../environment', __FILE__)

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.join(File.dirname(__FILE__))
end

require '#{gem_name}'
ENDFILE
  f.write(file_contents)
end

File.open("#{gem_name}/spec/#{gem_name}/base_spec.rb", 'w') do |f|
  file_contents=<<ENDFILE
# encoding: utf-8
require 'spec_helper'

describe #{module_name}::Base do
  it "does something"
end
ENDFILE
  f.write(file_contents)
end


##############################################################
## Adding Git Remote
puts "Adding your git repository as origin..."
`cd #{gem_name} && git init`
`cd #{gem_name} && git remote add origin #{giturl}`

##############################################################
## Wrapping up
puts "\n\nCreation of gem #{gem_name} is complete"
puts "\nPlease change into your gem directory, edit the README.md and run:"

puts "$ git add README.md"
puts '$ git commit README.md -m "First commit'
puts '$ git push origin master'

puts "\nThen to start testing:"

puts '$ bundle install'
puts '$ rake'

puts "\nEnjoy!\n"
