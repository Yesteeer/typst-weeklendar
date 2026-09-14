#import "@preview/cetz:0.5.2" as cetz
#import "func.typ": *

// A function that constructs a week's timetable title
#let build-week-title(
  monday,
  title: auto,
  debug: false,
  padding: 0pt,
)= {
  block(
    width: 100%,
    stroke: if debug {red} else {none},
    below: padding,
  )[
    #{
      if title != auto {
        title(monday)
      } 
      else {
        align(center)[
          #text(20pt)[
            Stundenplan
          ] 
          #text(12pt)[
            \ #v(0pt) 
            Woche vom #(monday).display("[day]"). bis #(monday + duration(days: 6)).display("[day].[month].[year]")
          ] 
        ]
      }
    }
  ]
}

// A function that constructs a week's timetable
#let build-timetable(
  page,
  starting-date,
  days,
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
          height: .65em,
          stroke: if debug {red} else {none}, 
          inset: (x: 15pt),
        )[
          #align(center)[
            #days.list.at(i)
          ]
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
          (event) => {
            rect(width: 100%, fill: blue.lighten(70%), stroke: blue)[#grid(
              columns: (1fr),
              align: center,
              [#event.start.display("[hour]:[minute]") - #event.end.display("[hour]:[minute]")]
            )
            #v(1fr)]
          }
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
  weekly-title,
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
          title: weekly-title
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

        // Compute thetimetable's days horizontal positions, as well as the days' height and width
        let days = days + (
          positions : 
            subdivide(
            time.x-position,
            timetable.width - time.pad,
            days.list.len()
          ),
          height: (0.65em).to-absolute() + days.pad.above + days.pad.below,
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

  /// The starting-date defines the first week to be displayed in the calendar. 
  ///
  /// The date must be given with the following format (based on the ISO 8601 extended format): \
  /// - "dd-mm-yyyy"
  /// - "dd-mm-yyyyThh" 
  /// - "dd-mm-yyyyThh:mm" 
  /// - "dd-mm-yyyyThh:mm:ss" 
  ///
  /// -> str
  starting-date: datetime.today(),

  /// The ending date defines the last  week to be displayed in the calendar. 
  ///
  /// The accepted date format are the same as for the starting-date.
  ///
  /// -> str
  ending-date: datetime.today(offset: 1),

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
  //TODO: add default in other file
  days: ("Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"),

  /// The padding below and above the displayed days. -> dictionary
  days-pad : (above: 0.5cm, below: 0.5cm),

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
  
  /// A custom function for generating weekly titles. It takes the first week's day "monday" as an argument and build a custom title depending on monday's date.
  ///
  /// *Example:*
  /// TODO
  ///
  /// -> auto | function
  weekly-title: auto,

  /// A custom function for the generic content of an event. It takes an event  as an argument.
  /// It is important to build a content that expands vertically (for example by using `#v(1fr)`), 
  /// so that the event are displayed on the entire associated timeline.
  ///
  /// *Example:*
  /// TODO
  ///
  /// -> auto | function
  event-fct: auto,

  /// A debugging option to show some of the displayed element's boundaries. -> boolean
  debug: true,

  /// Events to be displayed on the calendar, each described by a dictionary. Passed as a positional argument.
  ///
  /// *Example:*
  ///
  /// TODO: Example + conversion to datetime (and explanations about format)!
  ///
  /// -> array
  events,

) = {

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
    pad: days-pad
  )

  // Resolve events spanning on multiple days/weeks
  let resolved-events = ()
  for event in events {
    resolved-events = resolved-events + resolve-event(
      event, 
      time.start, 
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
      weekly-title,
      debug: debug,
      events: current-events,
      event-fct: event-fct
    )
  }
}          
