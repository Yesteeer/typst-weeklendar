#import "/src/func.typ": relative-week-number

#let event-1 = (
  start: datetime(year: 2026, month: 01, day: 05, hour: 14, minute: 00, second: 00),
)

#let event-2 = (
  start: datetime(year: 2026, month: 01, day: 08, hour: 14, minute: 00, second: 00),
)

#let event-3 = (
  start: datetime(year: 2026, month: 01, day: 08, hour: 00, minute: 00, second: 30),
)

#let event-4 = (
  start: datetime(year: 2026, month: 01, day: 12, hour: 00, minute: 00, second: 01),
)

#let starting-date = datetime(
  year: 2026,
  month: 01,
  day: 01,
  hour: 10,
  minute: 00,
  second: 00
)

// check output
#assert.eq(relative-week-number(event-1, starting-date), 1)
#assert.eq(relative-week-number(event-2, starting-date), 1)
#assert.eq(relative-week-number(event-3, starting-date), 1)
#assert.eq(relative-week-number(event-4, starting-date), 2)
