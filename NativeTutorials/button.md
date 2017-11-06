<a name="0"></a>
# Button Tutorial

This tutorial describes the button controls including, _PushButton_, _Checkbox_, _Radio_ and _Toggle_.

In this tutorial the following subjects are covered:

[Button creation with Visuals](#1)<br>
[Button events](#3)<br>

## Overview

The *Button* class is the base class for the button UI components.

Buttons can be  _disabled_.

Buttons can be made _togglable_. and then _selected_ or _unselected_

A *push button* changes its appearance when pressed, and returns to its original appearance when released.

The *check box* can be checked or unchecked.

The *radio button* has two states selected and unselected. Usually radio buttons are grouped, in a group only one
radio button can be selected at a given time.

The *toggle button* allows the user to switch a feature on or off. Toggle buttons also support tooltips.

<a name="1"></a>
### Button creation with Visuals

#### Using Visuals

Below Example of PushButton sets the SELECTED_BACKGROUND_VISUAL as "pressed-image-file.jpg" and the UNSELECTED_BACKGROUND_VISUAL as "unselected-image-file.jpg"

Tizen 3.0<br>
UNSELECTED_BACKGROUND_VISUAL = Dali::Toolkit::Button::Property::UNSELECTED_STATE_IMAGE.<br>
SELECTED_BACKGROUND_VISUAL = Dali::Toolkit::Button::Property::SELECTED_STATE_IMAGE.<br>
DISABLED_UNSELECTED_BACKGROUND_VISUAL = Dali::Toolkit::Button::Property::DISABLED_STATE_IMAGE.<br>

Buttons can contain various Visuals not just ImageVisual.

Below is an example using [ImageVisual](#ButtonWithImageVisual), [TextVisual](#ButtonWithTextVisual) and [ColorVisual](#ButtonWithColorVisual)

<a name="ButtonWithImageVisual"></a>
##### Setting ImageVisual using Property Map

~~~{.cpp}
...
PushButton button = PushButton::New();

Property::Map imagePropertyMap;
              imagePropertyMap.Add( Visual::Property::TYPE,  Visual::IMAGE )
              imagePropertyMap.Add( ImageVisual::Property::URL, "pressed-image-file.jpg" );

button.SetProperty( DevelButton::Property::SELECTED_BACKGROUND_VISUAL, imagePropertyMap );

imagePropertyMap.Clear();
imagePropertyMap.Add( Visual::Property::TYPE,  Visual::IMAGE )
imagePropertyMap.Add( ImageVisual::Property::URL, "unselected-image-file.jpg" );

button.SetProperty( DevelButton::Property::UNSELECTED_BACKGROUND_VISUAL, LOADING_IMAGE );

button.ClickedSignal().Connect( this, &ButtonClicked );

contentContainer.AddChild( button );

~~~

<a name="ButtonWithTextVisual"></a>
#### Setting Text to a PushButton using a Property Map (Full Control)

~~~{.cpp}
Toolkit::PushButton button = Toolkit::PushButton::New();
Property::Map textSettingsMap;
              textSettingsMap.Add( Visual::Property::TYPE, Toolkit::Visual::TEXT )
                             .Add( TextVisual::Property::TEXT, "Press Me" )
                             .Add( TextVisual::Property::MULTI_LINE, true )
                             .Add( TextVisual::Property::POINT_SIZE, 12.0f );

button.SetProperty( Toolkit::Button::Property::LABEL, textSettingsMap );
~~~


<a name="ButtonWithColorVisual"></a>
#### Setting a ColorVisual to a PushButton using a Property Map

~~~{.cpp}
Toolkit::PushButton button = Toolkit::PushButton::New();
Property::Map visualSettingMap;
              visualSettingMap.Add( Visual::Property::TYPE, Toolkit::Visual::COLOR )
                              .Add( ColorVisual::Property::MIX_COLOR, Vector4( R, G, B, 1.0f ) );

button.SetProperty( DevelButton::Property::UNSELECTED_BACKGROUND_VISUAL, visualSettingMap );

OR

button.SetProperty( Toolkit::Button::Property::UNSELECTED_STATE_IMAGE, visualSettingMap );


~~~
<a name="ButtonWithMixedVisuals"></a>
#### Setting a ColorVisual for the background and a TextVisual for the Label.

Using the above ColorVisual and TextVisual to have a color background with text in the foreground.

~~~{.cpp}
Toolkit::PushButton button = Toolkit::PushButton::New();
Property::Map visualSettingMap;
              visualSettingMap.Add( Visual::Property::TYPE, Toolkit::Visual::COLOR )
                              .Add( ColorVisual::Property::MIX_COLOR, Vector4( R, G, B, 1.0f ) );

button.SetProperty( Toolkit::Button::Property::UNSELECTED_STATE_IMAGE, visualSettingMap );

Property::Map textSettingsMap;
              textSettingsMap.Add( Visual::Property::TYPE, Toolkit::Visual::TEXT )
                             .Add( TextVisual::Property::TEXT, "Press Me" )
                             .Add( TextVisual::Property::MULTI_LINE, true )
                             .Add( TextVisual::Property::POINT_SIZE, 12.0f );

button.SetProperty( Toolkit::Button::Property::LABEL, textSettingsMap );


~~~


#### Setting Text to a Button using a string (Basic)

~~~{.cpp}
Toolkit::PushButton button = Toolkit::PushButton::New();
button.SetProperty( Toolkit::Button::Property::LABEL, "Select" );
~~~

#### Check box button set up

~~~{.cpp}
CheckBoxButton checkBoxbutton = new CheckBoxButton();
checkBoxbutton.LabelText = "Yes";
checkBoxbutton.BackgroundColor = Color.White;
~~~

#### Radio buttons set up in a Group

~~~{.cpp}
Control radioGroup = Control::New();
radioGroup.SetParentOrigin.Centre;

RadioButton button1 = RadioButton::New();
button1.LabelText = "Yes";
button1.Selected = true;
radioGroup.Add(button1);

RadioButton button2 = RadioButton::New();
button2.LabelText = "No";
radioGroup.Add(button2);
~~~

#### Toggle button set up

~~~{.cpp}
ToggleButton toggleButton = ToggleButton::New();
~~~

[Back to top](#0)

<a name="3"></a>
### Button events

There are 4 events associated with the Button class:

+ Clicked	- The button is touched, and the touch point doesn't leave the boundary of the button.
+ Pressed	- The button is touched
+ Released	- The button is touched, and the touch point leaves the boundary of the button.
+ StateChanged	- The button's state is changed.

Here is an example of adding an event handler to a push button _Clicked_ event:

~~~{.cpp}
  button.ClickedSignal().Connect( this, &ButtonClicked );

  bool ChangeImageClicked( Button button )
  {
    ...
    // button pressed
    return true;
  }
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
