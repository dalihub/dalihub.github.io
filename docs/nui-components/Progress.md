[HomePage](./Guide.md)<br>

# Progress
It's used to show the ongoing status with a long narrow bar.

![Progress](../../assets/images/components/progress.png)

## Overview
Progress is a kind of common component and  used to show the ongoing status with a long narrow bar. This is useful in a long list of items or to show the processing time.

- Use progress to show the number of items in progress or the processing time.
- Use progress to show the progress rate, depending on the screen layout.

## Create with property
1. Create Progress by default constructor

~~~{.cs}
utilityBasicProgress = new Progress();
~~~

2. Set progress property

~~~{.cs}
utilityBasicProgress.MaxValue = 100;
utilityBasicProgress.MinValue = 0;
utilityBasicProgress.CurrentValue = 45;
utilityBasicProgress.TrackColor = Color.Green;
utilityBasicProgress.ProgressColor = Color.Black;
~~~

Progress created by property:

![Progress](../../assets/images/components/progress.gif)

## Create with attributes
1. Create progress attributes

~~~{.cs}
ProgressAttributes progressAttributes = new ProgressAttributes
{
    TrackImageAttributes = new ImageAttributes
    {
        BackgroundColor = new ColorSelector
        {
            All = Color.Cyan,
        }
    },
    ProgressImageAttributes = new ImageAttributes
    {
        BackgroundColor = new ColorSelector
        {
            All = Color.Black,
        }
    },
};

~~~

2. Use the attributes to create a progress and add it to parent

~~~{.cs}
utilityBasicProgress = new Progress(progressAttributes);
utilityBasicProgress.Position2D = new Position2D(380, 350);
utilityBasicProgress.Size2D = new Size2D(140, 4);
utilityBasicProgress.MaxValue = 100;
utilityBasicProgress.MinValue = 0;
utilityBasicProgress.CurrentValue = 30;
root.Add(utilityBasicProgress);
~~~

Progress created by property:

![Progress](../../assets/images/components/progress2.gif)

## Create with defined styles
You can define a style according to the UX, then you can use the this style to ceate a progress.

1. User define a custom style as the whole view.

~~~{.cs}
internal class CustomProgressStyle : StyleBase
{
    protected override Attributes GetAttributes()
    {
        ProgressAttributes attributes = new ProgressAttributes
        {
            TrackImageAttributes = new ImageAttributes
            {
                BackgroundColor = new ColorSelector
                {
                    All = new Color(0.0f, 0.0f, 0.0f, 0.1f),
                }
            },
            ProgressImageAttributes = new ImageAttributes
            {
                BackgroundColor = new ColorSelector
                {
                    All = Utility.Hex2Color(Constants.APP_COLOR_UTILITY, 1)
                }
            },
        };
        return attributes;
    }
}
~~~

2. Register your custom style.

~~~{.cs}
StyleManager.Instance.RegisterStyle("CustomProgress", null, typeof(YourNameSpace.CustomProgressStyle));
~~~

3. Use your custom style to create a progress instance

~~~{.cs}
utilityBasicProgress = new Progress("CustomProgress");
utilityBasicProgress.Position2D = new Position2D(380, 350);
utilityBasicProgress.Size2D = new Size2D(140, 4);
root.Add(utilityBasicProgress);
~~~
