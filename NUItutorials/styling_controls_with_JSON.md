<a name="top"></a>
# Tutorial on styling a control with JSON

NOTE  27 JUNE - THIS TUTORIAL WILL BE COMPLETED AT A LATER DATE (code still been developed for 'new' format for Visuals as described in this tutorial see AV)

This tutorial shows how to style a toolkit control with JSON.

The tutorial uses a PushButton as an example control.

In this tutorial:

[Visuals](#visuals)<br>
[Styling a new View](#newview)<br>
[Styling for state](#state)<br>
[Building up a style sheet, state by state](#build)<br>
[Transitions](#transitions)<br>
[Example style sheet](#example)<br>

<a name="overview"></a>
### Visuals

Visuals are the main building block of controls. A control is built from visuals with properties set as required.

The following Visual types are available:

| Type          | example                                 |                  
| ------------- | ------------------------------ |
| Border        | ![](./Images/border-visual.png)    |
| Color         | ![](./Images/color-visual.png)  |
| Gradient      | ![](./Images/linear-gradient-visual.png |
| Image         | ![](./Images/gallery-medium-50.jpg ) |
| Mesh          | ![](./Images/mesh-visual.png) |
| Primitive     | ![](./Images/cube.png)  |
| Text          | **Hello there** |

The [Visuals tutorial](visuals.md) describes how to create, register and use visuals, and also lists all properties associated
with each visual type.

<a name="newview"></a>
### Styling a new View

Styling is inherited, so styling a parent will automatically effect its child unless overridden.<
View, and PushButton offer the following Style properties

Useful View properties for styling :

|  Name         | Description |   |
| ------------  |------------ | ------------ | ------------ | ------------ | ------------ |
|  heightResizePolicy | string   | see [Size Negotiation](creating-custom-view-controls.md#sizenegotiation) |
|  widthResizePolicy  | string   | see [Size Negotiation](creating-custom-view-controls.md#sizenegotiation) |
|  sizeModeFactor | vector3   | Gets/Sets the relative to parent size factor of the view.           |
|  minimumSize  | Size2D  | Gets/Sets the minimum size an view can be assigned in size negotiation  |
|  maximumSize  | Size2D  | Gets/Sets the maximum size an view can be assigned in size negotiation. |

Note : `sizeModeFactor` is only used when `ResizePolicyType` is set to either: ResizePolicyType.SizeRelativeToParent or ResizePolicyType.SizeFixedOffsetFromParent.<br>
This view's size is set to the view's size multiplied by or added to this factor, depending on ResizePolicyType.

[Back to top](#top)

<a name="state"></a>
### Styling for State

Control has 3 states: NORMAL, FOCUSED and DISABLED. Each state should have the required visuals.

A different backgroundVisual can be supplied for NORMAL, FOCUSED and DISABLED if required.

Button has sub states: SELECTED and UNSELECTED

Each state can have its own set of visuals or a visual can be common between states. NORMAL, FOCUSED and DISABLED states will each have these sub-states.

You may want a different backgroundVisual for SELECTED and UNSELECTED state.

_"inherit"_ Push Button will inherit any styles defined for Button <br />
_"visuals"_ Visuals for specific states can be put here ( see next example ) <br />
_"states"_ Visuals for specific states can be put here ( see next example ) <br />

```json
"styles":
{
  "PushButton":
  {
    "inherit":["Button"],
    "visuals":
    {
      "iconVisual": { "visualType":"IMAGE", "url":"icon1.png" },
      "labelVisual": { "visualType":"TEXT", "text":"OK", "fontWeight":"bold" }
    },
    "states":
    {

    }
  }
}
```

[Back to top](#top)

<a name="buildforstate"></a>
### Building up a style sheet, state by state

1) All controls have have below states:

```json
  "states":
  {
    "NORMAL":
    {
    },
    "DISABLED":
    {
    },
    "FOCUSED":
    {
    },
  }
```
The states have been defined but no visuals provided.


2) Below the button offers the sub states UNSELECTED and SELECTED but still not visuals provided.

```json
  "states":
  {
    "NORMAL":
    {
      "states":
      {
        "UNSELECTED":
        {

        },
        "SELECTED":
        {

        }  
      },
    "DISABLED":
    {
      "states":
      {
        "UNSELECTED":
        {

        },
        "SELECTED":
        {

        }
      }
    },
    ...
  }
```
3) Now the background visual defined for each sub-state, the same can be done for FOCUSED and DISABLED.

```json
  "states":
  {
    "NORMAL":
    {
      "states":
      {
        "UNSELECTED":
        {
          "visuals":
          {
            "backgroundVisual":
             {
              "visualType":"IMAGE",
              "url":"backgroundUnSelected.png"
             }
          }
        },
        "SELECTED":
        {
          "visuals":
          {
            "backgroundVisual":
             {
              "visualType":"IMAGE",
              "url":"backgroundSelected.png"
             }
          }
        }
      }
    },
```
[Back to top](#top)

<a name="transitions"></a>
### Transitions

The control (Button) will change between states from user interaction. <br />

All controls can move between the states NORMAL, FOCUSED and DISABLED. <br />

Whilst in those states a Button has sub-states SELECTED and UNSELECTED. <br />

To move between states and sub-states transition animations can be defined. <br />

Each state and sub-state can have an "entry" and "exit" transition. <br />

To make defining common transitions easier an effect can be used with a "from" and "to" state. <br />

One such effect is CROSSFADE which animates the opacity of visuals fading in and out to give a nice transition.
Initially only CROSSFADE will be available, but in time further effects could be provided.

This transition can be placed in the state section like NORMAL. It will cross-fade between unselected and selected visuals. <br />

Example using CROSSFADE effect 
```json
"transitions":
[
  {
     "from":"UNSELECTED",
     "to":"SELECTED",
     "visualName":"*",
     "effect":"CROSSFADE",
     "animator":
     {
       "alphaFunction":"EASE_OUT",
       "duration":"0.2,
       "delay":0
     }
  }
]
```
Example using entry and exit transition for UNSELECTED
```json
"states":
  {
    "NORMAL":
    {
      "states":
      {
        "UNSELECTED":
        {
          "visuals":
          {
            "backgroundVisual":
             {
               "visualType":"IMAGE",
               "url":"backgroundUnSelected.png"
             }
          },
          "entryTransition":
          {
            "target":"backgroundVisual",
            "property":"mixColor",
            "targetValue":[1,1,1,1],
            "animator":
            {
              "alphaFunction":"LINEAR",
              "duration":0.3,
              "delay":0.0
            }
         },
         "exitTransition":
         {
            "target":"backgroundVisual",
            "property":"mixColor",
            "targetValue":[1,1,1,0.0],
            "animator":
            {
              "alphaFunction":"LINEAR",
              "duration":0.3,
              "delay":0.0
            }
         }
       }
     }
   }
  }
]
```

[Back to top](#top)

<a name="example"></a>
### Example Style sheet
Example button stylesheet  ( Link to most update version )
```json
{
  "styles":
  {
    "PushButton":
    {
      "inherit":["Button"],
      "visuals":
      {
        "iconVisual":
        {
          "visualType":"IMAGE",
          "url":"icon1.png"
        },
        "label":
        {
          "visualType":"TEXT",
          "text":"OK",
          "fontWeight":"bold"
        }
      },
      "states":
      {
        "NORMAL":
        {
          "states":
          {
            "UNSELECTED":
            {
              "visuals":
              {
                "backgroundVisual":
                {
                  "visualType":"IMAGE",
                  "url":"backgroundSelected.png"
                }
              }
            },
            "SELECTED":
            {
              "visuals":
              {
                "backgroundVisual":
                {
                  "visualType":"IMAGE",
                  "url":"backgroundUnselected.png"
                }
              }
            }
          },
          "transitions":
          [
            {
              "from":"UNSELECTED", 
              "to":"SELECTED",
              "visualName":"*",
              "effect":"CROSSFADE",
              "animator":
              {
                "alphaFunction":"EASE_OUT",
                "duration":0.2,
                "delay":0
              }
            }
          ]
        },
        "FOCUSED":
        {
          "visuals":
          {
            "labelVisual":
            {
              "visualType":"TEXT",
              "text":"OK",
              "fontWeight":"bold"
            }
          },
          "states":
          {
            "SELECTED":
            {
            },
            "UNSELECTED":
            {
            }
          }
        },
        "DISABLED":
        {
          "states":
          {
            "SELECTED":
            {
              "visuals":
              {
                "backgroundVisual":
                {
                  "visualType": "IMAGE",
                  "url": "{DALI_IMAGE_DIR}button-down-disabled.9.png"
                }
              }
            },
            "UNSELECTED":
            {
              "visuals":
              {
                "backgroundVisual":
                {
                  "visualType": "IMAGE",
                  "url": "{DALI_IMAGE_DIR}button-disabled.9.png"
                }
              }
            }
          },
          "transitions":
          {
            "visualName":"*",
            "effect":"CROSSFADE",
            "animator":
            {
              "alphaFunction":"EASE_IN_OUT",
              "duration":0.3
            }
          }
        }
      },
      "autoRepeating":false,
      "togglable":false,
      "labelPadding":[ 12.0, 12.0, 12.0, 12.0 ],

      "transitions":
      [
        {
          "from":"NORMAL", 
          "to":"DISABLED",
          "visualName":"*",
          "effect":"CROSSFADE",
          "animator":
          {
            "alphaFunction":"EASE_OUT",
            "duration":0.2,
            "delay":0
          }
        }
      ]
    }
  }
}
```

[Back to top](#top)
