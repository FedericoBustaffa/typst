#import "@preview/cetz:0.4.2"
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes
#import "@preview/physica:0.9.8": *
#import "@preview/numty:0.1.0" as nt


#let note_template(doc_title, body) = {
  set text(font: "New Computer Modern", size: 12pt)
  set page(paper: "a4", numbering: "1")
  set par(justify: true)
  set document(title: doc_title, author: "Federico Bustaffa")

  set math.vec(delim: "[")
  set math.mat(delim: "[")

  show heading: it => block(below: 0.8em, it)

  show raw.where(block: true): block.with(
    fill: luma(240),
    inset: 10pt,
    width: 100%,
  )

  // show: super-T-as-transpose

  body
}

#let note(title: "Note", body) = block(
  fill: rgb("#e6f2ff"),
  inset: 12pt,
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
  stroke: (left: 4pt + rgb("#8b5cf6")),
  width: 100%,
)[
  #strong[#title]
  #v(4pt)
  #body
]

