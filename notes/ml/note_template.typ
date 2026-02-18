#let note_template(body) = {
  set page(paper: "a4")
  set text(font: "New Computer Modern", size: 12pt)
  set par(justify: true)

  body
}


#let note(title: "Note", body) = block(
  fill: rgb("#e6f2ff"),
  inset: 12pt,
  radius: 6pt,
  stroke: (left: 4pt + rgb("#3399ff")),
  width: 100%,
)[
  #strong[#title]
  #v(4pt)
  #body
]

#let important(title: "Important", body) = block(
  fill: rgb("#e9f7ef"),
  inset: 12pt,
  radius: 6pt,
  stroke: (left: 4pt + rgb("#28a745")),
  width: 100%,
)[
  #strong[#title]
  #v(4pt)
  #body
]

#let example(title: "Example", body) = block(
  fill: rgb("#f3e8ff"),
  inset: 12pt,
  radius: 6pt,
  stroke: (left: 4pt + rgb("#8b5cf6")),
  width: 100%,
)[
  #strong[#title]
  #v(4pt)
  #body
]
