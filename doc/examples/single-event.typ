#import "../../src/lib.typ": *

#let event = (
  start: "2026-09-16T08:30", // required
  end: "2026-09-16T12",      // required
  summary: "Math",           // optional with default: ""
  description: [Lecture \ Room 306B],  // optional with default: ""
  fill: red.lighten(80%),    // optional with default: blue.lighten(70%)
  repeat-until: none,        // optional with default: none
  repeat-frequency: none,    // optional with default: none
)

#weeklendar(
  starting-date: "2026-09-14",
  ending-date: "2026-09-20",
  event
) 
