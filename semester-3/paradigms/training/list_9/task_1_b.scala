object Time {
  def apply(hour: Int) = new Time(hour)
}

class Time(private var _hour: Int) {
  if (_hour < 0) _hour = 0

  def hour = _hour

  def hour_=(newHour: Int): Unit =
    _hour = if (newHour < 0) 0 else newHour
}