require 'minitest/autorun'
require_relative '../../lib/simulation/activity'

describe Simulation::Activity do

  let(:correct_activity_stub) do 
    Struct.new(:start_time, :priority,
               :header_conditions_fulfilled?, :execute)
  end

  let(:incorrect_activity_stub) do
    Struct.new(:start_time, :priority)    
  end

  it "creates new activity when arguments are correct." do
    some_activity = correct_activity_stub.new(10, 1, nil, nil)
    activity = Simulation::Activity.new(1, some_activity)
    activity.must_be_instance_of Simulation::Activity
  end

  it "throws an error when activity is not correct." do
    some_activity = incorrect_activity_stub.new(10, 1)
    proc {  Simulation::Activity.new(1, some_activity) }.must_raise ArgumentError
  end

  it "throws an error when id is not correct." do
    some_activity = correct_activity_stub.new(10, 1, nil, nil)
    activity = Simulation::Activity.new(1, some_activity)
    proc {  Simulation::Activity.new(nil, some_activity) }.must_raise ArgumentError
  end  
end