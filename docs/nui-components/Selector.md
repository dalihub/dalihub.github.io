# Selector
This tutorial describes how to use selector.

## Overview
Selector class, which is related by Control State.  
Control have 8 State: Normal, Focused, Disabled, Selected, Pressed, DisabledFocused, SelectedFocused and DisabledSelected.  
All and Other is added for convinience.  
User can set different value for different state by Selector.

## Example of how to use Selector
1. Create Button by default constructor

~~~{.cs}
utilityBasicButton = new Button();
~~~

2. Set button property

~~~{.cs}
utilityBasicButton.OverlayImageURLSelector = new StringSelector
{
    Pressed = "rectangle_btn_press_overlay.png",
    Other = ""
};
utilityBasicButton.OverlayImageBorder = new Rectangle(5, 5, 5, 5);

utilityBasicButton.TextColorSelector = new ColorSelector
{
    Normal = new Color(0, 0, 0, 1),
    Pressed = new Color(0, 0, 0, 0.7f),
    Selected = new Color(0.058f, 0.631f, 0.92f, 1),
    Disabled = new Color(0, 0, 0, 0.4f)
};

utilityBasicButton.Size2D = new Size2D(300, 80);
utilityBasicButton.Position2D = new Position2D(100, 300);
utilityBasicButton.PointSize = 20;
utilityBasicButton.Text = "UtilityBasicButton";
root.Add(utilityBasicButton);
~~~

3. Usgae of Selector  
Button OverlayImageURLSelector is a StringSelector inherit from Selector.  
Button TextColorSelector is a ColorSelector inherit from Selector.  
User can set different OverlayImageURL and TextColor for different 8 state.

~~~{.cs}
utilityBasicButton.OverlayImageURLSelector = new StringSelector
{
    Pressed = "rectangle_btn_press_overlay.png",
    Other = ""
};
~~~

"Other" means OverlayImageURL is rectangle_btn_press_overlay.png when Button is in Pressed state. Except Pressed state, OverlayImageURL is empty string.       
"All" means all 8 state is set to the same value.
