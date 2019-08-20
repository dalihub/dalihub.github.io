[HomePage](./Guide.md)<br>

# CheckBox
This tutorial describes how to create and use CheckBox.

## Overview
Popup is one kind of common component, it is inherited from SelectButton.
It can be used as selector and add into group for multiple-choice.

## Create with property
1. Create CheckBox by default constructor

~~~{.cs}
CheckBox[] utilityCheckBox = new CheckBox[4];
for (int i = 0; i < num; i++)
{
    utilityCheckBox[i] = new CheckBox();
}
~~~

2. Set CheckBox property

~~~{.cs}
int num = 4;
for (int i = 0; i < num; i++)
{
    utilityCheckBox[i].Size2D = new Size2D(150, 48);
    utilityCheckBox[i].Position2D = new Position2D(300, 300 + i * 100);
    utilityCheckBox[i].CheckImageSize2D = new Size2D(48, 48);
    utilityCheckBox[i].CheckImagePaddingLeft = 0;
    utilityCheckBox[i].CheckImagePaddingRight = 0;
    utilityCheckBox[i].CheckImagePaddingTop = 0;
    utilityCheckBox[i].CheckImagePaddingBottom = 0;
    utilityCheckBox[i].CheckImageOpacitySelector = new FloatSelector
    {
        Normal = 1.0f,
        Selected = 1.0f,
        Disabled = 0.4f,
        DisabledSelected = 0.4f
    };
    utilityCheckBox[i].CheckBackgroundImageURLSelector = new StringSelector
    {
        Normal = "controller_btn_check_off.png",
        Selected = "controller_btn_check_on.png",
        Disabled = "controller_btn_check_off.png",
        DisabledSelected = "controller_btn_check_on.png",
    };
    utilityCheckBox[i].CheckBackgroundImageOpacitySelector = new FloatSelector
    {
        Normal = 1.0f,
        Selected = 1.0f,
        Disabled = 0.4f,
        DisabledSelected = 0.4f
    };
    utilityCheckBox[i].CheckImageURLSelector = new StringSelector
    {
        Normal = "",
        Selected = "controller_btn_check.png",
        Disabled = "",
        DisabledSelected = "controller_btn_check.png",
    };
    utilityCheckBox[i].CheckShadowImageOpacitySelector = new FloatSelector
    {
        Normal = 1.0f,
        Selected = 1.0f,
        Disabled = 0.4f,
        DisabledSelected = 0.4f
    };
    utilityCheckBox[i].CheckShadowImageURLSelector = new StringSelector
    {
        Normal = "",
        Selected = "controller_btn_check_shadow.png",
        Disabled = "",
        DisabledSelected = "controller_btn_check_shadow.png",
    };
    
    root.Add(utilityCheckBox[i])
}

utilityCheckBox[2].IsEnabled = false;
utilityCheckBox[2].IsSelected = false;
utilityCheckBox[3].IsEnabled = false;
utilityCheckBox[3].IsSelected = true;
~~~

3. Create CheckBoxGroup

~~~{.cs}
CheckBoxGroup group = new CheckBoxGroup();
~~~

4. Add CheckBox to CheckBoxGroup

~~~{.cs}
for (int i = 0; i < num; i++)
{
    group.Add(utilityCheckBox[i]);
}
~~~

CheckBox created by property:

![CheckBoxProperty](../../assets/images/components/CheckBoxProperty.PNG)
## Create with attributes
1. Create SelectButton attributes

