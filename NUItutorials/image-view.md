# Image View Tutorial

The tutorial describes the NUI _ImageView_ control in detail.

## Overview

The ImageView is a control which displays an image.  

### Basic creation and usage

An instance of an ImageView is created with a file path: 

~~~{.cs}
imageView = new ImageView("./images/gallery-3.jpg");
~~~

or by the _Url_ property:

~~~{.cs}
imageView = new ImageView();
imageView.ResourceUrl = "./images/gallery-3.jpg";
~~~

To subsequently change an image use the _SetImage_ method:

~~~{.cs}
imageView.SetImage("./images/gallery-4.jpg");
~~~

This figure is displayed via an ImageView:

![ ](./Images/ImageView.png) 

### Image View Properties

ImageView has the following properties:

| Property  | Type | Description |
| ------------ | ------------ | ------------ |
| ResourceUrl | string  | path to image file. |
| ImageMap | Map | map of properties associated with a given image. |
| PreMultipliedAlpha | bool | opacity adjusted image. |
| PixelArea | Vector4 | sub area of image. |
| Border | Rectangle | The border of the image in the order:left, right, bottom, top. For N-Patch images only. |
| BorderOnly | bool | Gets/sets whether to draws the borders only(If true). For N-Patch images only. |
| SynchronosLoading | bool | Gets/Sets wheher the image is synchronos. For N-Patch images only. |

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

