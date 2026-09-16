#import "../lib.typ": *

#let events = (
  (
    start: "2026-09-21T08:15", end: "2026-09-21T10",
    summary: "Analysis I", description: "Lecture",
    fill: olive,
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-21T10:15", end: "2026-09-21T12",
    summary: "Analysis I", description: "Exercise session",
    fill: olive.lighten(50%),
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-22T13:15", end: "2026-09-22T15",
    summary: "Probability", description: "Lecture",
    fill: blue.lighten(30%),
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-22T15:15", end: "2026-09-22T17",
    summary: "Probability", description: "Exercise session",
    fill: blue.lighten(70%),
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-23T08:15", end: "2026-09-23T10",
    summary: "Linear algebra", description: "Lecture",
    fill: teal,
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-23T10:15", end: "2026-09-23T12",
    summary: "Linear algebra", description: "Exercise session",
    fill: teal.lighten(50%),
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-24T08:15", end: "2026-09-24T10",
    summary: "Programmation", description: "Lecture",
    fill: purple.lighten(20%),
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-21T13:15", end: "2026-09-21T15",
    summary: "Programmation", description: "Project",
    fill: purple.lighten(60%),
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-25T13:15", end: "2026-09-25T15",
    summary: "Physics", description: "Lecture",
    fill: maroon.lighten(30%),
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-25T15:15", end: "2026-09-25T17",
    summary: "Physics", description: "Exercise session",
    fill: maroon.lighten(70%),
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-23T13:15", end: "2026-09-23T15",
    summary: "Analysis I", description: "Lecture",
    fill: green,
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-23T15:15", end: "2026-09-23T17",
    summary: "Analysis I", description: "Exercise session",
    fill: green.lighten(50%),
    repeat-until: "2026-10-11", repeat-frequency: duration(days: 7),
  ),
  (
    start: "2026-09-21T16:30", end: "2026-09-21T17:15",
    summary: "Dentist",
    fill: red.lighten(30%),
  ),
  (
    start: "2026-10-04T12", end: "2026-10-04T22",
    summary: "Mom's birthday", description: "Bring a cake !",
    fill: orange.lighten(50%),
  ),
  (
    start: "2026-10-10T08", end: "2026-10-11T16",
    summary: "Mountain trip", description: "Buy train ticket's",
    fill: yellow.darken(10%),
  ),
)

#weeklendar(
  starting-date: "2026-09-21",
  ending-date: "2026-10-11",
  time-number: 10,
  ..events
)
