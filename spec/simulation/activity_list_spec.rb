require 'minitest/autorun'
require_relative '../../lib/simulation/activity_list'

describe Simulation::ActivityList do
  let(:activity) do 
    activity_stub = Struct.new(:start_time, :priority,
                               :header_conditions_fulfilled?, :execute)
    activity_stub.new
  end

  it "keeps id of each activity unique." do
    activity_example = Simulation::Activity.new(6, activity)
    activity_list = Simulation::ActivityList.new

    7.times { activity_list.add(activity) }
    activity_list.remove(activity_example)
    5.times { activity_list.add(activity) }

    id_list = activity_list.instance_variable_get(:@_list).map { |el| el.id }
    id_list.uniq.length.must_equal 11
  end
end