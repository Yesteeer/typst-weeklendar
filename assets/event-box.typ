#import "../lib.typ": *
#import "@preview/showybox:2.0.4": showybox

#let events = (
  (
    start: "2026-09-14T12:20", end: "2026-09-14T13:30",
    summary: "Hairdresser",
    fill: olive,
    show-hours: true,
  ),
  (
    start: "2026-09-17T06:15", end: "2026-09-17T09:45",
    summary: "Morning run",
    fill: maroon,
    show-hours: true,
  ),
  (
    start: "2026-09-19T08:00", end: "2026-09-20T17:00",
    summary: "Montain trip",
    description: [
      Don't forget to take
        - suncream
        - cap
        - pic-nic
        - ...
    ],
    fill: eastern,
    show-hours: false,
  ),
)

#let event-fct(event) = {
  let title = if event.show-hours [
    #event.summary \
    (#event.start.display("[hour]:[minute]") - #event.end.display("[hour]:[minute]"))
  ] else {event.summary}

  showybox(
    title: title,
    footer-style: (
      align: center,
    ),
    title-style: (
      weight: 900,
      color: black,
      align: center
    ),
    frame: (
      border-color: event.fill,
      title-color: event.fill.lighten(30%),
      body-color: event.fill.lighten(80%),
    ),
  )[
    #event.description
    #v(1fr)
  ]
}

#weeklendar(
  starting-date: "2026-09-14", 
  ending-date: "2026-09-20",
  event-fct: event-fct,
  ..events
)
