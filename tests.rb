require 'rspec'
require './time_entry.rb'

RSpec.describe TimeEntry do

  it 'prints a correct json' do
    time_entry = TimeEntry.new
    expect(time_entry.to_json()).to eq('{"time_entry":{}}')
  end

end
