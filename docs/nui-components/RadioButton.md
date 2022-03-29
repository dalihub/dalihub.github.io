[HomePage](./Guide.md)<br>

# RadioButton
This tutorial describes how to create and use RadioButton.

## Overview
Popup is one kind of common component, it is inherited from SelectButton.
It can be used as selector and add into group for single-choice.

## Create with property
1. Create RadioButton by default constructor

~~~{.cs}
RadioButton[] utilityRadioButton = new RadioButton[4];
for (int i = 0; i < num; i++)
{
    utilityRadioButton[i] = new RadioButton();
}
~~~

2. Set RadioButton property

~~~{.cs}
for (int i = 0; i < num; i++)
{
    utilityRadioButton[i].Size2D = new Size2D(48, 48);
    utilityRadioButton[i].Position2D = new Position2D(300, 300 + i * 100);
    utilityRadioButton[i].CheckImageSize2D = new Size2D(48, 48);
    utilityRadioButton[i].CheckImagePaddingLeft = 5;
    utilityRadioButton[i].CheckImagePaddingRight = 5;
    utilityRadioButton[i].CheckImageOpacitySelector = new FloatSelector
    {
        Normal = 1.0f,
        Selected = 1.0f,
        Disabled = 0.4f,
        DisabledSelected = 0.4f
    };
    utilityRadioButton[i].CheckImageURLSelector = new StringSelector
    {
        Normal = "controller_btn_radio_off.png",
        Selected = "controller_btn_radio_on.png",
        Disabled = "controller_btn_radio_off.png",
        DisabledSelected = "controller_btn_radio_on.png",
    };
    root.Add(utilityRadioButton[i]);
}
utilityRadioButton[2].IsEnabled = false;
utilityRadioButton[2].IsSelected = false;
utilityRadioButton[3].IsEnabled = false;
utilityRadioButton[3].IsSelected = true;
~~~

3. Create RadioButtonGroup

~~~{.cs}
RadioButtonGroup group = new RadioButtonGroup();
~~~

4. Add RadioButton to RadioButtonGroup

~~~{.cs}
for (int i = 0; i < num; i++)
{
    group.Add(utilityRadioButton[i]);
}
~~~

RadioButton created by property:

![RadioButtonProperty](../../assets/images/components/RadioButtonProperty.PNG)
## Create with attributes
1. Create SelectButton attributes

~~~{.cs}
SelectButtonAttributes utilityAttrs = new SelectButtonAttributes
{
    CheckImageAttributes = new ImageAttributes
    {
        Size2D =  new Size2D(48, 48),
        ResourceURL = new StringSelector
        {
            Normal = "controller_btn_radio_off.png",
            Selected = "controller_btn_radio_on.png",
            Disabled = "controller_btn_radio_off.png",
            DisabledSelected = "controller_btn_radio_on.png",
        },
        Opacity = new FloatSelector
        {
            Normal = 1.0f,
            Selected = 1.0f,
            Disabled = 0.4f,
            DisabledSelected = 0.4f
        },
    },            
};
~~~

2. Use the attributes to create a RadioButton and add RadioButton to parent

~~~{.cs}
for(int i = 0; i < num; i++)
{
    utilityRadioButton2[i] = new RadioButton(utilityAttrs);
    utilityRadioButton2[i].Size2D = new Size2D(48, 48);
    utilityRadioButton2[i].Position2D = new Position2D(1100, 300 + i * 100);
    root.Add(utilityRadioButton2[i]);
}
utilityRadioButton2[2].IsEnabled = false;
utilityRadioButton2[2].IsSelected = false;
utilityRadioButton2[3].IsEnabled = false;
utilityRadioButton2[3].IsSelected = true;
~~~

3. Create RadioButtonGroup

~~~{.cs}
RadioButtonGroup group = new RadioButtonGroup();
~~~

4. Add RadioButton to RadioButtonGroup

~~~{.cs}
for (int i = 0; i < num; i++)
{
    group.Add(utilityRadioButton2[i]);
}
~~~

RadioButton created by attributes:

![RadioButtonAttribute](../../assets/images/components/RadioButtonAttribute.PNG)
## Create with defined styles
You can define a style according to the UX, then you can use the this style to ceate a RadioButton.

1. User define a custom style as the whole view.

~~~{.cs}
internal class CustomRadioButtonStyle : StyleBase
{
    protected override Attributes GetAttributes()
    {
        SelectButtonAttributes attributes = new SelectButtonAttributes
        {
            CheckImageAttributes = new ImageAttributes
            {
                Size2D = new Size2D(48, 48),
                Position2D = new Position2D(0, 0),
                ResourceURL = new StringSelector
                {
                    Normal = "controller_btn_radio_off.png",
                    Selected = "controller_btn_radio_on.png",
                    Disabled = "controller_btn_radio_off.png",
                    DisabledSelected = "controller_btn_radio_on.png",
                },
                Opacity = new FloatSelector
                {
                    Normal = 1.0f,
                    Selected = 1.0f,
                    Disabled = 0.4f,
                    DisabledSelected = 0.4f
                },
            },
        };

        return attributes;
    }
}
~~~

2. Register your custom style.

~~~{.cs}
StyleManager.Instance.RegisterStyle("CustomRadioButton", null, typeof(YourNameSpace.CustomRadioButtonStyle));
~~~

3. Use your custom style to create RadioButton instance

~~~{.cs}
for(int i = 0; i < num; i++)
{
    radioButton[i] = new RadioButton("CustomRadioButton");
    radioButton[i].Size2D = new Size2D(48, 48);
    root.Add(radioButton[i]);
}
radioButton[2].IsEnabled = false;
radioButton[2].IsSelected = false;
radioButton[3].IsEnabled = false;
radioButton[3].IsSelected = true;
~~~

4. Create RadioButtonGroup

~~~{.cs}
RadioButtonGroup group = new RadioButtonGroup();
~~~

5. Add RadioButton to RadioButtonGroup

~~~{.cs}
for (int i = 0; i < num; i++)
{
    group.Add(radioButton[i]);
}
~~~

RadioButton created by style:

![RadioButtonStyle](../../assets/images/components/RadioButtonStyle.PNG)
## Responding to SelectedEvent
When user click RadioButton, the RadioButton instance receives a SelectedEvent.
You can declare the event handler as following:

~~~{.cs}
RadioButton radioButton = new RadioButton();
radioButton.SelectedEvent += OnSelected;
private void OnSelected(object sender, SelectButton.SelectEventArgs e)
{
    //Do something when user select the RadioButton
}
~~~
