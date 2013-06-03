require 'descriptive_statistics/safe'

module Simulation end

require File.join(File.dirname(__FILE__), 'simulation/base_process')
require File.join(File.dirname(__FILE__), 'simulation/process')
require File.join(File.dirname(__FILE__), 'simulation/system')
require File.join(File.dirname(__FILE__), 'simulation/process_list')
require File.join(File.dirname(__FILE__), 'simulation/current_list')
require File.join(File.dirname(__FILE__), 'simulation/future_list')
require File.join(File.dirname(__FILE__), 'simulation/coordinator')
require File.join(File.dirname(__FILE__), 'simulation/version')

require File.join(File.dirname(__FILE__), 'statistics/base_statistic')
require File.join(File.dirname(__FILE__), 'statistics/time_series')
require File.join(File.dirname(__FILE__), 'statistics/collector')