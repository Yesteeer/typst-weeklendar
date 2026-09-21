#import "/src/core.typ": weeklendar

// event spanning across two weeks from different months
#let events = (
  start: "2026-01-31T09",
  end: "2026-02-02T11",
  summary: [test],
)

#weeklendar(
  starting-date: "2026-01-26",
  ending-date: "2026-02-08",
  events
)
