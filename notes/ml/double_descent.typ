#import "@local/note_template:0.1.0": *
#show: note_template

#title("Double Descent")

A relatively new phenomenon discovered is called #strong[double descent] and it
occurs when the model is #strong[overparametrized];, in other words when the
model has more weights/units than the number of training examples.

This phenomenon seems to go in contrast with what the basics of ML teaches:
usually a very complex and flexible model (w.r.t to the task) is bound to
overfitting.

#figure(
  image("images/double_descent.png", width: 70%),
  caption: [ Double Descent ],
)

As is possible to see in the plot, until the model doesn’t reach the
#strong[interpolation threshold];, everything is as expected: training error
keeps decreasing while test error decreases until it reaches a minimum and then
starts growing again.

The test error grows until the interpolation threshold that, more precisely, is
the point where the model is complex enough to perfectly fit the training data.
For example a polynomial regressor trained with 3 points can for sure fit
perfectly those points with a 2-degree polynomial (3 free parameters).

#figure(
  image("images/regression_example_deg2.png", width: 50%),
  caption: [ Degree 2 ],
)

#figure(
  image("images/regression_example_deg7.png", width: 50%),
  caption: [ Degree 7 ],
)

If the number of free parameters increases, the model maintains the perfect
interpolation of the training set, but now the solution given by gradient
descent seems to be #emph["regularized"] in some sense.

#figure(
  image("images/regression_example_deg16.png", width: 50%),
  caption: [ Degree 16 ],
)

In other words the model continues to fit training data but with an higher
degree polynomial with smaller weights.

= References <references>

- Deep Learning
- Bias Variance
- #link(
    "https://www.youtube.com/watch?v=z64a7USuGX0&t=1808s",
  )[WelchLabs YouTube video]
