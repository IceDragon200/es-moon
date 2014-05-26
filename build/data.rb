#!/usr/bin/env ruby

# EDOS data building
require 'build/data/entities'
require 'build/data/chunks'
require 'build/data/maps'

entities = ES::Database.where :entity
chunks   = ES::Database.where :chunk
maps     = ES::Database.where :map

entities.each(&:save_file)
chunks.each(&:save_file)
maps.each(&:save_file)

abort