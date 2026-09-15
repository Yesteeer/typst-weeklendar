#import "../lib.typ": *

#let event = (
  start: "2026-09-16T15", 
  end: "2026-09-16T17",     
  summary: "Potery class",
  fill: purple.lighten(70%),
  repeat-until: "2026-10-05",
  repeat-frequency: duration(days: 7)
)


#weeklendar(starting-date: "2026-09-14", ending-date: "2026-10-11", event) 
