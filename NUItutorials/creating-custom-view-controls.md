<a name="top"></a>
# Creating Custom View controls 

[Overview](#overview)<br>
[Guidelines for creating a custom view](#guidelines)<br>
[The existing CustomView class](#existingcustomview)<br>
[Creation of a Custom View](#creation)<br>
[Rendering](#rendering)<br>
[Styling](#stylable)<br>
[Type registration](#typeregistration)<br>
[Properties in Custom Views](#properties)<br>
[Enabling properties for JSON access](#enableproperties)<br>
[Creating Transitions](#creatingtransitions)<br>
[Setting view behaviour](#viewbehaviour)<br>
[Events](#events)<br>
[Gestures](#gestures)<br>
[Accessibility](#accessibility)<br>
[Window connection](#defaultwindowconnection)<br>
[Size Negotiation](#sizenegotiation)<br>

<a name="overview"></a>
### Overview
NUI provides the ability to create custom views.

<a name="guidelines"></a>
### General guidelines for creating a custom view
+ Derive your view from the `CustomView` class.
+ Use **properties** as much as possible, as views should be data driven.
  + These views will be used through JavaScript and JSON files.
+ The view can be updated when the properties change (e.g. style change)
  + Ensure the view deals with these property changes gracefully, on both first and subsequent times they are set
+ Use visuals rather than creating several child views.
  + Ensures that the rendering pipeline is more efficient
+ Accessibility actions should be considered when designing the view.
+ Use `Events` if the application needs to react to changes in the view state.
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

* **ContactView** which consists of four visuals (Image, Primitive, Text and Color), to display contact information.
  All of these visuals can be configured via properties - ImageURL (Image), Shape (Primitive), Name (Text) and Color.
  Tap gesture is also enabled on the `ContactView` which changes the color visual to some random color when the
  ContactView is tapped.

![ ](./Images/ContactView.png)

The contact view screenshot shows 5 contacts, each with the 4 visuals.

* A **VisualView** control enabling the addition of any visual. See [Visual View class](visuals.md#visualview)

* A **StarRating** custom control, for 'star' rating of images (draggable to change the rating).

#### CustomView methods
 
Key `CustomView` methods include:

| Name                   | Description |
| -----------------------|------------ |
| OnInitialize           | Called after the view has been initialized.  |
| SetBackground          | Set the background with a property map.         |
| EnableGestureDetection | Allows deriving classes to enable any of the gesture detectors that are available              |
| RegisterVisual         | Register a visual by 'property index', linking a view to visual when required. |
| CreateTransition       | Create a transition effect on the view - for animations. |
| RelayoutRequest        | Request a relayout, which means performing a size negotiation on this view, its parent and children (and potentially whole scene) |
| OnStageConnection      | Called after the view has been connected to the stage 'default window' |


[Back to top](#top)
 
<a name="creation"></a>
### Custom View Creation

A view is created with the `new` operator:

~~~{.cs}
contactView = new ContactView()
~~~

Each custom C# View should have it's static constructor called before any JSON file is loaded.
Static constructors for a class will only run once ( they are run per view, not per instance).
The View should register it's type inside the static constructor e.g.

~~~{.cs}
static ContactView()
{
    ViewRegistry.Instance.Register(CreateInstance, typeof(ContactView));
}
~~~

The `ViewRegistry` method registers the views and any scriptable properties they have with the `Type Registry'.

The View should also provide a `CreateInstance` function, which gets passed to the `ViewRegistry` method.
`CreateInstance` will be called if the view is in a JSON file:

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

To render content, the required views can be created and added to the control itself as its children.
However, this solution is not fully optimised and means extra views will be added, which is extra processing.
 
It is recommended to use/reuse visuals to create the required content. See [Visuals tutorial](visuals.md).
 
The following code snippet shows the creation and registration of an image visual in `ContactView.cs`.

~~~{.cs}

private VisualBase _imageVisual;

...
...

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

Note: The `ImageURL` property is a [ScriptableProperty](#enableproperties), which automatically generates indices.

`RegisterVisual` registers a visual by a 'property index', linking a view to a visual when required.

`GetPropertyIndex` gets the generated index corresponding to the property name.

A range of property indices are provided for `ImageVisualPropertyIndex`, 0 by default.

The [Visuals tutorial](visuals.md) describes the property maps that can be used for each visual type.

[Back to top](#top)
 
<a name="stylable"></a>
### Ensuring View is Stylable

The NUI property system allows custom views to be easily styled. The JSON Syntax is used in the stylesheets:
 
**JSON Styling Syntax Example - current format:**

This is an example of the current stylesheet 'format', (_as at July 2017_). This example includes a visual.

~~~{.json}

  "styles":
  {

...
...

    "TextField":
    {
      "pointSize":18,
      "primaryCursorColor":[0.0,0.72,0.9,1.0],
      "secondaryCursorColor":[0.0,0.72,0.9,1.0],
      "cursorWidth":3,
      "selectionHighlightColor":[0.75,0.96,1.0,1.0],
      "grabHandleImage" : "{DALI_STYLE_IMAGE_DIR}cursor_handler_drop_center.png",
      "selectionHandleImageLeft" : {"filename":"{DALI_STYLE_IMAGE_DIR}selection_handle_drop_left.png" },
      "selectionHandleImageRight": {"filename":"{DALI_STYLE_IMAGE_DIR}selection_handle_drop_right.png" },
      "enableSelection":true
    },

...
...

    "TextFieldFontSize0":
    {
      "pointSize":10
    },

...
...

    "TextSelectionPopup":
    {
      "popupMaxSize":[656,72],
      "optionDividerSize":[2,0],
      "popupDividerColor":[0.23,0.72,0.8,0.11],
      "popupIconColor":[1.0,1.0,1.0,1.0],
      "popupPressedColor":[0.24,0.72,0.8,0.11],
      "background": {
        "visualType": "IMAGE",
        "url": "{DALI_IMAGE_DIR}selection-popup-background.9.png"
        },
      "backgroundBorder": {
        "visualType": "IMAGE",
        "url": "{DALI_IMAGE_DIR}selection-popup-border.9.png",
        "mixColor":[0.24,0.72,0.8,1.0]
        },
      "popupFadeInDuration":0.25,
      "popupFadeOutDuration":0.25
    },

~~~

**JSON Styling Syntax Example - 'new' format:**

This is an example of the new stylesheet 'format', currently under development (_July 2017_):

This example also includes a visual.

~~~{.json}

  "states":
  {
    "NORMAL":
    {
      "states":
      {
        "UNSELECTED":
        {
          "visuals":
          {
            "backgroundVisual":
             {
              "visualType":"IMAGE",
              "url":"backgroundUnSelected.png"
             }
          }
        },
        "SELECTED":
        {
          "visuals":
          {
            "backgroundVisual":
             {
              "visualType":"IMAGE",
              "url":"backgroundSelected.png"
             }
          }
        }
      }
    },
~~~

Styling gives the UI designer the ability to change the look and feel of the View without any code changes.
 
| Normal Style | Customized Style |
|:------------:|:----------------:|
|![ ](./Images/popup-normal.png) | ![ ](./Images/popup-styled.png)|
 
The [styling tutorial](styling_controls_with_JSON.md) explains how to build up visuals for the button states using JSON stylesheets,
and transitioning between the various button states.

[Back to top](#top)
 
<a name="typeregistration"></a>
### Type Registration 

The 'Type Registry' is used to register your custom view.

Type registration allows the creation of the view via a JSON file, as well as registering properties, signals, actions,
transitions and animation effects.
 
Type Registration is via the `ViewRegistry` method, see [Custom View creation](#creation).

[Back to top](#top)

<a name="properties"></a>
### Properties in custom views

Properties can be animatable or non-animatable. Examples af animatable `View` properties are - Position, Orientation, Scale, Color etc.

The [Animation tutorial](animation.md) describes the NUI animation framework.

Properties can be accessed via a unique index. The index can be set manually in code ('hard-coded'), or calculated
automatically. `ContactView.cs` contains examples of both indexing methods; fixed for 'depth index', and automatic for
registering visuals. The NUI code base is currently been modified (_July 2017_) to utilise property registration based
solely on automatic generation of indices.

<a name="enableproperties"></a>
### Enabling properties for JSON access - property registration

The `ScriptableProperty` class enables a property to be registered with the `type registry'.

~~~{.cs}
    internal class ScriptableProperty : System.Attribute
~~~

Add `ScriptableProperty` to any property belonging to a view, that you want to be scriptable from JSON.

Property indices are generated automatically in the `ScriptableProperty` class. A unique index for each property
can be obtained by `GetPropertyIndex`, with the name of the property as a parameter.

[Rendering](#rendering) has an example of the use of a 'scriptable property', with `GetPropertyIndex`.

[Back to top](#top)

<a name="creatingtransitions"></a>
### Creating Transitions

#### Transitions

Controls such as buttons change between states from user interaction.
All controls can move between the states NORMAL, FOCUSED and DISABLED.
Whilst in those states, a button has sub-states SELECTED and UNSELECTED.

To move between states and sub-states transition animations can be defined.
Each state and sub-state can have an "entry" and "exit" transition.

To make defining common transitions easier an effect can be used with a "from" and "to" state. One such effect is
CROSSFADE which animates the opacity of visuals fading in and out to give a nice transition.

Transition effects can be read from stylesheets, or 'directly' via the `CreateTransition` API. 

#### CreateTransition API

Its possible to animate 'scriptable properties', by using the `CreateTransition` API from custom view derived classes.

`CreateTransition` creates a transition effect on the view.

~~~{.cs}
protected Animation CreateTransition(TransitionData transitionData)
~~~

where:

* The transition data parameter describes the effect to create.
* The return value is a handle to an animation defined with the given effect, or an empty handle if no properties match.

#### Example of the use of CreateTransition API

This example code is taken from the `AnimateVisual` method in the `VisualView` class. `VisualView` is a custom view derived class.

~~~{.cs}
_alphaFunction = "EASE_IN_OUT_SINE";

...
...

PropertyMap _animator = new PropertyMap();
if ( _alphaFunction != null) {_animator.Add("alphaFunction", new PropertyValue(_alphaFunction));}

PropertyMap _timePeriod = new PropertyMap();
_timePeriod.Add("duration", new PropertyValue((endTime - startTime) / 1000.0f));
_timePeriod.Add("delay", new PropertyValue(startTime / 1000.0f));
_animator.Add("timePeriod", new PropertyValue(_timePeriod));

string _str1 = property.Substring(0, 1);
string _str2 = property.Substring(1);
string _str = _str1.ToLower() + _str2;
if (_str == "position") {_str = "offset";}

PropertyValue destVal = PropertyValue.CreateFromObject(destinationValue);

PropertyMap _transition = new PropertyMap();
_transition.Add("target", new PropertyValue(target.Name));
_transition.Add("property", new PropertyValue(_str));
if (initialValue != null)
{
    PropertyValue initVal = PropertyValue.CreateFromObject(initialValue);
    _transition.Add("initialValue", new PropertyValue(initVal));
}

_transition.Add("targetValue", destVal);
_transition.Add("animator", new PropertyValue(_animator));

TransitionData _transitionData = new TransitionData(_transition);
return this.CreateTransition(_transitionData);
~~~

#### Example of Transition values in a stylesheet

Example using CROSSFADE effect:
 
~~~{json}
"transitions":
[
  {
     "from":"UNSELECTED",
     "to":"SELECTED",
     "visualName":"*",
     "effect":"CROSSFADE",
     "animator":
     {
       "alphaFunction":"EASE_OUT",
       "duration":"0.2,
       "delay":0
     }
  }
]
~~~

[Back to top](#top)

<a name="viewbehaviour"></a>
### Setting View behaviour

The `CustomViewBehaviour` enum specifies the following behaviour:
 
| Behaviour                            | Description                                                                                                    |
|--------------------------------------|----------------------------------------------------------------------------------------------------------------|
| ViewBehaviourDefault                 | Default behavior (size negotiation is on, style change is monitored, event callbacks are not called.)           |
| DisableSizeNegotiation               | If our view does not need size negotiation, i.e. view will be skipped by the size negotiation algorithm. |
| DisableStyleChangeSignals            | True if view should not monitor style change signals such as Theme/Font change.                             |
| RequiresKeyboardNavigationSupport    | True if need to support keyboard navigation. |
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
### Touch, Hover and Wheel Events

+ A **touch event** is when any touch occurs within the bounds of the custom view.
+ A **hover event** is when a pointer moves within the bounds of a custom view (e.g. mouse pointer or hover pointer).
+ A **wheel event** is when the mouse wheel (or similar) is moved while hovering over a view (via a mouse pointer or hover pointer).

The `View` class contains `TouchEvent`, `WheelEvent` and `HoverEvent` events.

[Back to top](#top)

<a name="gestures"></a>
### Gestures

NUI has a gesture system which analyses a stream of touch events and attempts to determine the intention of the user.
The following gesture detectors are provided:
 
 + **Pan:** When the user starts panning (or dragging) one or more fingers.
            The panning should start from within the bounds of the view.
 + **Pinch:** Detects when two touch points move towards or away from each other.
              The center point of the pinch should be within the bounds of the view.
 + **Tap:** When the user taps within the bounds of the view.
 + **LongPress:** When the user presses and holds on a certain point within the bounds of a view.
 
Gesture detectors can be specified in the `OnInitialize` method.
 
This code snippet is taken from the `ContactView` custom view:

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
 
Accessibility behaviour can be customized in the view by overriding certain virtual methods.
An example is `OnAccessibilityTouch`. Touch events are delivered differantly in 'Accessibility' mode.
`OnAccessibilityTouch` should be overridden if some special behaviour is required when these touch events
are received. 

[Back to top](#top)

<a name="defaultwindowconnection"></a>
### Window Connection

Methods are provided in the `CustomView` class that can be overridden if notification is required when our view
is connected to, or disconnected from the window.

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


Note: `UseAssignedSize`-The size will be assigned to the view, is not a resize policy more an implementation detail.


* UseNaturalSize: Use this option for objects such as images or text to get their natural size e.g. The dimensions of the image,
  or the size of the text without wrapping. Also use this on `TableViews` when the size of the table is dependent on its children.

* FillToParent: Size will fill up to the size of its parent's size, taking a size factor into account to allow proportionate filling

* FitToChildren: Size will scale around the size of the view's children. E.g. A popup's height may resize itself around it's contents.

* DimensionDependency: This covers rules such as width-for-height and height-for-width. You specify that one dimension depends on another.

Here is an example of setting resize policy for a custom view:

~~~{.cs}
contactView = new ContactView();
contactView.WidthResizePolicy  = ResizePolicyType.FillToParent;
contactView.HeightResizePolicy = ResizePolicyType.FillToParent;
~~~

Relayout requests are put in automatically when a property is changed on a view, or a change to the stage hierarchy is
made and manual requests are usually not necessary. The`RelayoutRequest` method is available for deriving views to call when
they would like themselves to be relaid out.

The following overridable methods provide customization points for the size negotiation algorithm:

* `GetNaturalSize` returns the natural size of the view
 
* `GetHeightForWidth` Returns the height for a given width. Invoked by the size negotiation algorithm if we have a fixed width.
* `GetWidthForHeight` Returns the width for a given height. Invoked by the size negotiation algorithm if we have a fixed height.

* Override the `OnRelayout` method to position and resize. `OnRelayout` is called during the relayout process at the end of the frame
  immediately after the new size has been set on the view. i.e after size negotiation is complete. 

* `OnSetResizePolicy` is called when the resize policy is set on a view. Allows deriving views to respond to changes in resize policy.
  `OnSetResizePolicy` can be overridden to receive notice that the resize policy has changed on the view and action can be taken. 

Size negotiation is enabled on views by default. To disable size negotiation, simply pass in the
`DisableSizeNegotiation` behaviour flag into the view constructor. See [behaviour flags](#viewbehaviour)

[Back to top](#top)

