#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'

dirname = File.dirname(__FILE__)
font_awesome_ver = ARGV[0]

result = {
  '' => ''
}

vars = File.read File.expand_path("font-awesome-#{font_awesome_ver}/less/variables.less", dirname)
vars.scan(/fa-var-(\S+):\s+\"\\f(.+)\";/) do |name, value|
  result[name] = ["F#{value}".to_i(16)].pack "U*"
end

filename = File.expand_path '../data/charmap/awesome.yml', dirname
File.write filename, YAML.dump(result)

source = File.expand_path "font-awesome-#{font_awesome_ver}/fonts/fontawesome-webfont.ttf", dirname
target = File.expand_path '../resources/fonts/fontawesome-webfont.ttf', dirname
FileUtils::Verbose.cp source, target