~~~{.cs}
SelectButtonAttributes familyAttrs = new SelectButtonAttributes
{
    CheckBackgroundImageAttributes = new ImageAttributes
    {
        Size2D = new Size2D(48, 48),
        ResourceURL = new StringSelector
        {
            Normal = "controller_btn_check_off.png",
            Selected = "controller_btn_check_on.png",
            Disabled = "controller_btn_check_off.png",
            DisabledSelected = "controller_btn_check_on.png",
        },
        Opacity = new FloatSelector
        {
            Normal = 1.0f,
            Selected = 1.0f,
            Disabled = 0.4f,
            DisabledSelected = 0.4f
        },
    },               
    CheckImageAttributes = new ImageAttributes
    {
        Size2D = new Size2D(48, 48),
        ResourceURL = new StringSelector
        {
            Normal = "",
            Selected = "controller_btn_check.png",
            Disabled = "",
            DisabledSelected = "controller_btn_check.png",
        },
        Opacity = new FloatSelector
        {
            Normal = 1.0f,
            Selected = 1.0f,
            Disabled = 0.4f,
            DisabledSelected = 0.4f
        },
    },
    CheckShadowImageAttributes = new ImageAttributes
    {
        Size2D = new Size2D(48, 48),
        ResourceURL = new StringSelector
        {
            Normal = "",
            Selected = "controller_btn_check_shadow.png",
            Disabled = "",
            DisabledSelected = "controller_btn_check_shadow.png",
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

2. Use the attributes to create a CheckBox and add CheckBox to parent
~~~{.cs}
int num = 4;
for(int i = 0; i < num; i++)
{
    familyCheckBox[i] = new CheckBox(familyAttrs);
    familyCheckBox[i].Size2D = new Size2D(48, 48);
    familyCheckBox[i].Position2D = new Position2D(1100, 300 + i * 100);
    root.Add(familyCheckBox[i]);
}

familyCheckBox[2].IsEnabled = false;
familyCheckBox[2].IsSelected = false;
familyCheckBox[3].IsEnabled = false;
familyCheckBox[3].IsSelected = true;
~~~

3. Create CheckBoxGroup

~~~{.cs}
CheckBoxGroup group = new CheckBoxGroup();
~~~

4. Add CheckBox to CheckBoxGroup

~~~{.cs}
for (int i = 0; i < num; i++)
{
    group.Add(familyCheckBox[i]);
}
~~~

CheckBox created by attributes:

![CheckBoxAttribute](../../assets/images/components/CheckBoxAttribute.PNG)
## Create with defined styles
You can define a style according to the UX, then you can use the this style to ceate a CheckBox.

1. User define a custom style as the whole view.

~~~{.cs}
internal class CustomCheckBoxStyle : StyleBase
{
    protected override Attributes GetAttributes()
    {
        SelectButtonAttributes attributes = new SelectButtonAttributes
        {
            IsSelectable = true,
            CheckBackgroundImageAttributes = new ImageAttributes
            {
                Size2D = new Size2D(48, 48),
                Position2D = new Position2D(0, 0),
                ResourceURL = new StringSelector
                {
                    Normal = "controller_btn_check_off.png",
                    Selected = "controller_btn_check_on.png",
                    Disabled = "controller_btn_check_off.png",
                    DisabledSelected = "controller_btn_check_on.png",
                },
                Opacity = new FloatSelector
                {
                    Normal = 1.0f,
                    Selected = 1.0f,
                    Disabled = 0.4f,
                    DisabledSelected = 0.4f
                },
            },
            CheckImageAttributes = new ImageAttributes
            {
                Size2D = new Size2D(48, 48),
                Position2D = new Position2D(0, 0),
                ResourceURL = new StringSelector
                {
                    Normal = "",
                    Selected = "controller_btn_check.png",
                    Disabled = "",
                    DisabledSelected = "controller_btn_check.png",
                },
                Opacity = new FloatSelector
                {
                    Normal = 1.0f,
                    Selected = 1.0f,
                    Disabled = 0.4f,
                    DisabledSelected = 0.4f
                },
            },
            CheckShadowImageAttributes = new ImageAttributes
            {
                Size2D = new Size2D(48, 48),
                Position2D = new Position2D(0, 0),
                ResourceURL = new StringSelector
                {
                    Normal = "",
                    Selected = "controller_btn_check_shadow.png",
                    Disabled = "",
                    DisabledSelected = "controller_btn_check_shadow.png",
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
StyleManager.Instance.RegisterStyle("CustomCheckBox", null, typeof(YourNameSpace.CustomCheckBoxStyle));
~~~

3. Use your custom style to create CheckBox instance

~~~{.cs}
int num = 4;
for(int i = 0; i < num; i++)
{
    checkBox[i] = new CheckBox("CustomCheckBox");
    checkBox[i].Size2D = new Size2D(48, 48);
    root.Add(checkBox[i]);
}
checkBox[2].IsEnabled = false;
checkBox[2].IsSelected = false;
checkBox[3].IsEnabled = false;
checkBox[3].IsSelected = true;
~~~

4. Create CheckBoxGroup

~~~{.cs}
CheckBoxGroup group = new CheckBoxGroup();
~~~

5. Add CheckBox to CheckBoxGroup

~~~{.cs}
for (int i = 0; i < num; i++)
{
    group.Add(checkBox[i]);
}
~~~

CheckBox created by style:

![CheckBoxStyle](../../assets/images/components/CheckBoxStyle.PNG)
## Responding to SelectedEvent
When user click CheckBox, the CheckBox instance receives a SelectedEvent.
You can declare the event handler as following:

~~~{.cs}
CheckBox checkBox = new CheckBox();
checkBox.SelectedEvent += OnSelected;
private void OnSelected(object sender, SelectButton.SelectEventArgs e)
{
    //Do something when user select the CheckBox
}
~~~
