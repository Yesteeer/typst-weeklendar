#import "@preview/tidy:0.4.3"
#import "../core.typ"
#import "../lib.typ": *

#set document(title: "Weeklendar")

#show raw.where(block: false): set raw(lang: "typc")
#show raw.where(block: true): it => rect(
  fill: luma(220),
  radius: 5pt,
  inset: (x: 5pt, y: 10pt),
  width: 100%,
  it
)

#v(5em)
#align(center)[
  #title() A weekly displayed calendar. #v(70%)

  Version 0.1.0 #v(0em)
  #datetime.today().display() #v(0em)
  #link("https://github.com/Yesteeer/typst-weeklendar")
]

#pagebreak()

= General syntax

Let us look at an example that uses all of weeklendar's features.

```typst
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
      repeat-frequency: duration(days: 7)
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
```
#grid(
  columns: (1fr, 1fr),
  image("../assets/simple-example.pdf", width: 100%, page: 1),
  image("../assets/simple-example.pdf", width: 100%, page: 2)
)

= Spacing and margin

WIP

= Customize event styling

WIP

#pagebreak()

= Weeklendar's API

#show heading.where(level: 2): set text(1.3em)
#show heading.where(level: 3): it => {
  set text(1.4em)
  set align(center)
  set block(below: 1.2em)
  it
}

#let core-functions = tidy.parse-module(
  read("../core.typ"),
  //name: "Weeklendar", 
  scope: (core: core),
  preamble: "#import core: *\n",
)

#tidy.show-module(
  core-functions, 
  style: tidy.styles.default, 
  //sort-functions: false, 
)
