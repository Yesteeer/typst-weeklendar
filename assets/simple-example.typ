#import "../lib.typ": *

#let events = (
  (
    start: "2026-09-18T09",
    end: "2026-09-18T12",
    summary: "Learning Typst",
    description: "Create a calendar package."
  ),
  (
    start: "2026-09-14T08:15",
    end: "2026-09-14T09:45",
    summary: "Yoga class",
    repeat-until: "2026-12-31",
    repeat-frequency: duration(days: 7),
    fill: green.lighten(60%)
  ),
  (
    start: "2026-09-26T10",
    end: "2026-09-27T17",
    summary: "Family trip",
    description: "Hiking with the whole family in the swiss mountains",
    fill: orange.lighten(60%)
  )
)

#weeklendar(
  starting-date: "2026-09-14",
  ending-date: "2026-09-27",
  events
) 
