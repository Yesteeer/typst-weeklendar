#import "../../src/lib.typ": *

#let event = (
  start: "2026-09-16T15", 
  end: "2026-09-16T17",     
  summary: "Potery class",
  fill: purple.lighten(70%),
  repeat-until: "2026-10-30",
  repeat-frequency: duration(days: 7),
  repeat-edit: (
    "1": "delete",
    "2": (
      end: "2026-09-30T21",
      description: "followed by dinner"
    )
  )
)


#weeklendar(starting-date: "2026-09-14", ending-date: "2026-10-11", event) 
