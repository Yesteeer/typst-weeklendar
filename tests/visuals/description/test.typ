#import "/src/core.typ": weeklendar

#let event = (
  start: "2026-11-30T09",
  end: "2026-11-30T16",
  summary: [test],
  description: [
    #box(inset: 5pt, fill: red)[#lorem(20)]
  ]
)

#weeklendar(
  starting-date: "2026-11-30",
  ending-date: "2026-12-01",
  event
)
