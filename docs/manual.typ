#import "@preview/tidy:0.4.3"
#import "../core.typ"
#import "../lib.typ": *

#set page(numbering: "1")
#set par(justify: true)
#show heading.where(level: 1): set heading(numbering: "1.")
#show heading.where(level: 2): set heading(numbering: "1.")

#set document(title: "Weeklendar")

#show raw.where(block: false): set raw(lang: "typc")
#show raw.where(block: true): it => rect(
  fill: luma(220),
  radius: 5pt,
  inset: (x: 5pt, y: 10pt),
  width: 100%,
  it
)
#show image: it => align(center)[
  #rect(stroke: .5pt, inset: 0pt)[
    #it
  ]
]
#show ref: set text(purple)
#show link: set text(eastern)
#show heading.where(level: 1): it => {
  pagebreak()
  it
}

#v(5em)
#align(center)[
  #title() A weekly displayed calendar. 
  #v(15%)
  #image("../assets/readme-example-2.png", width: 90%)
  #v(15%)
  Version 0.1.0 #v(0em)
  #datetime.today().display() #v(0em)
  #link("https://github.com/Yesteeer/typst-weeklendar")
]

#outline()

= Generate a calendar page <intro>

By default, calling the `weeklendar()` function with empty events generates an empty timetable of `datetime.today()`'s week. This is only meant to have access to an empty page and to the current's week dates, not to be used permanently, since it is based on today's datetime !

```typst
  #import "local/weeklendar:0.1.0": *

  #weeklendar() 
```

#image("../assets/empty-example.pdf", page: 1, width: 100%)

It is composed of a title box, which displays a default title as well as the starting and ending dates of the corresponding week. You can't change the style of this default title box, but you can completely customize de title with a custom function (see @title). 

The timetable itself has an hourly timeline, which starts at "8:00" by default, and has 11 steps (i.e. it goes until 18:00). Those two parameters can be customized (`time-start` and `time-step`resp.). The horizontal spacings can be changed (see @spacing), but the vertical spacing between the lines and times can't be set manually and depends on the time numbers and the available space.

The days' name can also be customized (`days` argument). You can also change the number of days displayed, so you can remove week-ends if you are only intersted in working days. In this case, only use events happening on the first 5 days to avoid events to exceed the timetable. Note that you can only remove days at the end of the week, otherwise the displayed events won't match with the right days ! The spacing above and below the days' names can also be customized (see @spacing).

By changing the `starting-date` and `ending-date` you can add more weeks to your calendar. These dates determine which events will be displayed, and not the range of the displayed weeks ! 
= Add events

A calendar without events makes no sense ! So let us see how we can add events to our weeklendar. From now on, we will always fix starting and ending dates.

== Add a single event

