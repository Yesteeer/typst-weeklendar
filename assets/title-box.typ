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
    [
      Week number: #monday.display("[week_number]")
    ] 
  )
)

#weeklendar(
  time-number: 2,
  height: 8cm,
  title-fct: title,
)
