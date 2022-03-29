[HomePage](./Guide.md)<br>

# ScrollBar
This tutorial describes how to create and use the scroll bar.

## Overview
A scroll bar allows users to recognize the direction and the range of lists/content.

- A scroll bar is shown on the screen only when all the content cannot be displayed on the same page.
- It is displayed on the right or at the bottom of the scrolling area.
- The method of displaying a scroll bar can vary depending on the display area (a list or a text area).
- When entering the screen consists of list, the vertical or horizontal scroll bar is displayed that has same direction with main stream of the screen.
- On the lists/contents, the scroll bar is shown when the focus moves to the same direction of contents extension.

## Create with properties

~~~{.cs}
scrollBar = new ScrollBar();
scrollBar.Position2D = new Position2D(50, 300);
scrollBar.Size2D = new Size2D(300, 4);
scrollBar.TrackColor = Color.Green;           
scrollBar.MaxValue = (int)scrollBar.SizeWidth / 10;
scrollBar.MinValue = 0;
scrollBar.ThumbSize = new Size2D(30, 4);
scrollBar.CurrentValue = 0;
scrollBar.ThumbColor = Color.Black;
root.Add(scrollBar);
~~~
![CreateWithProperties](../../assets/images/components/scrollbar_properties.PNG)
## Create with custom attributes
1. Firstly, we create a scroll bar attributes as the whole view to set the properties of the track and the thumb.

~~~{.cs}
ScrollBarAttributes attr = new ScrollBarAttributes
{
    TrackImageAttributes = new ImageAttributes
    {
        BackgroundColor = new ColorSelector
        {
            All = new Color(0.43f, 0.43f, 0.43f, 0.1f),
        }
    },
    ThumbImageAttributes = new ImageAttributes
    {
        BackgroundColor = new ColorSelector
        {
            All = new Color(0.0f, 0.0f, 0.0f, 0.2f),
        }
    },

};
~~~

2. Use the attributes to create a scroll bar and add it to its parent.

~~~{.cs}
scrollBar = new ScrollBar(attr);
scrollBar.Position2D = new Position2D(500, 300);
scrollBar.Size2D = new Size2D(300, 4);
scrollBar.MaxValue = (int)scrollBar.SizeWidth / 10;
scrollBar.MinValue = 0;
scrollBar.ThumbSize = new Size2D(30, 4);
scrollBar.CurrentValue = 0;
root.Add(scrollBar);
~~~
![CreateWithAttributes](../../assets/images/components/scrollbar_attr.PNG)

## Create with defined styles
You can define a style according to the UX, then you can use the this style to ceate a scrollBar.

1. Firstly, we define a custome style as the whole view.
~~~{.cs}
internal class CustomeScrollBarStyle : StyleBase
{
    protected override Attributes GetAttributes()
    {
        ScrollBarAttributes attributes = new ScrollBarAttributes
        {
            TrackImageAttributes = new ImageAttributes
            {
                BackgroundColor = new ColorSelector
                {
                    All = new Color(0.43f, 0.43f, 0.43f, 0.6f),
                }
            },
            ThumbImageAttributes = new ImageAttributes
            {
                BackgroundColor = new ColorSelector
                {
                    All = new Color(0.0f, 0.0f, 0.0f, 0.2f)
                }
            },
        };
        return attributes;
    }
}
~~~

2. Register your custome style.

~~~{.cs}
StyleManager.Instance.RegisterStyle("CustomeScrollbar", null, typeof(YourNameSpace.CustomeScrollBarStyle));
~~~

3. Use your custome style to create a scroll bar instance
~~~{.cs}
scrollBar = new ScrollBar("CustomeScrollbar");
scrollBar.Position2D = new Position2D(100, 200);
scrollBar.Size2D = new Size2D(300, 4);
scrollBar.MaxValue = (int)scrollBar.SizeWidth / 10;
scrollBar.MinValue = 0;
scrollBar.ThumbSize = new Size2D(30, 4);
scrollBar.CurrentValue = 0;
scrollBar.Direction = ScrollBar.DirectionType.Horizontal;
root.Add(scrollBar);
~~~
![CreateWithStyle](../../assets/images/components/scrollbar_style.PNG)


## ScrollBar Properties

The properties available in the *ScrollBar* class are:

| Property  | Type | Description
| ------------ | ------------ | ------------ |
| CurrentValue | int | Get/set the current value of the ScrollBar |
| MinValue | int | Get/set the min value of the ScrollBar |
| MaxValue | int | Get/set the max value of the ScrollBar |
| ThumbColor | Color | Get/set the color of the thumb image object |
| TrackColor | Color | Get/set the color of the track object |
| TrackImageURL | string | Get/set the image URL of the track image object |
| Direction | DirectionType | Get/set the direction of the ScrollBar |
| Duration | uint | Get/set the animation duration |
| ThumbSize | Size2D | Get/set the size of the thumb object |
