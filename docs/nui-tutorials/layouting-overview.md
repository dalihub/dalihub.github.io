---
layout: default
title: Layouting
---
[ Home Page ]({{site.baseurl}}/index) <br>

<a name="top"></a>
# Layouting Tutorial

This tutorial describes the NUI Layouting framework, covering the following subjects:

[Overview](#overview)<br>
[Setting Layouts](#settingLayouts)<br>
[Sizing](#sizingLayouts)<br>
[Padding/Margins](#paddingAndMargins)<br>
[Minimum/Maximum sizes](#minimumAndMaximum)<br>
[Linear Layout](#linearLayout)<br>
[Grid Layout](#gridlayout)<br>
[Flex Layout](#flexlayout)<br>
[Creating custom Layouts](#customLayouts)<br>


<a name="overview"></a>
## Layouting Overview

The Layouting framework enables **Views** to be automatically positioned within a parent View that has been assigned a Layout.

The framework offers a common method to layout Views with just minimal setup in the application.

Default layouts e.g `Linear` and `Grid` can be assigned to a View, children added to this View will then be positioned
and sized according to that layout in conjunction with specification and properties set on the layout and Views.

New layouts can be implemented by deriving from the Layouting base class and positioning the children in any way required, see [Creating custom Layouts](#customLayouts) for instructions.

The layouting framework allows nested layouting; View with a layout can be added to another View with a layout.

Layouts are instances of specific Layouts e.g. LinearLayout, GridLayout etc.  A View can be assigned any Layout and re-assigned to a different Layout but a Layout can only be used with one View at a time.

<img src="{{site.baseurl}}/assets/images/diagrams/NUI_Class_Hierarchy.png">

[Back to top](#top)

<a name="settingLayouts"></a>
### Setting a layout to a View

For a View to perform the desired layouting for its children it needs to have a layout created and set to it.  Layouts may need extra settings to be provided, for example a Grid layout can have the number of columns set on it.

Below code snippet creates a View, creates a LinearLayout and then sets the layout on the View.

~~~{.cs}
View parentView = new View();
parentView.Name = "LinearExample";

var layout = new LinearLayout();
layout.LinearOrientation = LinearLayout.Orientation.Horizontal;

parentView.Layout = layout;
~~~

In the case about the linear layout has the Horizontal orientation set on it as Linear Layout can be vertical or horizontal.

A View can be assigned a new layout, this will cause it's children to be repositioned as described by the new layout.
A Layout can only be assigned to a single View at a time, trying to assign the same layout to multiple Views will result in only the last assigned View to have that layout.  A default Layout will be assigned if a layout is moved from one View to another.

~~~{.cs}
View parentView = new View();
parentView.Name = "LinearExample";

var layoutLinear = new LinearLayout();
layout.LinearOrientation = LinearLayout.Orientation.Horizontal;

parentView.Layout = layoutLinear;

...
someAction.Event += (sender, e) =>
{
  parentView.Layout = new GridLayout();;
}
~~~

Code above changes the layout from Linear to Grid on a event occurance.

[Back to top](#top)

<a name="sizingLayouts"></a>
### Sizing and Specifications

There are 3 size specifications available for Views, size specifications are ways to specify the preferred size of Views within the layouting framework.  Height and Width are individual so each can be set with a different specification.

1) An explicit value can be provided, either using the existing Size2D, Size API or setting a pixel value to the specification.

~~~{.cs}
View childView = new View();
childView.SetSize2D(90,90);
~~~

or

~~~{.cs}
View childView = new View();
childView.WidthSpecification = 90;
childView.HeightSpecification = 90;
~~~

<img src="{{site.baseurl}}/assets/images/diagrams/NUI_Class_Hierarchy.png">

2) The LayoutParamPolicies.WrapContent,  setting the View's height or width specification to WrapContent will cause the View  to grow or shrink to wrap around the size of it's children.

~~~{.cs}
View childView = new View();
childView.WidthSpecification = LayoutParamPolicies.WrapContent;
childView.HeightSpecification = LayoutParamPolicies.WrapContent;
~~~

<img src="{{site.baseurl}}/assets/images/diagrams/NUI_Class_Hierarchy.png">

3) The LayoutParamPolicies.MatchParent, setting the View's height or width specification to MatchParent will cause the View to fill the size of it's parent.

~~~{.cs}
View childView = new View();
childView.WidthSpecification = LayoutParamPolicies.MatchParent;
childView.HeightSpecification = LayoutParamPolicies.MatchParent;
~~~

<img src="{{site.baseurl}}/assets/images/diagrams/NUI_Class_Hierarchy.png">

[Back to top](#top)

<a name="paddingAndMargins"></a>
### Padding and Margin

Padding and Margins provide additional control within a layout to achieve a desired look.

Both padding and margin are 4 values represented by the Extents class; start, top, end, bottom.

Padding is the internal space between the boundary of the View and it's content, a View with a layout will have child Views as content whilst a leaf View (ImageView for example) would have an ImageVisual as it's content.

Padding can be provided to a Layout View to give an offset to it's children.

~~~{.cs}
View layoutView = new View();
var layout = new LinearLayout();
layoutView.Layout = layout;

layoutView.Padding = new Extents(10,0,10,0);

View childView = new View();
childView.WidthSpecification = LayoutParamPolicies.MatchParent;
childView.HeightSpecification = LayoutParamPolicies.MatchParent;

layoutView.Add(childView);
~~~

<img src="{{site.baseurl}}/assets/images/diagrams/NUI_Class_Hierarchy.png">

Margin is the external space around a View. Providing a child View with a margin will offset the positioning of just that child. Whilst setting the padding on the parent View will offset all the children.

~~~{.cs}
View layoutView = new View();
var layout = new LinearLayout();
layoutView.Layout = layout;

View childView = new View();
childView.WidthSpecification = LayoutParamPolicies.MatchParent;
childView.HeightSpecification = LayoutParamPolicies.MatchParent;
childView.Margin = new Extents(10,0,10,0);

layoutView.Add(childView);
~~~

<img src="{{site.baseurl}}/assets/images/diagrams/NUI_Class_Hierarchy.png">

[Back to top](#top)

<a name="minimumAndMaximum"></a>
### Minimum and Maximum Sizes

The layouting framework has control over the size of the Views it lays out.  The size of a child view may need to be smaller or larger than it's natural size or specified size.

To guide the framework a preferred minimum and maximum size can be provided if a preference exists.  The layouting system will then try to keep the size of the View within the given values.

Minimum or maximum sizes could be used with the LayoutParamPolicies MatchParent or WrapContent.

If specifying an explicit size and setting the minimum or maximum, ensure the explicit size is within the minimum and maximum boundary.

~~~{.cs}
View childView = new View();
childView.WidthSpecification = LayoutParamPolicies.WrapContent;
childView.HeightSpecification = LayoutParamPolicies.WrapContent;
childView.MinimumSize = new Size2D(200,200);
childView.MaximumSize = new Size2D(400,400);
~~~

[Back to top](#top)

## Available Layouts

Below are the available Layouts that have been implemented and ready to be assigned to Views.

Tables dscribe properties unique to each Layout.

<a name="linearLayout"></a>
### Linear Layout

Positions children in a linear form, one after the other, `CellPadding` can be provided to insert a space between each child.  Unlike generic padding this will not result in a space at the start,end or top, bottom of the layout.

The children can be laid out vertically or horizontally by providing the LinearOrientation property a Vertical or Horizontal Orientation.

LinearAlignment defines where the children should start being positioned from, useful if the children do not use all the space of the parent.

| Property               | Type            | Description |
| -----------------------| --------------- | ------------ |
| LinearAlignment        | LinearLayout.Alignment  | Gets/Set the global child alignment to be used |
| LinearOrientation      | LinearLayout.Orientation   | Gets/Sets Orientation of the linear layout, vertical or horizontal |
| CellPadding            | Size2D      | Gets/Sets Spacing between the cells, horizontal space and vertical space |

[Back to top](#top)

<a name="gridLayout"></a>
### Grid Layout

Positions children in a grid form, the cells are of uniform size based on the first child added to the parent View.
The number of columns can be specified and the rows will automatically increased to hold the children. Once the available space is used up further rows will not be added.

| Property               | Type            | Description |
| -----------------------| --------------- | ------------ |
| Columns                | int             | Gets/Sets the number of columns in the Grid |

<a name="flexlayout"><br>
### Flex Layout

Layout under construction.
[Back to top](#top)

<a name="customLayouts"><br>
## Creating Custom Layouts

Custom layouts can be created for use in applications or to add to the current "Toolkit".

The custom layout must derive from LayoutGroup and override the 2 methods  OnMeasure and OnLayout described below.

The layouting framework does all the heavy work leaving just the Measuring and Layouting to the Custom Layout.

Layouting is a 2 phase process.  
First Measuring of the children hence determining the layouts own dimensions.
Second Layouting the children within itself using their measured sizes. (Positioning the children)

```protected override void OnMeasure( MeasureSpecification widthMeasureSpec, MeasureSpecification heightMeasureSpec )```

```protected override void OnLayout( bool changed, LayoutLength left, LayoutLength top, LayoutLength right, LayoutLength bottom )```


[Back to top](#top)
