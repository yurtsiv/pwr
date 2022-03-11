class Time(private var _hour: Int, private var _minute: Int) {
  checkHour(_hour)
  checkMinute(_minute)

  def hour = _hour
  def minute = _minute

  def hour_=(hour: Int) = {
    checkHour(hour)
    _hour = hour
  }

  def minute_=(minute: Int) = {
    checkMinute(minute)
    _minute = minute
  }

  def before(other: Time) =
    (_hour < other._hour) || (_hour == other._hour && _minute < other._minute)

  private def checkHour(h: Int) =
    if (h < 0 || h > 23)
      throw new IllegalArgumentException("Wrong hour value provided")

  private def checkMinute(m: Int) =
    if (m < 0 || m > 60)
      throw new IllegalArgumentException("Wrong minute value provided")

}