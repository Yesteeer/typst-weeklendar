#import "@preview/tidy:0.4.3"
#import "../core.typ"


#set document(title: "Weeklendar")

#v(5em)
#align(center)[
  #title() A weekly displayed calendar. #v(70%)

  Version 0.1.0 #v(0em)
  #datetime.today().display() #v(0em)
  #link("https://github.com/Yesteeer/typst-weeklendar")
]

#pagebreak()

#show heading.where(level: 2): set text(1.3em)
#show heading.where(level: 3): it => {
  set text(1.4em)
  set align(center)
  set block(below: 1.2em)
  it
}

#let core-functions = tidy.parse-module(
  read("../core.typ"),
  name: "Weeklendar", 
  //scope: (core: core),
  preamble: "#import core: *\n",
)

#tidy.show-module(
  core-functions, 
  style: tidy.styles.default, 
  //sort-functions: false, 
)
