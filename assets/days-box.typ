#import "../src/lib.typ": *

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

#let days(monday, day-list, day-number) = {
  grid(
    columns: 1fr, // important to make the content really centered
    align: center,
    row-gutter: 10pt,
    [*#day-list.at(day-number)*],
    [#(monday + duration(days: day-number)).display("[day]")#super("th")]
  )
}

#let time(time) = {
  time.display("[hour repr:12]:[minute] [period case:lower]")
}

#weeklendar(
  time-number: 2,
  height: 8cm,
  title-fct: title,
  days-fct: days,
  time-fct: time,
)
