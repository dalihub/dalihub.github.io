<a name="0"></a>
# Button Tutorial

This tutorial describes the NUI button controls including, _PushButton_, _Checkbox_, _Radio_ and _Toggle_.

In this tutorial the following subjects are covered:

[Button creation](#1)<br>
[Button states](#2)<br>
[Button events](#3)<br>
[Button visuals](#4)<br>
[Tool tips](#5)<br>
[Button properties](#6)<br>

## Overview

The *Button* class is the base class for the button UI components.

Buttons can be _selected_, _disabled_, and _togglable_.

A *push button* changes its appearance when pressed, and returns to its original appearance when released.

The *check box* can be checked or unchecked.

The *radio button* has two states selected and unselected. Usually radio buttons are grouped, in a group only one
radio button can be selected at a given time.

The *toggle button* allows the user to switch a feature on or off. Toggle buttons also support tooltips.

<a name="1"></a>
### Button creation

push button:

~~~{.cs}
private TableView _contentContainer;

_window = Window.Instance;
_contentContainer = new TableView(6, 5);

...
...
PushButton button = new PushButton();
button.LabelText = "Process";
button.ParentOrigin = ParentOrigin.BottomLeft;

_contentContainer.AddChild(button, new TableView.CellPosition(....    );
_window.Add(_contentContainer);

~~~

In this example the button is added to a Table View UI component.

check box button:

~~~{.cs}
CheckBoxButton checkBoxbutton = new CheckBoxButton();
checkBoxbutton.LabelText = "Yes";
checkBoxbutton.BackgroundColor = Color.White;
~~~

Grouped radio buttons:

~~~{.cs}
View radioGroup = new View();
radioGroup.SetParentOrigin.Centre;

RadioButton button1 = new RadioButton();
button1.LabelText = "Yes";
button1.Selected = true;
radioGroup.Add(button1);

RadioButton button2 = new RadioButton();
button2.LabelText = "No";
radioGroup.Add(button2);
~~~

Toggle button:

~~~{.cs}
ToggleButton toggleButton = new ToggleButton();
~~~

[Back to top](#0)

<a name="2"></a>
### Button states

Buttons are _selectable_, can be _disabled_, and are _togglable_.

The Button class provides the _Toggable_ and _Selected_ properties.

The _View_ class provides the _Disabled_ property.

[Back to top](#0)

<a name="3"></a>
### Button events

There are 4 events associated with the Button class:

+ Clicked	- The button is touched, and the touch point doesn't leave the boundary of the button.
+ Pressed	- The button is touched
+ Released	- The button is touched, and the touch point leaves the boundary of the button.
+ StateChanged	- The button's state is changed.

Here is an example of adding an event handler to a push button _Clicked_ event:

~~~{.cs}
pushButton.Clicked += (obj, e) =>
{
   PushButton sender = obj as PushButton;
   sender.LabelText = "Click Me";
   return true;
};
~~~

Events are not fired when the disabled property is set to true.

The Button class provides the following properties which modify the fired events:

1. When *autorepeating* is set to true, the Pressed, Released and Clicked events are fired at regular
   intervals while the button is touched.

The interval times can be modified with the _InitialAutoRepeatingDelay_ and _NextAutoRepeatingDelay_ properties.
 
A togglable button can't be autorepeating. If the autorepeating property is set to true,
then the togglable property is set to false but no event is fired.
 
2. When *togglable* is set to true, a _StateChanged_ event is fired, with the selected state.

For a checkbox all 4 events are available, usually only the _StateChanged_ event is used to notify
when the button changes its state to selected or unselected.

For a radio button use the _StateChanged_ event to check when the radio button is selected.

[Back to top](#0)

<a name="4"></a>
### Button visuals

_Visuals provide reusable rendering logic which can be used by all controls. Images and icons are added
to buttons via the use of visuals_.

The button's appearance can be modified by setting properties for the various 'state' Visuals.

A control has 3 states - NORMAL, FOCUSED and DISABLED. Buttons have sub states: SELECTED and UNSELECTED.
Each state and sub-state should have the required visuals. A visual can be common between states.

When pressed the unselected visuals are replaced by the selected visual. The text label is always
placed on the top of all images.
 
When the button is disabled, background, button and selected visuals are replaced by
their disabled visuals.

This example illustrates the toggle button _StateVisuals_ property, which has visuals for each state:
 
~~~{.cs}
ToggleButton toggleButton = new ToggleButton();

PropertyArray array = new PropertyArray();
array.Add(new PropertyValue("./images/star-highlight.png"));
array.Add(new PropertyValue("./images/star-mod.png"));
array.Add(new PropertyValue("./images/star-dim.png"));
toggleButton.StateVisuals = array;

PropertyArray tooltips = new Dali.PropertyArray();
tooltips.Add(new PropertyValue("State A"));
tooltips.Add(new PropertyValue("State B"));
tooltips.Add(new PropertyValue("State C"));
toggleButton.Tooltips = tooltips;

toggleButton.WidthResizePolicy  = ResizePolicyType.FillToParent;
toggleButton.HeightResizePolicy = ResizePolicyType.FillToParent;
~~~

The ![styling tutorial](Styling-Controls.md) describes button styling with visuals.

[Back to top](#0)

<a name="5"></a>
### Tool tips

There are various methods of adding tooltips to a button:

1. Use the View class _TooltipText_ property:

~~~{.cs}
PushButton button = new PushButton();

// Add a simple text only tooltip
button.TooltipText = "Simple Tooltip";
~~~

2. Use a property array as shown in the example in the [Visuals section](#4)

3. Property maps

In this example an array of property map's is created for a tooltip with one icon and one text visual:

~~~{.cs}
PushButton button = new PushButton();

// Create a property map for a tooltip with one icon and one text
PropertyArray iconTooltipContent = new Property.Array();

// Icon
PropertyMap iconVisual = new PropertyMap();
iconVisual.Add(Dali.Constants.Visual.Property.Type, new PropertyValue((int)Dali.Constants.Visual.Type.Image))
          .Add(Dali.Constants.ImageVisualProperty.URL, new PropertyValue("./images/star-highlight.png"));

iconTooltipContent.Add(new PropertyValue(iconVisual));

// Text 
PropertyMap textVisual = new PropertyMap();
textVisual.Add(Dali.Constants.Visual.Property.Type, new PropertyValue((int)Dali.Constants.Visual.Type.Text))
          .Add(Dali.Constants.TextVisualProperty.Text, new PropertyValue("Tooltip with Icon"));

iconTooltipContent.Add(new PropertyValue(textVisual));

// Icon tool tip
PropertyMap iconTooltip = new PropertyMap();
iconTooltip.Add(Dali.Constants.Tooltip.Property.Content, new Property.Value(iconTooltipContent))
	   .Add(Dali.Constants.Tooltip.Property.Tail, new PropertyValue(true));

// Add the tooltip with icon and text to the push button
button.Tooltip = iconTooltip;
~~~

The _Tooltip_ property is inherited from the_View_ class.

[Back to top](#0)

<a name="6"></a>
### Button Properties

The properties available in the *Button* base class are:

| Property  | Type | Description
| ------------ | ------------ | ------------ |
| UnselectedVisual | Map | A map describing visual, changes dependent on state | 
| SelectedVisual | Map | a map describing visual, changes dependent on state |
| DisabledUnselectedVisual | Map | A map describing visual, changes dependent on state | 
| DisabledSelectedVisual | Map | a map describing visual, changes dependent on state |
| UnselectedBackgroundVisual | Map | A map describing visual, changes dependent on state | 
| SelectedBackgroundVisual | Map | a map describing visual, changes dependent on state |
| DisabledUnselectedBackgroundVisual | Map | A map describing visual, changes dependent on state | 
| DisabledSelectedBackgroundVisual | Map | a map describing visual, changes dependent on state |
| LabelRelativeAlignment | Align | Position of text label in relation to foreground/icon when both are present |
| LabelPadding | Vector4 | The padding area around the label (if present) |
| ForegroundVisualPadding | Vector4 | The padding area around the foreground/icon visual (if present) |
| AutoRepeating | bool | autorepeating is described in the [button events](#3) section |
| InitialAutoRepeatingDelay | float | Stores the initial autorepeating delay in seconds (current default setting 0.15s) |
| NextAutoRepeatingDelay | float | Stores the next autorepeating delay in seconds (current default setting 0.05s) |
| Togglable | bool | If the togglable property is set to true, then the autorepeating property is set to false. |
| Selected | bool | Sets the toggable button as either selected or unselected |
| UnselectedColor | Color | Gets/Sets the unselected color |
| SelectedColor | Color | Gets/Sets the selected color |
| Label | Map | Stores the button text label |
| LabelText | string | Stores the button text label |

Note: If the autorepeating property is set to true then the togglable property is set to false.

The properties available for the *ToggleButton* class are:

| Property  | Type | Description
| ------------ | ------------ | ------------ |
| StateVisuals | Array | Array of property-maps, or a property array of strings. The property map expects a description of visual, and string represents an image url. | 
| Tooltips | Array | Array of toggle state tooltip strings. Each tooltip string should match a toggle state |
| CurrentStateIndex | int | current state |

[Back to top](#0)

