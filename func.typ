#import "@preview/cetz:0.5.2" as cetz

// A function to convert ISO-8601 dates as strings into a datetime element
#let to-datetime(date) = {
  let reg-complete = "^([1-2][0-9][0-9][0-9])-(0[1-9]|1[1,2])-(0[1-9]|[12][0-9]|3[01])[T](0[0-9]|[1][0-9]|[2][0-4]):(0[0-9]|[1-5][0-9]):(0[0-9]|[1-5][0-9])|([1-2][0-9][0-9][0-9])-(0[1-9]|1[1,2])-(0[1-9]|[12][0-9]|3[01])[T]((0[0-9]|[1][0-9]|[2][0-4]):(0[0-9]|[1-5][0-9]))|([1-2][0-9][0-9][0-9])-(0[1-9]|1[1,2])-(0[1-9]|[12][0-9]|3[01])[T](0[0-9]|[1][0-9]|[2][0-4])$"
  let reg-minimal = "^([1-2][0-9][0-9][0-9])-(0[1-9]|1[1,2])-(0[1-9]|[12][0-9]|3[01])$"
  assert(
    date.match(regex(reg-complete)) != none or (date.match(regex(reg-minimal)) != none and date.len() == 10), 
    message: "A date must be of the form \"dd-mm-yyyyThh:mm:ss\", \"dd-mm-yyyyThh:mm\", \"dd-mm-yyyyThh\" or \"dd-mm-yyyy\"."
  )
  let splitted = date.split("T")
  let (_date, _time) = if splitted.len() == 1 {
    (splitted.at(0), "00:01:00")
  } else {
    splitted
  }
  let seq = (_date.split("-") + _time.split(":") + ("0", "0")).map(it => int(it))
  return datetime(
    day: seq.at(2), 
    month: seq.at(1), 
    year: seq.at(0), 
    hour: seq.at(3),
    minute: seq.at(4),
    second: seq.at(5)
  )
}

// A function to change the time in a datetime
#let change-time(_datetime, hour, minute, second) = {
  datetime(
    year: int(_datetime.display("[year]")),
    month: int(_datetime.display("[month]")),
    day: int(_datetime.display("[day]")),
    hour: hour,
    minute: minute,
    second: second,
  )
}

// A function to subdivide a segment in a certain number of parts
#let subdivide(start, end, subdivisions) = {
  assert(start < end, message: "starting number should be < than the ending number")
  assert(type(subdivisions) == int, message: "the number of subdivisions should be an integer")

  let _step = (end - start) / subdivisions
  let pos = ()
  for i in range(0, subdivisions + 1, step: 1) {
    pos.push(start + i * _step)
  }

  return pos
}

// A fonction that returns the number of weeks between an event's week and the starting week
#let event-starting(event, starting-date) = {
  let starting-date = change-time(starting-date, 00, 00, 01)
  return calc.ceil((event.start - starting-date).weeks())
}

// A function that resolves the events spanning on multiple days/weeks
#let resolve-event(event, starting-hour, ending-hour) = {
  let result = ()
  let day = duration(days: 1)
  let current-start = event.start
  while current-start < event.end {
    result.push(event + (
      start: if current-start == event.start {
       event.start 
      } else {
        change-time(
          current-start, 
          int(starting-hour.display("[hour]")),
          int(starting-hour.display("[minute]")),
          int(starting-hour.display("[second]")),
        )
      },
      end: if (int(current-start.display("[day]")) + 0) < int(event.end.display("[day]")) {
        change-time(
          current-start,
          int(ending-hour.display("[hour]")),
          int(ending-hour.display("[minute]")),
          int(ending-hour.display("[second]")),
        )
      } else {
        event.end
      }
    ))
    current-start = current-start + duration(days: 1)
  }
  return result
}

// A function that resolves periodic events
#let repeat-event(event) = {
  let result = (event,)
  let current-start = event.start
  let current-end = event.end
  while event.repeat-until != none and current-start < event.repeat-until - duration(days: 7) {
    result.push(event + (
      start: current-start + event.repeat-frequency,
      end: current-end + event.repeat-frequency
    ))
    current-start = current-start + event.repeat-frequency
    current-end = current-end + event.repeat-frequency
  }
  return result
}

#let get-first-monday(starting-date) = {
  let day-number = starting-date.weekday()
  return starting-date - duration(days: day-number - 1) 
}

// A function that displays an event
#let add-event(event, days-positions, day-start, day-end, day-start-y, day-end-y, days-width, days-y-position, event-fct) = {
  let length-time-ratio = (day-start-y - day-end-y) / (day-end - day-start).hours()
  let start-time = datetime(
    hour: int(event.start.display("[hour]")),
    minute: int(event.start.display("[minute]")),
    second: int(event.start.display("[second]"))
  )
  let y-start = day-start-y + length-time-ratio * (day-start - start-time).hours()
  let event-duration = (event.end - event.start).hours()
  let height = length-time-ratio * event-duration
  for day in range(event.start.weekday(), event.end.weekday() + 1) {
    let x-start = days-positions.at(day - 1)
    let (x-end, y-end) = (x-start + days-width, y-start - height)
    cetz.draw.content(
      (x-start, if y-start > days-y-position {days-y-position} else {y-start}), 
      (x-end, if y-end < 0pt {0} else {y-end}), 
      event-fct(event) 
    )
  }
}
