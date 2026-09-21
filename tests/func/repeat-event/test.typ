#import "/src/func.typ": to-datetime, repeat-event

#let event-1 = (
  start: to-datetime("2026-01-01"),
  end: to-datetime("2026-01-01T12"),
  repeat-until: none,
  repeat-frequency: duration(days: 7),
  repeat-edit: (:)
)

#let expected-1 = (
  event-1 + (
    __repeated-event-id__: 0,
  ),
)

#let event-2 = (
  start: to-datetime("2026-01-01"),
  end: to-datetime("2026-01-01T12"),
  repeat-until: to-datetime("2026-01-08"),
  repeat-frequency: duration(days: 7),
  repeat-edit: (:)
)

#let expected-2 = (
  event-2 + (
    __repeated-event-id__: 0,
  ),
)

#let event-3 = (
  start: to-datetime("2026-01-01"),
  end: to-datetime("2026-01-01T12"),
  repeat-until: to-datetime("2026-01-09"),
  repeat-frequency: duration(days: 7),
  repeat-edit: (:)
)

#let expected-3 = (
  event-3 + (
    __repeated-event-id__: 0,
  ),
  (
    start: to-datetime("2026-01-08"),
    end: to-datetime("2026-01-08T12"),
    repeat-until: to-datetime("2026-01-09"),
  repeat-frequency: duration(days: 7),
    repeat-edit: (:),
    __repeated-event-id__: 1,
  ),
)

// compare to expected output
#assert.eq(repeat-event(event-1), expected-1)
#assert.eq(repeat-event(event-2), expected-2)
#assert.eq(repeat-event(event-3), expected-3)
