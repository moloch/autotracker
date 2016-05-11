require './time_entry.rb'
require './api.rb'
require './time_util.rb'
require './tracker.rb'
require 'yaml'

class Tracker

  def track_today()
    conf = YAML.load_file('./conf.yaml')
    time = TimeUtil.new
    api = Api.new('https://www.toggl.com/api/v8/time_entries', conf['token'])
    morning = track(conf,api, time.today[0])
    afternoon = track(conf,api,time.today[1])   
  end

  def track(conf,api,time)
    time_entry = TimeEntry.new
    time_entry.description = conf['project.description']
    time_entry.duration = 14400
    time_entry.start = time
    time_entry.pid = conf['project.id']
    time_entry.created_with = "curl"
    api.create_time_entry(time_entry)
  end

end