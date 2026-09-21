#import "/src/core.typ": weeklendar

#let events = (
  start: "2026-01-05T08",
  end: "2026-01-05T10",
  summary: [test],
  repeat-until: "2026-01-31",
  repeat-frequency: duration(weeks: 1),
  repeat-edit: (
    "1": "delete",
    "2": (
      end: "2026-01-05T12",
      description: [longer]
    )
  )
)

#weeklendar(
  starting-date: "2026-01-01",
  ending-date: "2026-02-01",
  events
)
