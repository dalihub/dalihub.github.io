[HomePage](./Guide.md)<br>

# Loading
This tutorial describes how to create and use loading.

![Loading](../../assets/images/components/loading.png)

## Overview
Loading is a kind of common component and it's used to indicate informs users of the ongoing operation.

- Loading indicators display the loading status of the content or screen.
- Use this component if it is not possible to measure the time or progress status.
- If users cannot interact with any other components or content on the current screen while it is loading, dim the UI or content and display the loading indicator in the center of the screen.
- If the content cannot be displayed or the completion time is unpredictable while it is loading, display the loading indicator over the whole content area.
- While loading an app, display the loading indicator with the app logo.

## Create with property
1. Create Loading by default constructor

~~~{.cs}
utilityBasicLoading = new Loading();
~~~

2. Set loading property

~~~{.cs}
string[] imageArray = new string[36];
for (int i=0; i<36; i++)
{
    if (i < 10)
    {
        imageArray[i] = "Loading Sequence_Native/loading_0" + i + ".png";
    }
    else
    {
        imageArray[i] = "Loading Sequence_Native/loading_" + i + ".png";
    }
}
utilityBasicLoading.ImageArray = imageArray;
~~~


Loading created by property:

![Loading](../../assets/images/components/loading.gif)

## Create with attributes
1. Create loading attributes

~~~{.cs}
string[] imageArray = new string[36];
for (int i=0; i<36; i++)
{
    if (i < 10)
    {
        imageArray[i] = "Loading Sequence_Native/loading_0" + i + ".png";
    }
    else
    {
        imageArray[i] = "Loading Sequence_Native/loading_" + i + ".png";
    }
}
LoadingAttributes loadingAttributes = new LoadingAttributes
{
    ImageArray = imageArray
};
~~~

2. Use the attributes to create a loading and add it to parent

~~~{.cs}
utilityBasicLoading = new Loading(loadingAttributes);
utilityBasicLoading.Position2D = new Position2D(100, 350);
utilityBasicLoading.Size2D = new Size2D(100, 100);
root.Add(utilityBasicLoading);
~~~

Loading created by attributes:

![Loading](../../assets/images/components/loading.gif)

## Create with defined styles
You can define a style according to the UX, then you can use the this style to ceate a loading.

1. User define a custom style as the whole view.

~~~{.cs}
internal class CustomLoadingStyle : StyleBase
{
    protected override Attributes GetAttributes()
    {
        string[] imageArray = new string[36];
        for (int i = 0; i < 36; i++)
        {
            if (i < 10)
            {
                imageArray[i] = "9. Controller/Loading Sequence_Native/loading_0" + i + ".png";
            }
            else
            {
                imageArray[i] = "9. Controller/Loading Sequence_Native/loading_" + i + ".png";
            }
        }
        LoadingAttributes attributes = new LoadingAttributes { ImageArray = imageArray };
        return attributes;
    }
}
~~~

2. Register your custom style.

~~~{.cs}
StyleManager.Instance.RegisterStyle("CustomLoading", null, typeof(YourNameSpace.CustomLoadingStyle));
~~~

3. Use your custom style to create a loading instance

~~~{.cs}
utilityBasicLoading = new Loading("CustomLoading");
utilityBasicLoading.Position2D = new Position2D(100, 350);
utilityBasicLoading.Size2D = new Size2D(100, 100);
root.Add(utilityBasicLoading);
~~~
