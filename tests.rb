require 'rspec'
require 'json'
require './time_entry.rb'
require './api.rb'
require './time_util.rb'
require './tracker.rb'
require 'yaml'
require 'json'

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

RSpec.describe TimeUtil do

  it 'generates correct timestamps for today' do
    time = TimeUtil.new
    expect(time.today()[0]).to eq(Time.new.to_s[0,10] + 'T09:00:00.000+02:00')
    expect(time.today()[1]).to eq(Time.new.to_s[0,10] + 'T14:00:00.000+02:00')
  end

  it 'generates correct timestamps for yesterday' do
    time = TimeUtil.new
    expect(time.yesterday()[0]).to eq((Time.new - (60 * 60 * 24)).to_s[0,10] + 'T09:00:00.000+02:00')
    expect(time.yesterday()[1]).to eq((Time.new - (60 * 60 * 24)).to_s[0,10] + 'T14:00:00.000+02:00')
  end

end

RSpec.describe Tracker do

  it 'tracks today' do
    conf = YAML.load_file('./conf.yaml')
    time = TimeUtil.new
    tracker = Tracker.new
    body = tracker.track_today
    data = JSON.parse(body[0])["data"]
    expect(data["pid"]).to eq(conf['project.id'])
    expect(data["description"]).to eq(conf['project.description'])
    expect(data["start"]).to eq(Time.new.to_s[0,10] + 'T09:00:00.000+02:00')
    expect(data["stop"]).to eq(Time.new .to_s[0,10] + 'T13:00:00+02:00')
    data = JSON.parse(body[1])["data"]
    expect(data["pid"]).to eq(conf['project.id'])
    expect(data["description"]).to eq(conf['project.description'])
    expect(data["start"]).to eq(Time.new.to_s[0,10] + 'T14:00:00.000+02:00')
    expect(data["stop"]).to eq(Time.new .to_s[0,10] + 'T18:00:00+02:00')

  end

  it 'tracks yesterday' do
    conf = YAML.load_file('./conf.yaml')
    time = TimeUtil.new
    tracker = Tracker.new
    body = tracker.track_yesterday
    data = JSON.parse(body[0])["data"]
    expect(data["pid"]).to eq(conf['project.id'])
    expect(data["description"]).to eq(conf['project.description'])
    expect(data["start"]).to eq((Time.new - (60 * 60 * 24)).to_s[0,10] + 'T09:00:00.000+02:00')
    expect(data["stop"]).to eq((Time.new - (60 * 60 * 24)).to_s[0,10] + 'T13:00:00+02:00')
    data = JSON.parse(body[1])["data"]
    expect(data["pid"]).to eq(conf['project.id'])
    expect(data["description"]).to eq(conf['project.description'])
    expect(data["start"]).to eq((Time.new - (60 * 60 * 24)).to_s[0,10] + 'T14:00:00.000+02:00')
    expect(data["stop"]).to eq((Time.new - (60 * 60 * 24)).to_s[0,10] + 'T18:00:00+02:00')
  end

end
