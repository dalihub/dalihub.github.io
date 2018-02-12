---
layout: default
title: ImageView Tutorial
---
[ Home Page ]({{site.baseurl}}/index) <br>

# Image View Tutorial

The tutorial describes the NUI _ImageView_ control in detail.

## Overview

The ImageView control is used to display an image, or other types of visual content.
It provides the loading and decoding of image data, and properties to control the visual appearance of images.
It does not provide any user interaction.

This tutorial will focus on the common usage with ImageVisual, although ImageView can use any type of visual.

### Basic creation and usage

A basic instance of an ImageView is created with a file path:
If the filename is to a Nine Path, GIF, SVG or regular image then the respectivUtcDaliVisualActione
Visual will be created and used.

~~~{.cpp}
auto imageView = ImageView::New("./images/apple.svg");
~~~


### Creation and usage with Visuals

To have full control over the Visual and what ImageView displays a Visual Property::Map should be used.

Below example uses the gallery-3.jpg for the ImageView and forces ATLASING off.
Each Visual has it's own Properties which can be set.

~~~{.cpp}
auto imageView = ImageView:New();

imageView.SetProperty( ImageView::Property::IMAGE,
                       Property::Map().Add( ImageVisual::Property::URL, "./images/apple.svg" )
                                      .Add( ImageVisual::Property::ATLASING, false  ) );

~~~

To subsequently change a visual then set the IMAGE property a new visual property map.

~~~{.cpp}UtcDaliControlActionOnVisual
imageView.SetProperty( ImageView::Property::IMAGE,
                       Property::Map().Add( ImageVisual::Property::URL, "./images/house.png" )
                                      .Add( ImageVisual::Property::ATLASING, false  ) );

imageView.SetParentOrigin( ParentOrigin::CENTER );
imageView.SetResizePolicy( ResizePolicy::USE_NATURAL_SIZE, Dimension::ALL_DIMENSIONS );
~~~

This image is displayed via an ImageView:

<img src="{{site.baseurl}}/assets/images/controls/image-view.png" width="400" height="600">
### Image View Properties

ImageView has the following properties:

| Property  | Type | Description |
| ------------ | ------------ | ------------ |
| IMAGE  | Map | map of properties associated with a given image. |
| PRE_MULTIPLIED_ALPHA | bool | opacity adjusted image. |
| PIXEL_AREA | Vector4 | sub area of image (Animatable). |

Note:

+ PreMultipliedAlpha
If PreMultipliedAlpha is true, the RGB components represent the color of the object or pixel adjusted for its opacity
by multiplication. If false, the opacity is disregarded.

+ PixelArea
PixelArea is a relative value, with the whole image area as [0.0, 0.0, 1.0, 1.0].
Vector4 area values are (x, y, width, height).

e.g on a 200 x 200 pixel image [0.25, 0.5, 0.5, 0.5] would represent a sub area
of that image with the following co-ordinates:
Top left     : 50,100
Top right    : 150,100
Bottom left  : 50,200
Bottom right : 150,200

## Usage with Texture APIs

ImageView can also be used display Dali::Texture. For more details see [ this section ]({{site.baseurl}}/concepts/rendering/using-textures-with-imageview) of DALi Rendering API documentation.
