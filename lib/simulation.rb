Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file.gsub(/\.rb/, '') }

module Simulation end