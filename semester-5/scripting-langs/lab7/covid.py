from datetime import datetime

class Covid_day:
  def __init__(self, date, cases, deaths):
    self._date = date
    self._cases = cases
    self._deaths = deaths
  
  def __str__(self):
    date_str = self._date.strftime("%d/%m/%Y")
    return "%s  %d  %d" % (date_str, self._cases, self._deaths)
 
a = Covid_day(datetime.strptime("11.08.2020", "%d.%m.%Y").date(), 100, 200)

print(a)