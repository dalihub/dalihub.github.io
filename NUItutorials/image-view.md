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
imageView.Url = "./images/gallery-3.jpg";
~~~

To subsequently change an image use the _SetImage_ method:

~~~{.cs}
imageView.SetImage("./images/gallery-4.jpg");
~~~
 
### Image View Properties

ImageView has the following properties:

| Property  | Type | Description 
| ------------ | ------------ | ------------ |
| Url | string  | path to image file.
| ImageMap | Map | map of properties associated with a given image
| PreMultipliedAlpha | bool | opacity adjusted image
| PixelArea | Vector4 | sub area of image.

Note:

+ PreMultipliedAlpha - If true, the RGB components represent the color of the object or pixel adjusted for its opacity
                       by multiplication. If false, the opacity is disregarded.

+ PixelArea          - PixelArea is a relative value, with the whole image area as [0.0, 0.0, 1.0, 1.0], Vector4 area
                       values are (x, y, width, height).

                       Ex) on a 200 x 200 pixel image [0.25, 0.5, 0.5, 0.5] would represent a sub area
                       of the image with the following co-ords. 50,100 150,100 50,200 150,200

