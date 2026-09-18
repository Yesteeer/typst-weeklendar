#import "@preview/cetz:0.5.2" as cetz
#import "func.typ": *

// A default function for title-fct
#let default-title-fct(monday) = {
  let sunday =  monday + duration(days: 6)
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

// A default function for days-fct
#let default-days-fct(monday, day-list, day-number) = {
  grid(
    columns: 1fr,
    align: center,
    [#day-list.at(day-number)],
  )
}

// A default function for event-fct
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

// A function that constructs a week's timetable title
#let build-week-title(
  monday,
  title-fct: auto,
  debug: false,
  padding: 0pt,
)= {
  block(
    width: 100%,
    stroke: if debug {red} else {none},
    below: padding,
  )[
    #{
      if title-fct != auto {
        title-fct(monday)
      } 
      else {
        default-title-fct(monday)
      }
    }
  ]
}

// A function that constructs a week's timetable
#let build-timetable(
  page,
  starting-date,
  days,
  monday,
  hours-positions,
  time,
  timetable,
  debug: false,
  events: (),
  event-fct: (event) => [],
) = {
  // Build the week's timetable
  cetz.canvas({
    // outer calendar border
    cetz.draw.rect((0,0), (timetable.width, timetable.height))

    // Successively display timelines
    for i in range(0, time.number) {
      
      let hour = duration(hours: 1)

      let time = time + (
        y-position : hours-positions.at(time.number - i)
      )

      // Time column on the left of the timetable
      cetz.draw.content(
        (time.x-position, time.y-position), 
        anchor: "east",
        [
          #box(
            width: time.x-position, 
            stroke: if debug {red} else {none}
          )[
            #align(center)[
              #(time.start +  i * hour).display("[hour]:[minute]")]]
        ] 
      )

      // Draw the timeline's straight dotted horizontal lines
      cetz.draw.line(
        (time.x-position, time.y-position), 
        (timetable.width - time.pad, time.y-position), 
        stroke: (dash: "dotted")
      )
    }

    // Successively display days names
    for i in range(0, days.list.len()) {
      cetz.draw.content(
        (days.positions.at(i) + days.width / 2 , timetable.height - days.pad.above), 
        anchor: "north",
        box(
          width: days.width,
          stroke: if debug {red} else {none}, 
          inset: (x: 15pt, y: 0pt),
        )[
          #{
            if days.fct != auto {
              (days.fct)(monday, days.list, i)
            } else {
              default-days-fct(monday, days.list, i)
            }
          }
        ]
      )
    }

    // Successively display events
    for event in events {
      add-event(
        event,
        days.positions,
        time.start,
        time.start + duration(hours: time.number),
        hours-positions.at(time.number),
        hours-positions.at(0),
        days.width,
        timetable.height - days.height,
        if event-fct != auto {
          event-fct
        }
        else {
          default-event-fct
        },
      )
    }
  })
}

// A function that constructs a week's calendar page
#let build-week(
  week-number,
  page,
  starting-date,
  days,
  time,
  title-fct,
  debug: false,
  events: (),
  event-fct: (event) => []
) = {

  // Generate a new page for the week's timetable
  std.page(
    margin: page.margin,
    height: page.height,
    width: page.width,
    {
      context{

        // Measure and build the week's title
        let monday = get-first-monday(starting-date) + (week-number - 1) * duration(days: 7)

        let title = build-week-title(
          monday,
          debug: debug,
          padding: page.margin.top,
          title-fct: title-fct
        )
        
        let title-dimensions = measure(width: page.width - (page.margin.left + page.margin.right), title)
          
        title

        // Compute the timetable's height and width
        let timetable = (
          height: page.height - (page.margin.bottom + title-dimensions.height + 2*page.margin.top),
          width: page.width - (page.margin.left + page.margin.right)
        )

        // Compute some useful quantities
        let time = time + (
          x-position : time.width + 2*time.pad
        )

        // Measure the days box height
        let days-dimensions = measure(
          for i in range(0, days.list.len()) {
            box(
              width: (timetable.width - time.x-position - time.pad) / days.list.len(),
              stroke: if debug {red} else {none}, 
              inset: (x: 15pt, y: 0pt),
            )[
              #{
                if days.fct != auto {
                  (days.fct)(monday, days.list, i)
                } else {
                  default-days-fct(monday, days.list, i)
                }
              }
            ]
          }
        )

        // Compute thetimetable's days horizontal positions, as well as the days' height and width
        let days = days + (
          positions : 
            subdivide(
            time.x-position,
            timetable.width - time.pad,
            days.list.len()
          ),
          height: days-dimensions.height + days.pad.above + days.pad.below,
          width: (timetable.width - time.x-position - time.pad) / days.list.len()
        )

        // Compute the timetable's times vertical positions
        let hours-positions = subdivide(
          0cm,
          timetable.height - days.height, 
          time.number + 1
        )

        // Build the week's timetable
        build-timetable(
          page,
          starting-date,
          days,
          monday,
          hours-positions,
          time,
          timetable,
          debug: debug,
          events: events,
          event-fct: event-fct,
        )
      }
    }
  )
}

