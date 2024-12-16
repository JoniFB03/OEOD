#import "template.typ": *
#include "capa.typ"
#show: project
#counter(page).update(1)
#import "@preview/algo:0.3.3": algo, i, d, comment, code //https://github.com/platformer/typst-algorithms
#import "@preview/tablex:0.0.8": gridx, tablex, rowspanx, colspanx, vlinex, hlinex

#page(numbering:none)[
  #outline(indent: 2em)  
  // #outline(target: figure)
]
#pagebreak()
#counter(page).update(1)

= Introdução

No âmbito da unidade curricular de Otimização de Estratégias Orientada por Dados

Para este projeto será utilizada a metodologia CRISP-DM.
= Extração de dados





