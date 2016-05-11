class TimeUtil
  def today()
    [Time.new.to_s[0,10] + 'T09:00:00.000+02:00', Time.new.to_s[0,10] + 'T14:00:00.000+02:00']
  end
end