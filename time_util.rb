class TimeUtil
  def today()
    [Time.new.to_s[0,10] + 'T09:00:00.000+02:00', Time.new.to_s[0,10] + 'T14:00:00.000+02:00']
  end

  def today_late_entrance(hours, minutes)
    h = (9 + hours).to_s.ljust(2, '0')
    m = minutes.to_s.ljust(2, '0')
    s1 = Time.new.to_s[0,10] + 'T09:00:00.000+02:00'
    s2 = Time.new.to_s[0,10] + 'T'+ h +':'+ m +':00.000+02:00'
    s3 = Time.new.to_s[0,10] + 'T14:00:00.000+02:00'
    if hours == 4 and minutes == 0 then
      return [s1, s3]
    elsif hours >= 4 then
      h = (9 + hours + 1).to_s.ljust(2, '0')
      s2 = Time.new.to_s[0,10] + 'T'+ h +':'+ m +':00.000+02:00'
      return [s1, s3, s2]
    else
      return [s1, s2, s3]
    end
  end

  def yesterday()
    [(Time.new - (60 * 60 * 24)).to_s[0,10] + 'T09:00:00.000+02:00', (Time.new - (60 * 60 * 24)).to_s[0,10] + 'T14:00:00.000+02:00']
  end
end
