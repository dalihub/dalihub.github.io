[HomePage](./Guide.md)<br>

# StyleManager
This tutorial describes how to regiester the different style and theme in CommonUI.

## Overview
StyleManager allows to to define differnt theme for a UIComponent. And you can define different styles in a theme for a UIComponent.

## Example of defining and registering different themes and styles
We take CommonUI.Button as an example.

1. Firstly, we define two themes("Utility" and "Family") and define two styles for each theme.

~~~{.cs}
internal class TextButtonStyle : StyleBase
{
    public TextButtonStyle()
    {

    }
    protected override Attributes GetAttributes()
    {
        ButtonAttributes attributes = new ButtonAttributes
        {
            IsSelectable = true,
            BackgroundImageAttributes = new ImageAttributes
            {
                ResourceURL = new StringSelector { All = CommonResource.GetResourcePath() + "3. Button/rectangle_btn_normal.png" },
                Border = new RectangleSelector { All = new Rectangle(5, 5, 5, 5) }
            },

            ShadowImageAttributes = new ImageAttributes
            {
                ResourceURL = new StringSelector { All = CommonResource.GetResourcePath() + "3. Button/rectangle_btn_shadow.png" },
                Border = new RectangleSelector { All = new Rectangle(5, 5, 5, 5) }
            },

            OverlayImageAttributes = new ImageAttributes
            {
                ResourceURL = new StringSelector { Pressed = CommonResource.GetResourcePath() + "3. Button/rectangle_btn_press_overlay.png", Other = "" },
                Border = new RectangleSelector { All = new Rectangle(5, 5, 5, 5) },
            },

            TextAttributes = new TextAttributes
            {
                PointSize = new FloatSelector { All = 20 },
                HorizontalAlignment = HorizontalAlignment.Center,
                VerticalAlignment = VerticalAlignment.Center,
                WidthResizePolicy = ResizePolicyType.FillToParent,
                HeightResizePolicy = ResizePolicyType.FillToParent,

                TextColor = new ColorSelector
                {
                    Normal = new Color(0, 0, 0, 1),
                    Pressed = new Color(0, 0, 0, 0.7f),
                    Selected = Utility.Hex2Color(0x0ea1e6, 1),
                    Disabled = new Color(0, 0, 0, 0.4f),
                },
            }
        };
        return attributes;
    }
}

internal class FamilyBasicButtonStyle : TextButtonStyle
{
    protected override Attributes GetAttributes()
    {
        if (Content != null)
        {
            return (Content as Attributes).Clone();
        }
        ButtonAttributes attributes = base.GetAttributes() as ButtonAttributes;
        attributes.TextAttributes.TextColor.Selected = Utility.Hex2Color(0x24c447, 1);
        return attributes;
    }
}

internal class FamilyServiceButtonStyle : TextButtonStyle
{
    protected override Attributes GetAttributes()
    {
        if (Content != null)
        {
            return (Content as Attributes).Clone();
        }
        ButtonAttributes attributes = base.GetAttributes() as ButtonAttributes;
        attributes.IsSelectable = false;
        attributes.BackgroundImageAttributes.ResourceURL.All = CommonResource.GetResourcePath() + "3. Button/[Button] App Primary Color/rectangle_point_btn_normal_24c447.png";
        attributes.TextAttributes.TextColor = new ColorSelector
        {
            Normal = new Color(1, 1, 1, 1),
            Pressed = new Color(1, 1, 1, 0.7f),
            Disabled = new Color(1, 1, 1, 0.4f),
        };
        return attributes;
    }
}

internal class UtilityBasicButtonStyle : TextButtonStyle
{
    protected override Attributes GetAttributes()
    {
        if (Content != null)
        {
            return (Content as Attributes).Clone();
        }
        return base.GetAttributes();
    }
}

internal class UtilityServiceButtonStyle : TextButtonStyle
{
    protected override Attributes GetAttributes()
    {
        if (Content != null)
        {
            return (Content as Attributes).Clone();
        }
        ButtonAttributes attributes = base.GetAttributes() as ButtonAttributes;
        attributes.IsSelectable = false;
        attributes.BackgroundImageAttributes.ResourceURL.All = CommonResource.GetResourcePath() + "3. Button/rectangle_point_btn_normal.png";
        attributes.TextAttributes.TextColor = new ColorSelector
        {
            Normal = new Color(1, 1, 1, 1),
            Pressed = new Color(1, 1, 1, 0.7f),
            Disabled = new Color(1, 1, 1, 0.4f),
        };
        return attributes;
    }
}
~~~

2. Register these themes and styles.
~~~{.cs}
CommonUI.StyleManager.Instance.RegisterStyle("BasicButton", "Family", typeof(FamilyBasicButtonStyle));
CommonUI.StyleManager.Instance.RegisterStyle("BasicButton", "Utility", typeof(UtilityBasicButtonStyle), true);

CommonUI.StyleManager.Instance.RegisterStyle("ServiceButton", "Family", typeof(FamilyServiceButtonStyle));
CommonUI.StyleManager.Instance.RegisterStyle("ServiceButton", "Utility", typeof(UtilityServiceButtonStyle), true);
~~~

You can define a style as default style, then the control will use the default style if you didn't define a style for some themes.
For example, if currently the theme is "Food", and you create a "BasicButton", then it will create a "UtilityBasicButton" for you, because you take the UtilityBasicButtonStyle as default one.

3. Define the theme

~~~{.cs}
CommonUI.StyleManager.Instance.Theme = "Utility";
~~~

4. Create buttons with styles
~~~{.cs}
basicButton = new Button("BasicButton");
basicButton.Size2D = new Size2D(300, 80);
basicButton.Position2D = new Position2D(200, 300);
basicButton.PointSize = 20;
basicButton.Text = "BasicButton";
root.Add(basicButton);

serviceButton = new Button("ServiceButton");
serviceButton.Size2D = new Size2D(300, 80);
serviceButton.Position2D = new Position2D(600, 300);
serviceButton.PointSize = 20;
serviceButton.Text = "ServiceButton";
root.Add(serviceButton);
~~~

![UtilityTheme](../../assets/images/components/stylemanager_utility.PNG)  
In the above case, "UtilityBasicButtonStyle" is used for "BasicButton" and "UtilityServiceButtonStyle" is used for "ServiceButton".  

5. Change the theme

~~~{.cs}
CommonUI.StyleManager.Instance.Theme = "Family";
~~~
The styles of the buttons will be changed to "FamilyBasicButtonStyle" and "FamilyServiceButtonStyle".  
![FamilyTheme](../../assets/images/components/stylemanager_family.PNG)
