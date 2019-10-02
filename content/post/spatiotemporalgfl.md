+++
title = "Spatiotemporal GFL images"
date = 2018-12-21T22:36:34-06:00
draft = false

# Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
authors = ['Mauricio Tec']

# Tags and categories
# For example, use `tags = []` for no tags, or the form `tags = ["A Tag", "Another Tag"]` for one or more tags.
tags = ['graph-fused lasso', 'spatiotemporal smoothing']
categories = []

# Featured image
# Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
# Use `caption` to display an image caption.
#   Markdown linking is allowed, e.g. `caption = "[Image credit](http://example.org)"`.
# Set `preview` to `false` to disable the thumbnail in listings.
[header]
image = ""
caption = ""
preview = true

+++

Below are some images, produced with `ggplot2`, for our work on spatiotemporal smoothing with the graph-fused lasso.

<diV>
<figure>
<img src="/img/spatiotemporalgfl/combined.gif" alt="smoothing" width=600>
<figcaption>

<center>
The figures on the **left (red)** show the productivity (dollars per hour) at the airport, and the figures at the right in **downtown (blue)**. The two **top** figures show the models **without postprocessing**, and the **bottom** two use **Bernstein polynomials smoothing** and 400 degrees of freedom.</center>

**To do**

- The image may improve using facet instead of four separate gifs
</figcaption>
</div>


<diV>
<figure>
<img src="/img/spatiotemporalgfl/map_median_enet_compressed.gif" alt="map" width=500>
<figcaption>

<center>
The map shows the median productivity of a driver depending on the current location of a driver. It is computed with the methodology described by the paper with Natalia. It is worth noticing that downtown is always better during morning, mainly on Sunday and Saturday. And the airport has the worst productivity, mostly on afternoons.
</center>

**To do**

- Should we smooth the transition? (interpolate frames)

</figcaption>
</div>

sdfds