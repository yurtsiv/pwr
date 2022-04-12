# Stepan Yurtsiv 246437
# Lista 1, zad. 4

set subjects;

param preferences{1..4, subjects} >= 0;
param class_durations{subjects} >= 0;
param max_hours_daily >= 0;

var x{1..4, subjects} >= 0, <= 1, integer;

maximize obj: sum{n in 1..4, subject in subjects} preferences[n, subject] * x[n, subject];

# 1 class per subject
subject to class_for_{subject in subjects}: sum{n in 1..4} x[n, subject] == 1;

# no overlapping
subject to monday_1: x[1, 'Algebra'] + x[1, 'Analiza'] <= 1; 
subject to monday_2: x[1, 'ChemiaMin'] + x[1, 'ChemiaOrg'] + x[2, 'ChemiaMin'] <= 1; 
subject to tuesday_1: x[1, 'Fizyka'] + x[2, 'Algebra'] + x[2, 'Analiza'] + x[2, 'Fizyka'] <= 1;
subject to wednesday_1: x[3, 'Algebra'] + x[3, 'Analiza'] + x[4, 'Algebra'] <= 1;
subject to firday_1: x[4, 'ChemiaMin'] + x[4, 'ChemiaOrg'] <= 1;

# max hours daily
subject to max_hours_monday:
  x[1, 'Algebra'] * class_durations['Algebra'] +
  x[1, 'Analiza'] * class_durations['Analiza'] +
  x[1, 'ChemiaMin'] * class_durations['ChemiaMin'] +
  x[1, 'ChemiaOrg'] * class_durations['ChemiaOrg'] +
  x[2, 'ChemiaMin'] * class_durations['ChemiaMin'] +
  x[2, 'ChemiaOrg'] * class_durations['ChemiaOrg'] <= max_hours_daily;


subject to max_hours_tuesday:
  x[1, 'Fizyka'] * class_durations['Fizyka'] +
  x[2, 'Algebra'] * class_durations['Algebra'] +
  x[2, 'Analiza'] * class_durations['Analiza'] +
  x[2, 'Fizyka'] * class_durations['Fizyka'] <= max_hours_daily;

subject to max_hours_wednesday:
  x[3, 'Algebra'] * class_durations['Algebra'] +
  x[3, 'Analiza'] * class_durations['Analiza'] +
  x[4, 'Algebra'] * class_durations['Algebra'] <= max_hours_daily;

subject to max_hours_thursday:
  x[3, 'Fizyka'] * class_durations['Fizyka'] +
  x[3, 'ChemiaMin'] * class_durations['ChemiaMin'] +
  x[4, 'Analiza'] * class_durations['Analiza'] +
  x[4, 'Fizyka'] * class_durations['Fizyka'] <= max_hours_daily;

subject to max_hours_firday:
  x[3, 'ChemiaOrg'] * class_durations['ChemiaOrg'] +
  x[4, 'ChemiaMin'] * class_durations['ChemiaMin'] +
  x[4, 'ChemiaOrg'] * class_durations['ChemiaOrg'] <= max_hours_daily;

# lunch
subject to friday_lunch: x[4, 'ChemiaMin'] + x[4, 'ChemiaOrg'] + x[3, 'ChemiaOrg'] <= 1;

# exercise
subject to exercise:
  # monday 13-15
  x[1, 'Algebra'] + x[1, 'Analiza'] +
  # wednesday 11-13
  x[3, 'Algebra'] + x[3, 'Analiza'] + x[4, 'Algebra'] +
  # wednesday 15-13 (after 13 there's 1 hour lunch)
  x[3, 'Analiza'] + x[4, 'Algebra'] <= 2;

# TODO: remove
subject to test2: x[1, 'Algebra'] == 1;
subject to test3: x[2, 'ChemiaOrg'] == 1;

solve;

for {n in 1..4} {
  for {subject in subjects} {
    printf if x[n, subject] == 1 then "%s grupa %d\n" else "", subject, n;
  }
}

printf "Suma preferencji: %d", sum{n in 1..4, subject in subjects} preferences[n, subject] * x[n, subject];

data;

set subjects := Algebra Analiza Fizyka ChemiaMin ChemiaOrg;

param preferences: Algebra Analiza Fizyka ChemiaMin ChemiaOrg :=
  1 5  4 3 10 0
  2 4  4 5 10 5
  3 10 5 7 7  3
  4 5  6 8 5  4;

param class_durations :=
  Algebra 2
  Analiza 2
  Fizyka 3
  ChemiaMin 2
  ChemiaOrg 1.5;

param max_hours_daily := 4;