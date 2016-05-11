require 'json'

class TimeEntry

  attr_accessor :description, :tags, :duration, :start, :pid, :created_with

  def to_json()
    JSON.dump (
    {
      :time_entry => {
        :description => @description,
        :tags => @tags,
        :duration => @duration,
        :start => @start,
        :pid => @pid,
        :created_with => @created_with
      }
    }
    )
  end

end
