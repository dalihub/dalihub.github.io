---
layout: default
title: Animation Tutorial
---
<a name="0"></a>
# Animation Tutorial

This tutorial describes the Dali Animation framework

In this tutorial the following subjects are covered:

[Setting up an Animation](#1)<br>
[Animation Notifications](#2)<br>
[Key Frames](#3)<br>

## Overview

You can use animations to allow your objects to move around and change their properties for a specified duration.

DALi provides a rich and easy to use animation framework which allows you to create visually rich applications.

The Dali::Animation class can be used to animate the animatable properties of any number of objects.

<a name="1"></a>
## Setting up an Animation

Below code creates an Animation with a duration of 3 seconds.

~~~{.cpp}
Animation animation = Animation::New( 3.0f );
~~~

Once created the following properties can be used to set up the animation.

### By, to and between

There are 3 animation functions that determine what should be animated.

| Function | Description |
|--- | --- |
| AnimateTo | Animates a given property to the given value |
| AnimateBy | Animates a given property by a given amount |
| AnimateBetween | Animates a given property from a given value to a given value |

Below code animates the actor1 position to 10.0f, 50.0f, 0.0f

~~~{.cpp}
animation.AnimateTo( Property( actor1, Dali::Actor::Property::POSITION ), Vector3( 10.0f, 50.0f, 0.0f ) );
~~~

Multiple functions can be attached to an animation.  All with different targets (actors) and properties.

### Play and play range

Once the animation has been created and set up to Animate then it can be played.

~~~{.cpp}
animation.Play();
~~~

This will play all functions attached to that animation.
The animation will play and execution of the event thread is not blocked (user interation continues).

### Looping

The animation can be set to loop forever.
~~~{.cpp}
animation.SetLooping( true );
~~~

Or set to loop a number of times.  
~~~{.cpp}
animation.SetLoopCount( 5 );
~~~

Below will loop forever ( as SetLooping(true) )
~~~{.cpp}
animation.SetLoopCount( 0 );
~~~

The direction of looping can also be set with the following API.

Animation::SetLoopingMode

### End action

The following End Actions are available.
They determine what the animated Property value should be when the animation ends.

| EndAction | Description |
| --- | --- |
|   Bake | current value of the animation becomes the property's value, animation may have stopped before completion. |
|   Discard | change due to the animation is discarded, original property value maintained |
|   BakeFinal | even if the animation does not complete the final target value becomes the property's value |

~~~{.cpp}
animation.SetEndAction( Animation::Discard );
~~~

### Stop Pause Clear

An animation can be paused and then continued with Play().
~~~{.cpp}
animation.Pause();
~~~

or stopped.  Once stopped, Play() will start it again.

~~~{.cpp}
animation.Stop();
~~~

### Alpha functions

The animations change the target property in a Linear way, to configure this an Alpha function can be supplied.

Alpha functions are used in animations to specify the rate of change of the animation parameter over time.<br>
This allows the animation to be, for example, accelerated, decelerated, repeated, or bounced.<br>
The built-in supported functions can be viewed in the Dali::AlphaFunction::BuiltinFunction

An example of setting an Ease In alpha function for all attached functions

~~~{.cpp}
animation.SetDefaultAlphaFunction( Dali::AlphaFunction::EASE_IN );
~~~

or for a specified function

~~~{.cpp}
animation.AnimateTo( Property( actor1, Dali::Actor::Property::POSITION ),
                     Vector3( 10.0f, 50.0f, 0.0f ),
                     Dali::AlphaFunction::EASE_IN );
~~~

Custom Alpha functions can be created

~~~{.cpp}
float MyAlphaFunction( float progress )
{
  // Do something cool with progress
  return progress;
}

AlphaFunction alphaFunction( &MyAlphaFunction );
animation.SetDefaultAlphaFunction( alphaFunction );
~~~

<a name="2"></a>
## Animation Notifications

Dali::Animation is a "fire and forget" framework, meaning that a handle to the animation does not need to be kept.<br>
The animation.Play() can be called and the handle can go out of scope.<br>

To track the animation the FinishedSignal signal can be used, it will trigger when the animation ends.

### FinishedSignal

~~~{.cpp}
animation.FinishedSignal().Connect( this, &HelloWorldExample::OnFinished );
~~~

<a name="3"></a>
## Key Frames

Key Frame Animation

DALi provides support for animating between several different values, or key frames.<br>
A key frame takes a progress value between 0.0f and 1.0f (0 and 100% respectively)
and portrays the value of the property when the animation has progressed that much.<br>
You can create several key frames:

~~~{.cpp}
KeyFrames keyFrames = KeyFrames::New();
                      keyFrames.Add( 0.0f, Vector3( 10.0f, 10.0f, 10.0f ) );
                      keyFrames.Add( 0.7f, Vector3( 200.0f, 200.0f, 200.0f ) );
                      keyFrames.Add( 1.0f, Vector3( 100.0f, 100.0f, 100.0f ) );
~~~

Next, you can add the key frames to your animation.

~~~{.cpp}
animation.AnimateBetween( Property( actor1, Dali::Actor::Property::POSITION ), keyFrames );
~~~

When you play the animation, DALi animates the position of actor1 between the specified key frames. <br>
The actor1 animates from (10.0f, 10.0f, 10.0f) to (200.0f, 200.f, 200.0f) by 70% (0.7f) of the animation time,
and then spends the remaining time animating back to (100.0f, 100.0f, 100.0f).<br>

The advantage of specifying a key frame at 0% is that regardless of where the actor1 is,
it starts from position (10.0f, 10.0f, 10.0f). If AnimateTo() is used
the start position is the actor1's current position.<br>
