---
layout: default
title: What is a Visual
---
[ Home Page ]({{site.baseurl}}/index) <br>

# Visuals

Visuals are the main building block for controls.

They are used to display (renderer) content, images, meshes and text.

Controls that have something to display would be built with one or more Visual.

A Control like a button could use an image visual for the background in pressed state and another in the un-pressed state.<br>
It could also use a text visual to diplay what the button is for. e.g "Play".

Visuals have common properties and specific ones. This enables the visual to be configured for the usecase.

Currently the Visual avaiable are:

| Visual | Example | Visual | Example
| --- | --- |
| Border | ![]({{site.baseurl}}/assets/images/visuals/border-visual.png) | Color | ![ ]({{site.baseurl}}/assets/images/visuals/color-visual.png)
| Gradient | ![ ]({{site.baseurl}}/assets/images/visuals/linear-gradient-visual.png) | Image |  ![ ]({{site.baseurl}}/assets/images/visuals//house.png)
| SVG | <img src="{{site.baseurl}}/assets/images/visuals/svg-visual.svg" width="200" height="300"> | NPatch | ![ ]({{site.baseurl}}/assets/images/visuals/n-patch-visual.png)
| Animated Image | ![ ]({{site.baseurl}}/assets/images/visuals/animated-image-visual.gif) | Mesh | ![]({{site.baseurl}}/assets/images/visuals/mesh-visual.png)
| Primitive | ![ ]({{site.baseurl}}/assets/images/visuals/cube.png) | Text | ![ ]({{site.baseurl}}/assets/images/visuals/HelloWorld.png)

WireFrame Visual - The wireframe visual is mainly used for debugging, replacing all other visuals
when 'Visual Debug Rendering' is turned on.
