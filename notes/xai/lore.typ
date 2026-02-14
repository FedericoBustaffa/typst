= Lore <lore>

Tra le tecniche di Explainable Al locali è presente #strong[#emph[LORE];];, che
si propone di fornire spiegazioni #emph[locali] alle decisioni prese dal
modello. #emph[LORE] è stato sviluppato sotto varie assunzioni tra cui:

- La spiegazione di una specifica decisione è significativa.
- Il classificatore e la sua logica sono #emph[oscuri] poiché
  - Basati su Deep Learning.
  - Implementazione non open source.
  - Altre ragioni.
- Il modo in cui vengono fornite le spiegazioni dovrebbe essere il più
  simile possibile al linguaggio logico di ragionamento.
- L’utente dovrebbe essere in grado di capire elementari regole logiche.
- Il sistema decisionale può essere interrogato quante volte si vuole.
  D’altro canto non si fa alcuna assunzione sulla tipologia del modello
  decisionale, poiché si vuole un metodo agnostico per la generazione
  delle spiegazioni.

== Funzionamento <funzionamento>

Dopo aver scelto un’istanza per la quale generare le spiegazioni, viene eseguito
un algoritmo genetico per generare due vicinati sintetici, $Z_(=)$ e $Z_eq.not$,
classificati rispettivamente allo stesso modo dell’istanza e diversamente
dall’istanza.

Una volta generati, i due vicinati vengono usati come training set per un albero
di decisione. In seguito vengono confrontate le predizioni effettuate dal
modello black box e dall’albero di decisione. Se coincidono nella maggior parte
dei casi, allora il metodo riesce a spiegare bene le predizioni effettuate dalla
black box.

Un albero decisionale infatti fornisce una rappresentazione del modo in cui
effettua le scelte in modo abbastanza naturale e decisamente comprensibile per
un essere umano.

= References <references>

#link("https://arxiv.org/pdf/1805.10820")[LORE]