/// This function generates a weekly calendar from a starting date to a end date. 
/// It displays events, which are parametrized by a dictionary.
///
/// -> content
#let weeklendar(

  /// The starting-date defines the first week  to be displayed in the calendar. 
  ///
  /// The date must be given with the following format (based on the ISO 8601 extended format): \
  /// - "dd-mm-yyyy"
  /// - "dd-mm-yyyyThh" 
  /// - "dd-mm-yyyyThh:mm" 
  /// - "dd-mm-yyyyThh:mm:ss" 
  ///
  /// Or directly as a datetime element.
  ///
  /// -> str
  starting-date: datetime.today(),

  /// The ending date defines the last  week to be displayed in the calendar. 
  ///
  /// The accepted date format are the same as for the starting-date.
  ///
  /// -> str
  ending-date: datetime.today() + duration(days: 7),

  /// The paper's height (not the same as the timetable's height !). -> length
  height: 21cm,

  /// The paper's width (not the same as the timetable's width !). -> length
  width: 29.70cm,

  /// The paper's margins, which define the timetable's height and width, together with the title's dimensions.
  /// 
  /// The top margin is applied above and below the title, so that the total distance between the top of the timetable
  /// and the top of the page is equal to the title's height + 2 \* margin.top. -> dictionary
  margin: (:),

  /// The days names to be displayed on the timetable. -> array
  days: (
    "Monday", 
    "Tuesday", 
    "Wednesday", 
    "Thursday", 
    "Friday", 
    "Saturday", 
    "Sunday"
  ),

  /// A function to customize the displayed days appearance. It takes the days' name list,
  /// the first week's monday date and the current day's number as arguments. -> auto | function
  days-fct: auto,

  /// The padding below and above the displayed days. -> dictionary
  days-pad : (:),

  /// The first timeline to appear on the timetable. -> datetime
  time-start: datetime(hour: 8, minute: 0, second: 0),

  /// The step between two successives displayed timelines. -> duration
  time-step: duration(hours: 1),

  /// The number of timelines.
  ///
  /// The spacing between consecutives timelines depends on this number. -> int
  time-number: 11,

  /// The width of the box containing the timeline's times. -> length
  time-width: 1cm,

  /// The padding on the left/right around the timeline's time (added to the time's width) and at the end of the timeline's line. -> length
  time-pad: 10pt,
  
  /// A custom function for generating weekly titles. It takes the first week's monday as an argument and builds a custom title depending on monday's date.
  ///
  /// -> auto | function
  title-fct: auto,

  /// A custom function for the generic content of an event. It takes an event  as an argument.
  /// It is recommended to build a content that expands vertically (for example by using `#v(1fr)`), 
  /// so that the events are displayed on the entire associated timeline.
  ///
  /// -> auto | function
  event-fct: auto,

  /// A debugging option to show some of the displayed element's boundaries. -> boolean
  debug: false,

  /// Events to be displayed on the calendar, passed as a positional arguments. 
  ///
  /// Each event is described by a dictionary with two mandatory arguments: `start` and `end`, 
  /// which are to be given in the ISO 8601 extended format (see `starting-date` above) or directly
  /// as a datetime element. \
  /// If you want to make a periodic event, then you can use `repeat-until` and `repeat-frequency`.
  /// You can add extra named arguments, that can be accessed by your custom `event-fct`.
  ///
  /// -> array
  ..events,

) = {

  // Check for unknown named arguments
  assert(
    events.named().len() == 0,
    message: "Unrecognized named argument provided.."
  )

  // Resolve starting and ending dates
  let (starting-date, ending-date) = (starting-date, ending-date).map(it => to-datetime(it))

  // Resolve padding
  let days-pad = (
    above: 0.5cm, 
    below: 0.5cm
  ) + days-pad

  // Resolve margins
  let margin = (
    left: 1.3cm,
    right: 1.3cm,
    top: 0.3cm,
    bottom: 1.3cm,
  ) + margin

  // Regroup page arguments
  let page = (
    margin: margin,
    height: height,
    width: width
  )

  // Regroup time arguments
  let time = (
    number: time-number,
    pad: time-pad,
    step: time-step,
    start: time-start,
    width: time-width
  )

  // Regroup days arguments
  let days = (
    list: days,
    pad: days-pad,
    fct: days-fct,
  )

  // Resolve events spanning on multiple days/weeks
  let resolved-events = ()
  for event in events.pos().map(it => to-datetime-event(it)) {
    resolved-events = resolved-events + resolve-event(
      event, 
      time.start - duration(
        hours: 1
      ), 
      time.start + duration(
        hours: time.number
      )
    )
  }

  // Resolve periodic events
  let repeated-events = ()
  for event in resolved-events {
    repeated-events = repeated-events + repeat-event(event)
  }

  // Loop over all weeks from starting-date to ending-date
  for week-number in range(1, calc.ceil((ending-date - starting-date).weeks()) + 1) {

    // Select the current week's events
    let current-events = ()
    for event in repeated-events {
      if event-starting(event, starting-date) == week-number {
        current-events.push(event)
      }
    }

    // Generate a new page for the week's timetable
    build-week(
      week-number,
      page,
      starting-date,
      days,
      time,
      title-fct,
      debug: debug,
      events: current-events,
      event-fct: event-fct
    )
  }
}          
