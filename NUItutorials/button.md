<a name="0"></a>
# Button Tutorial

This tutorial describes the NUI button controls including: _PushButton_, _Checkbox_, _Radio_ and _Toggle_.

In this tutorial:

[Button creation](#1)
[Button events](#2)
[](#3)
[buttons and visuals](#4)
[Tool tips](#5)
[](#6)
[](#7)
[properties](#8)

## Overview

A pushbutton changes its appearance when pressed and returns to its original appearance when released.

The check box can be checked or unchecked.

The radio button has two states selected and unselected. Usually radio buttons are grouped, in a group only one
radio button can be selected at a given time.

The toggle button allows the user to switch a feature on or off. Toggle buttons also support tooltips.

<a name="2"></a>
## The Button class and events

The _Button_ class is the base class for the _PushButton_, _Checkbox_, _Radio_ and _Toggle_ button classes.

The Button class provides the disabled property.

There are 4 events associated with the Button class:

+ Clicked      - The button is touched and the touch point doesn't leave the boundary of the button.
+ Pressed      - The button is touched
+ Released     - The button is touched and the touch point leaves the boundary of the button.
+ StateChanged - The button's state is changed.

When the \e disabled property is set to \e true, events are not emitted.

The Button provides the following properties which modify when events are emitted:

 <ul>
    <li>\e autorepeating
        When \e autorepeating is set to \e true, Pressed,Released and Clicked events are emitted at regular
      intervals while the button is touched.

      The intervals could be modified with the Button::SetInitialAutoRepeatingDelay and Button::SetNextAutoRepeatingDelay methods.
 
     A \e togglable button can't be \e autorepeating. If the \e autorepeating property is set to \e true,
       then the \e togglable property is set to false but no signal is emitted.
 
    <li>\e togglable
       When \e togglable is set to \e true, a Button::StateChangedSignal() signal is emitted, with the selected state.
 </ul>

Adding an event handler to a Clicked event:
~~~{.cs}

pushButton.Clicked += (obj, e) =>
{
   e.Button.LabelText = "Click Me";
   e.Button.UnselectedColor = new Vector4(0.0f, 0.0f, 1.0f, 1.0f);
   return true;
};

The entire button area has the unselected color

For a checkbox all 4 events are available, usually only the StateChanged event is used to notify
when the button changes its state to selected or unselected.

For a radio button use the StateChanged event to check when the radio button is selected.

~~~

<a name="1"></a>
## The Button class and visuals


<a name="1"></a>
### Button creation

push button:

~~~{.cs}
Button button = new Button();
button.SetParentOrigin.BottomLeft;
button.LabelText = "Process";

Window window = Window.Instance;
window.Add(button;
~~~

check box button:

~~~{.cs}
CheckBoxButton checkBoxbutton = new CheckBoxButton();
button.LabelText = "Yes";
button.BackgroundColor = Color.White;

   _contentContainer.AddChild(checkBoxButton, new TableView.CellPosition(((uint)idx / 5) * 2 + 1, (uint)idx % 5));

Window window = Window.Instance;
window.Add(button;
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

Window window = Window.Instance;
window.Add(radioGroup);

            tableView.AddChild(rButton, new TableView.CellPosition(...));
            _contentContainer.AddChild(tableView, new TableView.CellPosition(....);

           _window.Add(_contentContainer);
~~~

Toggle button

~~~{.cs}

ToggleButton toggleButton = new ToggleButton();

_contentContainer.AddChild(toggleButton, new TableView.CellPosition(.........);
~~~

<a name=""></a>
### Button images and Visuals

The button's appearance can be modified by setting properties for the various visuals/images.

_Visuals provide reusable rendering logic which can be used by all controls_.

Images and icons are added to buttons via the use of visuals.

'Visual' describes not just traditional images like png, bmp but refers to whatever is used to show the button, it could be a color, gradient or some other kind of renderer.

It is not mandatory to set all visuals. A button could be defined only by setting its \e background visual or by setting its \e background and \e selected visuals.
 
The \e button visual is shown over the \e background visual.
When pressed the unselected visuals are replaced by the \e selected visual. The text label is always placed on the top of all images.
 
When the button is disabled, \e background, \e button and \e selected visuals are replaced by their \e disabled visuals.

A control has 3 states: NORMAL, FOCUSED and DISABLED. Each state should have the required visuals.

A different background Visual can be supplied for NORMAL, FOCUSED and DISABLED if required.

Button has sub states: SELECTED and UNSELECTED

Each state can have its own set of visuals or a visual can be common between states. NORMAL, FOCUSED and DISABLED states will each have these sub-states.

You may want a different backgroundVisual for SELECTED and UNSELECTED state.



Visuals are described in detail in a seperate tutorial.

See also ![styling tutorial]()

~~~{.cs}
using NUI;

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

toggleButton.Clicked += (obj, e) =>
{
    Console.WriteLine("Toggle button state changed.");
    return true;
};
~~~


![ ](./Images/AutoScroll.gif)

<a name=""></a>
### Tool tips

                   PushButton buttonWithIconTooltip = new PushButton();
                    buttonWithIconTooltip.LabelText = "Tooltip with Text and Icon";
                    buttonWithIconTooltip.WidthResizePolicy = "FILL_TO_PARENT";
                    buttonWithIconTooltip.UnselectedColor = new Vector4(0.5f, 0.5f, 0.7f, 1.0f);
                    buttonWithIconTooltip.SelectedColor = new Vector4(0.7f, 0.5f, 0.7f, 1.0f);

                    tableView.AddChild(buttonWithIconTooltip, new TableView.CellPosition(1, 0));

                    // Add a simple text only tooltip to the first push button
                    buttonWithSimpleTooltip.TooltipText = "Simple Tooltip";

                    // Create a property map for a tooltip with one icon and one text
                    Property.Array iconTooltipContent = new Property.Array();

                    Property.Map iconVisual = new Property.Map();
                    iconVisual.Add(Dali.Constants.Visual.Property.Type, new Property.Value((int)Dali.Constants.Visual.Type.Image))
                      .Add(Dali.Constants.ImageVisualProperty.URL, new Property.Value("./images/star-highlight.png"));
                    iconTooltipContent.Add(new Property.Value(iconVisual));

                    Property.Map textVisual = new Property.Map();
                    textVisual.Add(Dali.Constants.Visual.Property.Type, new Property.Value((int)Dali.Constants.Visual.Type.Text))
                      .Add(Dali.Constants.TextVisualProperty.Text, new Property.Value("Tooltip with Icon"));
                    iconTooltipContent.Add(new Property.Value(textVisual));

                    Property.Map iconTooltip = new Property.Map();
                    iconTooltip.Add(Dali.Constants.Tooltip.Property.Content, new Property.Value(iconTooltipContent))
                      .Add(Dali.Constants.Tooltip.Property.Tail, new Property.Value(true));

                    // Add the tooltip with icon and text to the second push button
                    buttonWithIconTooltip.Tooltip = iconTooltip;



#### 



|  | |
| ------------ | ------------ |
| | |
|              | |
| | |


See [xxx](#2)

~~~{.cs}
label.Text = "<font family='SamsungSans' weight='bold'>Hello world</font>";
~~~

<a name=""></a>
### Button Properties

All text label properties are writable.

All text label properties are not animatable.

The properties available for the Button class are:

| Property  | Type | Description
| ------------ | ------------ | ------------ |
| UnselectedVisual | Map | map describing visual | 
| SelectedVisual | Map | 
| DisabledSelectedVisual | Map | 
| DisabledUnselectedVisual | Map | 
| UnselectedBackgroundVisual | Map | 
| SelectedBackgroundVisual | Map | 
| DisabledUnselectedBackgroundVisual | Map | 
| DisabledSelectedBackgroundVisual | Map | 
| LabelRelativeAlignment | string | 
| LabelPadding | Vector4 | 
| ForegroundVisualPadding | Vector4 | 
| AutoRepeating | | 
| InitialAutoRepeatingDelay | float |
| NextAutoRepeatingDelay | float | 
| Togglable | bool | 
| Selected | bool | 
| UnselectedColor | Map | 
| SelectedColor | Map | 
| Label | | 
| LabelText | |
| | |
| | |



### More information on Buttons in NUI

The [xxx tutorial](xxx.md) describes how to ...

[Back to top](#0)




~~~{.cs}
PropertyMap textStyle = new PropertyMap();
textStyle.Add(ENABLE_KEY, TRUE_TOKEN);
textStyle.Add(HEIGHT_KEY, 2.0f); // 2 pixel height
label1.Underline = textStyle;
~~~