An event is characterized by a dictionary containing at least a `start` and `end` datetime. Those can be specified either as an ISO 8601 extended format and some variants (see `starting-date`'s API) or directly as a complete `datetime` (but it seems painful to me to do it this way...).

```typst
  #let event = (
    start: "2026-09-16T08:30", // required
    end: "2026-09-16T12",      // required
    summary: "Math",           // optional with default: ""
    description: "Lecture in room 306B",  // optional with default: ""
    fill: red.lighten(80%),    // optional with default: blue.lighten(70%)
    repeat-until: none,        // optional with default: none
    repeat-frequency: none,    // optional with default: none
  )
```
The first 3 optional keys allow you to customize the default appearance of the displayed event. We will discuss the 2 other optional keys when we look at periodic events (see @periodic). We will see in @event-style that we can add further entries to an event's dictionary. Let's see what happens if we add this event to `weeklendar()`. From now on we will omit the package's import in the examples.

```typst
#weeklendar(starting-date: "2026-09-14", ending-date: "2026-09-20", event) 
```
#image("../assets/single-event-example.pdf", page: 1, width: 100%)

== Early or late events

It could happend that an event doesn't fit in the displayed timelines. Either you add more timelines, as explained in @intro, or you let the event exceed the timelines. The height of the displayed event's rectangle expands until 1 hour before the first one and 1 hour after the last one linearly and then it stops, even if the event starts earlier or ends later. Let us illustrate this with an example:

```typst
  #let events = (
    (
      start: "2026-09-16T06:30", 
      end: "2026-09-16T08:30",     
      summary: "Early morning walk",
    ),
    (
      start: "2026-09-18T17:30", 
      end: "2026-09-18T21",      
      summary: "Dinner",           
      description: "Bring a salad !",  
      fill: green.lighten(80%),   
    )
    (
      start: "2026-09-19T07:30", 
      end: "2026-09-19T09:30",     
      summary: "Morning walk",
    ),
  )

  #weeklendar(starting-date: "2026-09-14", ending-date: "2026-09-20", ..events) 
```
#image("../assets/exceed-event-example.pdf", page: 1, width: 100%)

== Events on multiple days

Weeklendar also manages events that span on multiple days. Let's suppose you want to add a two-day Typst workshop to your calendar. Then you add a single event with corresponding starting and ending datetimes and weeklendar does the job !

```typst
  #let event = (
    start: "2026-09-19T09:00", 
    end: "2026-09-20T17:30",     
    summary: "Typst workshop",
    description: [
      #v(1em)
      A workshop about the use of typst in teaching. 
      #v(1em) 
      Don't forget your laptop !
    ],
    fill: rgb("#239dad").lighten(50%)
  )

  #weeklendar(starting-date: "2026-09-14", ending-date: "2026-09-20", event) 
```
#image("../assets/multiple-days-example.pdf", page: 1, width: 100%)

For now, the description appears on both (or all) days of a multiple days event. This is for practical reasons, if an event spans on two weeks so that the information appears on both week's timetable. 

Also, when en events spans over more multiple days, the default timespans appearing on the event's boxes end 1 hour after the last timeline (in this case "19:00") and start 1 hour before the first timeline (here "7:00").

#pagebreak()

== Periodic events <periodic>

Periodic events are fairly common and it would be rather tideous to add the events one by one. Instead, weeklendar allows you to use the optional keys `repeat-until` and `repeat-frequency` to automatically generate multiple instances of a periodic event. In order to add periodic events, both of those parameters should be provided. `repeat-until` allow you to specify a datetime (same accepted format as for `start` or `end`) until which the given event should be repeated and `repeat-frequency` the frequency of the event (given as a `duration`). \
Each repetition of an event gets a repetition id (which starts at `0` for the first instance of the event). You can use this id to override the options or delete some instance of the event via the `repeat-edit` key to pass to the event dictionary. This is illustrated in the following example:

```typst
  #let event = (
    start: "2026-09-16T15", 
    end: "2026-09-16T17",     
    summary: "Potery class",
    fill: purple.lighten(70%),
    repeat-until: "2026-10-30",
    repeat-frequency: duration(days: 7),
    repeat-edit: (
      "1": "delete",
      "2": (end: "2026-09-30T21", description: "followed by dinner")
    )
  )

  #weeklendar(starting-date: "2026-09-14", ending-date: "2026-10-11", event) 
```
#grid(
  columns: 2,
  [#image("../assets/periodic-event-example.pdf", page: 1, width: 100%)],
  [#image("../assets/periodic-event-example.pdf", page: 2, width: 100%)],
  [#image("../assets/periodic-event-example.pdf", page: 3, width: 100%)],
  [#image("../assets/periodic-event-example.pdf", page: 4, width: 100%)],
)

//As you can see, a single event is repeated until the given date, then it stops. If `weeklendar()`'s `ending-date` is sooner than the `repeat-until` date, then those repeated events that come after the `ending-date` won't appear.


= Margins and spacing <spacing>

Let us now see how we can customize spacing and margin of the timetable. First we can change the margins around the title and timetable. The `left`, `right` and `bottom` margins work as expected, since they correspond to the distance between the page's borders and the timetable's borders. The `top` margin however, is the space that appears at the top *and* the bottom of the title's box. By calling `weeklendar(debug: true)` one can visualize how these work:

#image("../assets/debug-example.pdf", page: 1, width: 100%)

On the example above, the following default margins are used: `(left: 1.3cm, right: 1.3cm, top: 0.3cm, bottom: 1.3cm)`. Those defaults don't appear in the API, but are later combined with the `weeklendar`'s `margin` argument, so that margins can be individually overwritten.

On the debug timetable, the red box around the times have width `time-width` + 2\*`time-pad` (left and right padding). This same `time-pad` is added at the end of each timeline. Their height is determined by their content.

Finally, the padding above and below the days' names can be changed vie the `days-pad` argument, with defaults: `(above: 0.5cm, below: 0.5cm)`. Note that `days-pad.below` gives the space between the bottom of the days' debug-box (which height is based on its content and width on the length of the timelines) and the top of an event which starts at "7:00" (and not to the first timeline). That explains why the space between the days' names and the first timeline is bigger than the spacing above, although the padding is the same.

= Customize title box <title>

The title and subtitle of a week's timetable can't be changed. However, you can provide `weeklendar()` as custom `title-fct` function to generate you own title boxes. The only constraint are that the function must take the first week's monday datetime as an argument and that its margins are determined by the `margin` argument. The default function that is used is the following:

```typst
  #let default-title-fct(monday) = {
    let sunday = monday + duration(days: 6)
    grid(
      columns: 1fr,
      align: center,
      inset: 15pt,
      [
        #set text(20pt)
         Week of #(monday).display("[day]") to #sunday.display("[day] [month repr:long] [year]")
      ],
    )
  }
```

We can for example only show the `month` and the week number.

```typst
  #let title(monday) = (
    grid(
      columns: 1fr, // important to make the content really centered
      align: center,
      row-gutter: 15pt,
      [
        #set text(20pt)
        #monday.display("[month repr:long] [year]") 
      ],
      [Week number: #monday.display("[week_number]")]
    )
  )

  #weeklendar(
    time-number: 2,
    height: 8cm,
    weekly-title: title,
  )
```

#image("../assets/title-box-example.pdf", page: 1, width: 100%)

= Customize days names <days-name>

The previous example looks good, but it would be nice to have the dates of the week's days somewhere. What about next to or below the days names ? That is the content of this section

With the same idea, we can also customize the days appearance in the timetable by providing our own `days-fct` function. This function should take two arguments: the date of the week's monday, and the day's name to display. The default function only uses the former argument:

```typst
  #let default-days-fct(monday, day-list, day-number) = {
    grid(
      columns: 1fr, // important to make the content really centered
      align: center,
      [#day-list.at(day-number)],
    )
  }
```

But let's say that we want to display the day's date below its name, then we can complete our previous example as follows:

```typst
  #let title(monday) = [...]

  #let days(monday, day-list, day-number) = {
    grid(
      columns: 1fr, // important to make the content really centered
      align: center,
      row-gutter: 10pt,
      [#day-list.at(day-number)],
      [#(monday + duration(days: day-number)).display("[day]")#super("th")]
    )
  }

  #weeklendar(
    time-number: 2,
    height: 8cm,
    title-fct: title,
    days-fct: days,
  )
```
#image("../assets/days-box-example.pdf", page: 1, width: 100%)


= Customize event styling <event-style>

Finally, the event's boxes can also be fully customized. If you're not happy with the default layout, you can provide your own `event-fct` which takes an `event` dictionary as an argument. The default function is defined as:

```typst
#let default-event-fct(event) = {
    rect(
      width: 100%, 
      height: 100%,
      fill: event.fill, 
      stroke: black + .5pt,
      inset: (x: 5pt, y: 2pt),
    )[
      #grid(
        columns: 1fr, // makes content really centered
        rows: 1fr, // makes the event's box take all the allocated vertical space
        inset: 5pt,
        align: (x, y) => {
          if y == 0 { top + center }
          else if y == 1 { horizon + center }
          else { bottom + center }
        },
        [
          #text(size: 1.1em)[*#event.summary*]
        ],
        [
          #event.description
        ],
        [
          #event.start.display("[hour]:[minute]") - #event.end.display("[hour]:[minute]")
        ]
      )
    ]
  }
```
The important thing to keep in mind is that whatever content you build for your event, make sure that it takes the whole allocated vertical and horizontal space. Otherwise, the events won't appear properly. The nice thing here, is that you can provide additional keys to your events, which will then be accessible to your custom `event-fct` function !

As an example, we will use the #link("https://typst.app/universe/package/showybox")[Showybox] package to customize our events. We will keep things simple, but the customization possibilities are endless. Here we simply want to add the posibility to remove the hours when not necessary, so each of our events will have to provide a `show-hours` key. The rest is just re-styling.

```typst
  #import "local/weeklendar:0.1.0": *
  #import "@preview/showybox:2.0.4": showybox

  #let events = (
    (
      start: "2026-09-14T12:18", end: "2026-09-14T14:18", summary: "Hairdresser",
      fill: olive, show-hours: true,
    ),
    (
      start: "2026-09-17T06:15", end: "2026-09-17T09:45", summary: "Morning run",
      fill: maroon, show-hours: true,
    ),
    (
      start: "2026-09-19T08:00", end: "2026-09-20T17:00", summary: "Montain trip",
      description: [
        Don't forget to take
          - suncream
          - cap
          - pic-nic
          - ...
      ], fill: eastern, show-hours: false,
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
    starting-date: "2026-09-14", ending-date: "2026-09-20", event-fct: event-fct, ..events
  )
```
#image("../assets/event-box-example.pdf", page: 1, width: 100%)



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
