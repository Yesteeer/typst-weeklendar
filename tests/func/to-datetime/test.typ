#import "/src/func.typ": to-datetime

// test different accepted date format
#assert.eq(to-datetime("2026-11-30"), to-datetime("2026-11-30T00:00:01"))
#assert.eq(to-datetime("2026-11-30T02"), to-datetime("2026-11-30T02:00:00"))
#assert.eq(to-datetime("2026-11-30T02:30"), to-datetime("2026-11-30T02:30:00"))
#to-datetime("2026-11-30T02:30:47")

#let date-and-time = datetime(
  year: 2026,
  month: 11,
  day: 04,
  hour: 23,
  minute: 06,
  second: 59
)

#let date = datetime(
  year: 2026,
  month: 11,
  day: 04,
)

#let time = datetime(
  hour: 23,
  minute: 06,
  second: 59
)

// test transformation to datetime element
#assert.eq(to-datetime(date-and-time), date-and-time)
#assert.eq(to-datetime(date), date)
#assert.eq(to-datetime(time), time)


// errors to be detected by to-datetime function
#assert-panic(() => to-datetime("2026-10-32"))
#assert-panic(() => to-datetime("2026-10-30T"))
