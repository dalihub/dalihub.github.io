---
layout: default
title: Nui Tutorial
---
[ Home Page ]({{site.baseurl}}/index) <br>

## Layouting  ( in developement so subject to change )

### Using provided Layouts

Some commonly used Layouts are (or will be) be provided.

The developers would choose one of these Layouts and add it to their view using
 the *View::SetLayout* API with the layout as a parameter.

Choosing a Layout is simlply creating a new instance of the class.

Adding children to a View which has a layout set causes the Layout system
 to automatically position and size the children within it depending on the layout.

Adding children is still done with the *View::Add* API. No extra steps needed.

### Creating custom Layouts

If the provided Layouts are not sufficient or need adapting then the developers
can create their own layout and then call *View::SetLayout* with the custom layout
as a parameter.

To create a new layout the developer must inherrit from *LayoutGroup*, *LayoutGroup*
inherrits from LayoutItem and between them are a few virtual functions the developers must implement.

The non-optional ones being

*OnMeasure*<br>
*OnLayout*

#### LayoutItem and LayoutGroup

Any item/view/container that is laid out using the layout system must be an *LayoutItem*,
internally it's how measurements are stored to them.  
Adding a child to a Layout
container will automatically wrap it in a *LayoutItem* and not something the developer
should be concerned about.

A *LayoutGroup* contains one or more LayoutItems, a Layoutgroup can be added to another LayoutGroup
hence is also a LayoutItem.

*LayoutItem* is the base class of *LayoutGroup* so used in the API.

< a further guide will be provided explaining the OnMeasure and OnLayout classes which will position and size the items and also including child properties like padding>
