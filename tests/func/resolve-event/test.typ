#import "/src/func.typ": to-datetime, resolve-event

#let start = datetime(hour: 7, minute: 00, second: 00)
#let end = datetime(hour: 19, minute: 00, second: 00)

#let event-1 = (
  start: to-datetime("2026-01-01"),
  summary: [test event]
)

#let event-2 = (
  start: to-datetime("2026-01-01T08"),
  end: to-datetime("2026-01-01T12"),
)

#let expected-2 = (
  (
    start: to-datetime("2026-01-01T08"),
    end: to-datetime("2026-01-01T12"),
  ),
)

#let event-3 = (
  start: to-datetime("2026-01-01"),
  end: to-datetime("2026-01-02T13"),
)

#let expected-3 = (
  (
    start: to-datetime("2026-01-01"),
    end: to-datetime("2026-01-01T19"),
  ),
  (
    start: to-datetime("2026-01-02T07"),
    end: to-datetime("2026-01-02T13"),
  )
)

// fails if event has no start or end
#assert-panic(() => resolve-event(event-1, start, end))

// compare to expected output
#assert.eq(resolve-event(event-2, start, end), expected-2)
#assert.eq(resolve-event(event-3, start, end), expected-3)
