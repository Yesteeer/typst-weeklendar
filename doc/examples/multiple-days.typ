#import "../src/lib.typ": *

#let event = (
  start: "2026-09-19T09:00", 
  end: "2026-09-20T17:30",     
  summary: "Typst workshop",
  description: [#v(1em)A workshop about the use of typst in teaching. #v(1em) Don't forget your laptop !],
  fill: rgb("#239dad").lighten(50%)
)

#weeklendar(starting-date: "2026-09-14", ending-date: "2026-09-20", event) 

