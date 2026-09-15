#import "../lib.typ": *

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
    fill: red.lighten(80%),   
  ),
  (
    start: "2026-09-19T07:30", 
    end: "2026-09-19T09:30",     
    summary: "Morning walk",
  )
)

#weeklendar(starting-date: "2026-09-14", ending-date: "2026-09-20", ..events) 
