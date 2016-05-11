require 'rspec'
require 'json'
require './time_entry.rb'
require './api.rb'
require 'yaml'

RSpec.describe TimeEntry do

  it 'prints a correct json' do
    time_entry = TimeEntry.new
    time_entry.description = "Meeting with possible clients"
    time_entry.tags = ["billed"]
    time_entry.duration = 1200
    time_entry.start = "2016-06-11T09:00:00.000Z"
    time_entry.pid = 123
    time_entry.created_with = "curl"
    expect(time_entry.to_json).to eq('{"time_entry":{"description":"Meeting with possible clients","tags":["billed"],"duration":1200,"start":"2016-06-11T09:00:00.000Z","pid":123,"created_with":"curl"}}')
  end
end

RSpec.describe Api do

  it 'sends a correct time entry' do
    conf = YAML.load_file('./conf.yaml')
    time_entry = TimeEntry.new
    time_entry.description = conf['project.description']
    time_entry.duration = 14400
    time_entry.start = "2016-05-11T09:00:00.000+02:00"
    time_entry.pid = conf['project.id']
    time_entry.created_with = "curl"
    api = Api.new('https://www.toggl.com/api/v8/time_entries', conf['token'])
    expect(api.create_time_entry(time_entry)).to match(/.*data.*Phoenix.*/)

  end

end
