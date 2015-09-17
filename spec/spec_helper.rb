$LOAD_PATH << File.expand_path('../', File.dirname(__FILE__))

Encoding.default_internal = Encoding.default_external = 'UTF-8'

require 'codeclimate-test-reporter'
require 'simplecov'

CodeClimate::TestReporter.start
SimpleCov.start

require 'moon/packages'
require 'moon-mock/load'
require 'moon-inflector/load'
require 'moon-prototype/load'
require 'moon-serializable/load'
require 'std/load'
require 'data_model/load'
require 'data_bags/load'
