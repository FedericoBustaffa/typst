= Map-Reduce
<map-reduce>
A very common case is to merge the #emph[map] and the #emph[reduce]
pattern. This can be done putting a map and a reduce in pipeline, trying
also to exploit some overlap between the two if possible.

Logically, if there are no dependecies and a stream of collections, we
can build a 2-stage pipeline where the first is the map and the second
stage is the reduce.

However a typical implementation combine the two phases in order to
avoid communication overhead. Once a worker finished the map phase, it
applies the reduce operator on its local partition and then share data
with other workers.

== References
<references>
- \[\[map\]\]
- \[\[reduce\]\]
