<a name="0"></a>
# NUI Hello World Tutorial

The tutorial shows how to create and display "Hello World" using a text label.

[The NUI Overview](NUIoverview.md) describes NUI capabilities in detail.

## Explanation of tutorial

The following steps are required to display text:

+ Initialise the NUI library
+ Create a View - a text label showing text
+ Add the text label to the application main window

This tutorial demonstrates the triggering (_firing_) of the the _Initialized_ and _Touch_ window application events.

### Main method

The Main method consist of 3 steps:

1. Creation of application via the default constructor.

   ~~~{.cs}
   Example example = new Example();
   ~~~

   The application is derived from the Tizen NUI application class - _NUIApplication_.

   ~~~{.cs}
   class Example : NUIApplication
   ~~~

   _The NUIApplication class also includes constructors enabling application creation with stylesheets and window modes_.

2. Adding an initialization event handler to window application _Initialized_ event.

   This event handler will set up the scene, and is triggered once only.

   ~~~{.cs}
   example.Initialized += Initialize;
   ~~~

   _Adding the Initialize event handler with lambda expressions, is demonstrated at the end of the tutorial._

3. Start of application main loop

   The main loop must be started to run the application. This ensures that images are displayed,
   and events and signals are dispatched and captured.

   ~~~{.cs}
   example.Run(args);
   ~~~

   In this simple tutorial, the Main method resides within the class. For significant application development, the Main
   method should be placed in a seperate .cs file.

### The Initialization event handler - Initialize()

The initialization code contains the following simple steps:

1. Creation of the text label.

   ~~~{.cs}
   TextLabel text = new TextLabel("Hello NUI World");
   ~~~

2. Positioning the text in centre of application window. The _ParentOrigin_ defines a point
   within the parent views's area. Note: The text label will be at least the
   width of the screen if the text label size is not specified.

   ~~~{.cs}
   text.ParentOrigin = ParentOrigin.CenterLeft;
   ~~~

3. Alignment of text horizontally to the center of the available area.

   ~~~{.cs}
   text.HorizontalAlignment = HorizontalAlignment.Center;
   ~~~

4. Setting label background color to illustrate label width.

   ~~~{.cs}
   text.BackgroundColor = Color.Red;
   ~~~

5. Setting text size. The size of the font in points.

   ~~~{.cs}
   text.PointSize = 32.0f;
   ~~~

6. Adding _Touch_ event handler to the main application window. This event handler is invoked
   on any click in the application window.

   ~~~{.cs}
   Window window = Window.Instance;
   window.Touch += WindowTouched;
   ~~~

7. Adding text to default layer.

   ~~~{.cs}
   window.Add(text);
   ~~~

### The Touch event handler

The user can click anywhere in the application window to exit:

~~~{.cs}
private void WindowTouched(object sender, Window.TouchEventArgs e)
{
   example.Application.Quit();
}
~~~

### Build and Run the application

Use Visual Studio on a Windows platform.

Use Visual Studio Code on Linux.

## Full example code

~~~{.cs}
namespace HelloTest
{
    class Example : NUIApplication
    {
        private void Initialize(object src, EventArgs e)
        {
            // Add a simple text label to the main window
            TextLabel text = new TextLabel("Hello NUI World");
            text.ParentOrigin = ParentOrigin.CenterLeft;
            text.HorizontalAlignment = HorizontalAlignment.Center;
	    text.BackgroundColor = Color.Red;
            text.PointSize = 32.0f;

            // Connect the signal callback for a touched signal
            Window window = Window.Instance;
            window.Touch += WindowTouched;

            window.Add(text);
        }

        // Callback for main window touched signal handling
        private void WindowTouched(object sender, Window.TouchEventArgs e)
        {
	    example.Application.Quit();
        }

        static void Main(string[] args)
        {
            Example example = new Example();
	    example.Initialized += Initialize;
            example.Run(args);
        }
    }
}
~~~

## Example output

After running the example, the following output should appear:

<img src="./Images/hello-world.png" style="border: 5px solid black;">

### Alternate method of adding the Initialzed event, using lambda expression syntax

~~~{.cs}
static void Main(string[] args)
{
    Example example = new Example();
    example.Initialized += (object src, EventArgs args) =>
    { // Initialisation code
        .....
    };

    example.Run(args);
}
~~~

### More information on the Text label 

The [Text Label tutorial](text-label.md) describes the key properties of the text label in detail.

[Back to top](#0)

