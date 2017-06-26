<a name="top"></a>
# Creating Custom View Controls 

In this tutorial:

[Overview](#overview)<br>
[Guidelines for custom view creation](#guidelines)<br>
[The existing CustomView class](#existingcustomview)<br>
[Creation of a custom view](#creation)<br>
[Rendering](#rendering)<br>
[Styling](#stylable)<br>
[Type and property registration](#typeregistration)<br>
[Enabling properties for JSON access](#enableproperties)<br>
[Setting control behaviour](#controlbehaviour)<br>
[Events](#events)<br>
[Gestures](#gestures)<br>
[Accessibility](#accessibility)<br>
[Window connection](#defaultwindowconnection)<br>
[Size Negotiation](#sizenegotiation)<br>

<a name="overview"></a>
### Overview
NUI provides the ability to create custom view controls.

<a name="guidelines"></a>
### General guidelines for creating a custom control
+ Derive your control from the `CustomView` class.
+ Use **properties** as much as possible, as controls should be data driven.
  + These controls will be used through JavaScript and JSON files so need to be compatible.
+ The control can be updated when the properties change (e.g. style change)
  + Ensure control deals with these property changes gracefully, on both first and subsequent times they are set
+ Use visuals rather than creating several child views.
  + DALi rendering pipeline more efficient
+ Accessibility actions should be considered when designing the control.
+ Use `Events` if the application needs to be react to changes in the control state.
+ Use of `Gestures` should be preferred over analysing raw touch events.

[Back to top](#top)

<a name="exisingcustomview"></a>
### The existing CustomView class
The NUI `CustomView` class provides common functionality required by all views. The `CustomView` class is derived 
from the `View` class.

~~~{.cs}
    public class CustomView : ViewWrapper
~~~

where:

~~~{.cs}
    public class ViewWrapper : View
~~~

There are several controls derived from `CustomView` objects already existing in NUI, including:

* **Spin** control, which is used for continuously changing values when users can easily predict a set of values.

* **ContactView** which consists of four visuals (Image, Primitive, Text and Color).
  All of these visuals can be configured via properties - ImageURL (Image), Shape (Primitive), Name (Text) and Color.
  Tap gesture is also enabled on the `ContactView` which changes the color visual to some random color when the
  ContactView is tapped.

* A **VisualView** control enabling the addition of any visual. See [Visual View class](visuals.md#visualview)

* A **StarRating** custom control, for 'star' rating of images (draggable to change the rating).

#### CustomView methods
 
Key `CustomView` methods include:

| Name                   | Description                                                                                          |
|------------------------------------------------------|---------|----------------------------------------------------------------------|
| OnInitialize           | called after the Control has been initialized.               |
| SetBackground          | Set the background with a property map.         |
| EnableGestureDetection | Allows deriving classes to enable any of the gesture detectors that are available              |           |
| RegisterVisual         | Register a visual by Property Index, linking an View to visual when required. |
| CreateTransition       | Create a transition effect on the control - for animations. |
| RelayoutRequest        | Request a relayout, which means performing a size negotiation on this view, its parent and children (and potentially whole scene) |
| OnStageConnection      | Called after the view has been connected to the stage 'default window' |

[Back to top](#top)
 
<a name="creation"></a>
### Custom View Creation

A control is created with the `new` operator:

~~~{.cs}
contactView = new ContactView()
~~~

Each custom C# view should have it's static constructor called before any JSON file is loaded.
Static constructors for a class will only run once ( they are run per control type, not per instance).
Inside the static constructor the control should register it's type. e.g.

~~~{.cs}
static ContactView()
{
    ViewRegistry.Instance.Register(CreateInstance, typeof(ContactView));
}
~~~

The `ViewRegistry` method registers the controls and any scriptable properties they have with the `Type Registery'.

The control should also provide a `CreateInstance` function, which gets passed to the `ViewRegistry` method.
`CreateInstance` will be called if the control is in a JSON file:

~~~{.cs}
static CustomView CreateInstance()
{
    return new ContactView();
}
~~~

Override the`OnInitialize` method if necessary, as in this example:

~~~{.cs}
public override void OnInitialize()
{
    // Create a container for the star images
    _container = new FlexContainer();

    _container.FlexDirection = FlexContainer.FlexDirectionType.Row;
    _container.WidthResizePolicy = ResizePolicyType.FillToParent;
    _container.HeightResizePolicy = ResizePolicyType.FillToParent;

    this.Add(_container);
~~~

[Back to top](#top)

<a name="rendering"></a>
### Rendering Content

![ ](creating-custom-controls/rendering.png)

To render content, the required views can be created and added to the control itself as its children.
However, this solution is not fully optimised and means extra views will be added, which is extra processing.
 
It is recommended to use/reuse visuals to create the required content. See [Visuals tutorial](visuals.md).

Visuals are usually defined in a stylesheet.
 
The following code snippet shows the creation and registration of an image visual in `ContactView.cs`.

~~~{.cs}

[ScriptableProperty()]
public string ImageURL
{
    get
        {
            return _imageURL;
        }
        set
        {
            _imageURL = value;

            // Create and Register Image Visual
            PropertyMap imageVisual = new PropertyMap();
            imageVisual.Add( Visual.Property.Type, new PropertyValue( (int)Visual.Type.Image ))
                       .Add( ImageVisualProperty.URL, new PropertyValue( _imageURL ) )
                       .Add( ImageVisualProperty.AlphaMaskURL, new PropertyValue( _maskURL ));
           _imageVisual =  VisualFactory.Get().CreateVisual( imageVisual );

            RegisterVisual( GetPropertyIndex("ImageURL"), _imageVisual );

            // Set the depth index for Image visual
           _imageVisual.DepthIndex = ImageVisualPropertyIndex;
        }
    }
~~~

Note: this property is a [ScriptableProperty](#enableproperties)

`RegisterVisual` registers a visual by a 'property index', linking a view to a visual when required.

The [Visuals tutorial](visuals.md) describes the property maps that can be used for each visual type.

[Back to top](#top)
 
<a name="stylable"></a>
### Ensuring Control is Stylable

The NUI property system allows custom controls to be easily styled. The JSON Syntax is used in the stylesheets:
 
**JSON Styling Syntax Example:**
~~~
{
  "styles":
  {
    "textfield":
    {
      "pointSize":18,
      "primaryCursorColor":[0.0,0.72,0.9,1.0],
      "secondaryCursorColor":[0.0,0.72,0.9,1.0],
      "cursorWidth":1,
      "selectionHighlightColor":[0.75,0.96,1.0,1.0],
      "grabHandleImage" : "{DALI_STYLE_IMAGE_DIR}cursor_handler_drop_center.png",
      "selectionHandleImageLeft" : {"filename":"{DALI_STYLE_IMAGE_DIR}selection_handle_drop_left.png" },
      "selectionHandleImageRight": {"filename":"{DALI_STYLE_IMAGE_DIR}selection_handle_drop_right.png" }
    }
  }
}
~~~
 
Styling gives the UI designer the ability to change the look and feel of the control without any code changes.
 
| Normal Style | Customized Style |
|:------------:|:----------------:|
|![ ](./Images/creating-custom-controls/popup-normal.png) | ![ ](./Images/creating-custom-controls/popup-styled.png)|
 
The [styling tutorial](styling.md) explains how to build up visuals for the button states using JSON stylesheets,
and transitioning between the various button states.

[Back to top](#top)
 
<a name="typeregistration"></a>
### Type Registration 

The 'Type Registry' is used to register your custom control.

Type registration allows the creation of the control via a JSON file, as well as registering properties, signals, actions,
transitions and animation effects.
 
Type Registration is via the `ViewRegistry` method, see [Custom View creation](#creation)

#### Properties
 
Control properties can be one of three types:
 + **Event-side only:** A function is called to set or retrieve THE value of this property.
 + **Animatable Properties:** These are double-buffered properties that can be animated.
 + **Custom Properties:** These are dynamic properties that are created for every single instance of the control.
                          Custom properties tend to take a lot of memory, and are usually used by applications or
                          other controls to dynamically set certain attributes on their children.
                          The index for these properties can also be different for every instance.
 
Careful consideration must be taken when choosing which property type to use for the properties of the custom control.
For example, an Animatable property type can be animated, but requires a lot more resources (both in its execution and memory footprint)
compared to an event-side only property.

Property registration for transistions and animations is via `GetPropertyIndex`, an example is shown in [rendering](#rendering).

[Back to top](#top)
 
<a name="enableproperties"></a>
### Enabling properties for JSON access

The `ScriptableProperty` class enables a property to be registered with the `type registry'.

~~~{.cs}
    internal class ScriptableProperty : System.Attribute
~~~

Add `ScriptableProperty`to any property belonging to a View (control) you want to be scriptable from JSON.
The following code snippet is taken from the `ContactView` class:

~~~{.cs}
[ScriptableProperty()]
public int Shape
{
    get
    {
        return _shape;
    }
    set
    {
        _shape = value;

        ...
        ...
    }

~~~

[Back to top](#top)
 
<a name="controlbehaviour"></a>
### Setting Control Behaviour

The `CustomViewBehaviour` enum specifies the following behaviour:-
 
| Behaviour                            | Description                                                                                                    |
|--------------------------------------|----------------------------------------------------------------------------------------------------------------|
| ViewBehaviourDefault                 | Default behavior (size negotiation is on, style change is monitored, event callbacks are not called.)           |
| DisableSizeNegotiation               | If our control does not need size negotiation, i.e. control will be skipped by the size negotiation algorithm. |
| DisableStyleChangeSignals            | True if control should not monitor style change signals such as Theme/Font change.                             |
| RequiresKeyboardNavigationSupport    | True if need to support keyboard navigation.    
| LastViewBehaviour                    |                                                               |

`CustomViewBehaviour` is used during object construction. Two examples follow:

~~~{.cs}
public VisualView() : base(typeof(VisualView).Name, CustomViewBehaviour.ViewBehaviourDefault)
{
}
~~~

~~~{.cs}
public ContactView() : base(typeof(ContactView).Name, CustomViewBehaviour.RequiresKeyboardNavigationSupport)
{
}

~~~

[Back to top](#top)

<a name="events"></a>
### Touch, Hover & Wheel Events

+ A **touch** is when any touch occurs within the bounds of the custom view. Connect to the View class `TouchSignal` method.
+ A **hover event** is when a pointer moves within the bounds of a custom view (e.g. mouse pointer or hover pointer).
+ A **wheel event** is when the mouse wheel (or similar) is moved while hovering over a view (via a mouse pointer or hover pointer).
 
If the control needs to utilize hover and wheel events, then the correct [behaviour flag](#controlbehaviour) should be used when
constructing the control, and the appropriate method should be overridden.

[Back to top](#top)

<a name="gestures"></a>
### Gestures

DALi has a gesture system which analyses a stream of touch events and attempts to determine the intention of the user.
The following gesture detectors are provided:
 
 + **Pan:** When the user starts panning (or dragging) one or more fingers.
            The panning should start from within the bounds of the control.
 + **Pinch:** Detects when two touch points move towards or away from each other.
              The center point of the pinch should be within the bounds of the control.
 + **Tap:** When the user taps within the bounds of the control.
 + **LongPress:** When the user presses and holds on a certain point within the bounds of a control.
 
The control base class provides basic set up to detect these gestures. If any of these detectors are required then
this can be specified in the `OnInitialize` method.
 
This code snippet is taken from the `ContactView` custom view control:

~~~{.cs}
public override void OnInitialize()
{
   // Enable Tap gesture on ContactView
   EnableGestureDetection(Gesture.GestureType.Tap);
}
~~~

The `EnableGestureDetection` method allows deriving classes to enable any of the gesture detectors that are available.
The above snippet of code will only enable the default gesture detection for each type. If customization of the gesture detection
is required, then the gesture-detector can be retrieved and set up accordingly in the same method, as shown here:
 
~~~{.cs}
PanGestureDetector panGestureDetector = GetPanGestureDetector();
panGestureDetector.AddDirection( PanGestureDetector.DIRECTION_VERTICAL );
~~~

Finally, the appropriate method should be overridden:

~~~{.cs}
OnPan( PanGesture& pan ) // Handle pan-gesture
~~~

~~~{.cs}
OnPinch( PinchGesture& pinch ) // Handle pinch-event
~~~

~~~{.cs}
OnTap( TapGesture& tap ) // Handle tap-gesture
~~~

~~~{.cs}
OnLongPress( LongPressGesture& longPress ) // Handle long-press-gesture
~~~

As an example here is the `OnTap` method from the `ContactView` class:

~~~{.cs}
public override void OnTap(TapGesture tap)
{
    // Change the Color visual of ContactView with some random color
    Random random = new Random();
    float nextRed   = (random.Next(0, 256) / 255.0f);
    float nextGreen = (random.Next(0, 256) / 255.0f);
    float nextBlue  = (random.Next(0, 256) / 255.0f);
    Animation anim = AnimateBackgroundColor( new Color( nextRed, nextGreen, nextBlue, 1.0f), 0, 2000 );
    anim.Play();
}
~~~

[Back to top](#top)

<a name="accessibility"></a>
### Accessibility

Accessibility is functionality that has been designed to aid usage by the visually impaired.
 
Accessibility behaviour can be customized in the control by overriding certain virtual methods.
An example is `OnAccessibilityTouch`. Touch events are delivered differently in 'Accessibility' mode.
`OnAccessibilityTouch` should be overridden if some special behaviour is required when these touch events
are received. 

[Back to top](#top)

<a name="defaultwindowconnection"></a>
### Stage Connection

Methods are provided in the `CustomView' class that can be overridden if notification is required when our control
is connected to, or disconnected from the stage (default window).

~~~{.cs}
OnStageConnection( int depth )
~~~

and 

~~~{.cs}
OnStageDisconnection()
~~~

[Back to top](#top)

<a name="sizenegotiation"></a>
### Size Negotiation

Size negotiation controls the size of views in a container.

Size negotiation is implemented via a range of `ResizePolicies`, declared in the `ResizePolicyType` enum.
 
| Name                            | Description                                                                   |
|--------------------------------------|--------------------------------------------------------------------------|
| Fixed                     | Size is fixed as set by SetSize (default)      |
| UseNaturalSize            | Size is to use the views's natural size, e.g. The dimensions of the image, or the size of the text |
| FillToParent              | Size is to fill up to the views's parent's bounds. Aspect ratio is not maintained. |
| SizeRelativeToParent      | Fill up the parent with a relative scale. Use SetSizeModeFactor to specify the ratio to fill up to the parent. |
| SizeFixedOffsetFromParent | Fill up the parent, and add a fixed offset using SetSizeModeFactor.|
| FitToChildren             | Size will adjust to wrap around all children e.g. A popup's height may resize itself around it's contents. |
| DimensionDependency       | One dimension is dependent on the other |
| UseAssignedSize           | The size will be assigned to the view |


- ResizePolicy::FIXED: This is the option to use when you want the specific definite size as set by SetSize (This is the default for all actors)
- ResizePolicy::USE_NATURAL_SIZE: Use this option for objects such as images or text to get their natural size e.g. The dimensions of the image, or the size of the text without wrapping. Also use this on TableViews when the size of the table is dependent on its children.

- ResizePolicy::FILL_TO_PARENT: Size will fill up to the size of its parent's size, taking a size factor into account to allow proportionate filling

- ResizePolicy::SIZE_RELATIVE_TO_PARENT: Fill up the parent with a relative scale. Use SetSizeModeFactor to specify the ratio to fill up to the parent.
- ResizePolicy::SIZE_FIXED_OFFSET_FROM_PARENT: Fill up the parent and add a fixed offset using SetSizeModeFactor.
- ResizePolicy::FIT_TO_CHILDREN: Size will scale around the size of the actor's children. E.g. A popup's height may resize itself around it's contents.
- ResizePolicy::DIMENSION_DEPENDENCY: This covers rules such as width-for-height and height-for-width. You specify that one dimension depends on another.

Relayout requests are put in automatically when a property is changed on a view, or a change to the stage hierarchy is
made and manual requests are usually not necessary. The`RelayoutRequest` method is available for deriving controls to call when
they would like themselves to be relaid out.

The following overridable methods provide customization points for the size negotiation algorithm:

* `GetNaturalSize` returns the natural size of the view
 
* `GetHeightForWidth` invoked by the size negotiation algorithm if we have a fixed width.
* `GetWidthForHeight` invoked by the size negotiation algorithm if we have a fixed height.

* Override the `OnRelayout` method to position and resize. `OnRelayout` is called during the relayout process at the end of the frame
  immediately after the new size has been set on the view. i.e after size negotiation is complete. 

* `OnSetResizePolicy` is called when the resize policy is set on a view. Allows deriving views to respond to changes in resize policy.
  `OnSetResizePolicy` can be overridden to receive notice that the resize policy has changed on the control and action can be taken. 

Size negotiation is enabled on controls by default. To disable size negotiation, simply pass in the
`DisableSizeNegotiation` behaviour flag into the control constructor. See [behaviour flags](#controlbehaviour)

[Back to top](#top)

