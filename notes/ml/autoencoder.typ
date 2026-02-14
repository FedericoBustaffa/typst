= Autoencoder <autoencoder>

An #strong[autoencoder] is a network that tries to reproduce its input. That’s
way is called #emph[semi-supervised] (or #emph[self-supervised];) learning;
there is still an #emph[error] function to optimize but there is no real target.

#figure(image("/files/autoencoder.png"), caption: [
  Autoencoder|500
])

Compressing the input and then decompressing it has the effect of catch
underlying structure in it (#strong[undercomplete] autoencoder). It’s also
possible to have an autoencoder that maps the input in a higher dimensional
space (#strong[overcomplete] autoencoder); this can be useful for example in
classification to make the problem linearly sperable in that new space.

== References <references>
