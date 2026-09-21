#import "/src/func.typ": change-time

#let date = datetime(
  year: 1999,
  month: 12,
  day: 31,
  hour: 04,
  minute: 36,
  second: 00
)

#let complete-date = datetime(
  year: 1999,
  month: 12,
  day: 31,
  hour: 23,
  minute: 59,
  second: 59
)

// should change the date with given time
#assert.eq(change-time(date, 23, 59, 59), complete-date)
