# Tutorials

<a name="0">
## Index
- - - -

[1. Drawing a Line](#1)<br>
[2. Drawing a Triangle](#2)<br>
[3. Drawing a Cube](#3)<br>

- - -

<a name="#1"></a>
### 1. Drawing a Line

To render anything we need a geometry. The geometry ought to be created with known vertex format. Vertex format is an instance of Property::Map. Name and type of a property should match the name and type of the attribute in the shader ( ==see shader builtins== ). In this case we only need vertex position which is represented by Vector2 ( GLSL vec2 ) type.

```c++
Property::Map vertexFormat;
vertexFormat["aPosition"] = Property::VECTOR2;
PropertyBuffer vertices = PropertyBuffer::New( vertexFormat );
```

Now create and set vertex data:

```c++
struct Vertex { Vector2 position1; };
Vertex vertexData[2] =
{
  { Vector2(  0.5f,   0.5f) },
  { Vector2( -0.5f,  -0.5f) }
};
vertices.SetData( vertexData, 2 );
```

Create Geometry object and attach vertex buffer:

```c++
Geometry geometry = Geometry::New();
geometry.AddVertexBuffer( vertices );
```

In order to render lines it's necessary to set correct topology:

```c++
geometry.SetType( Geometry::LINES );
```

The Renderer needs a Shader. Shader program can be inlined in C++ source with use of **DALI_COMPOSE_SHADER** macro. The vector (x,y) position for each point on the line, will be passed using the aPosition attribute. The vertex shader will transform this to match the size and position of an Actor.

```c++
const char* VERTEX_SHADER = DALI_COMPOSE_SHADER(
attribute mediump vec2 aPosition; // DALi shader builtin
uniform   mediump mat4 uMvpMatrix; // DALi shader builtin
uniform   mediump vec3 uSize; // DALi shader builtin
void main()
{
  mediump vec4 vertexPosition = vec4(aPosition, 0.0, 1.0);
  vertexPosition.xyz *= uSize;
  gl_Position = uMvpMatrix * vertexPosition;
}
);
```

Then the fragment shader will apply the Actor’s color.

```c++
const char* FRAGMENT_SHADER = DALI_COMPOSE_SHADER(
uniform lowp vec4 uColor; // DALi shader builtin
void main()
{
  gl_FragColor = uColor;
}
);
```

Now the shader instance can be created:
```c++
Shader shader = Shader::New( VERTEX_SHADER, FRAGMENT_SHADER );
```

Next step is creating a Renderer. The Renderer is responsible for maintaining the graphics API states ( like blending, depth testing etc. ) and issuing a single draw call.

To create a Renderer:
```c++
Renderer renderer = Renderer::New( geometry, shader );
```

```c++
Stage stage = Stage::GetCurrent();
stage.SetBackgroundColor( Color::WHITE );

Actor actor = Actor::New();
actor.SetSize( stage.GetSize() );
actor.SetParentOrigin( ParentOrigin::CENTER );
actor.SetAnchorPoint( AnchorPoint::CENTER );
actor.SetColor( Color::BLACK );
actor.AddRenderer( renderer );
stage.Add( actor );
```

<img src="https://github.com/dalihub/dalihub.github.io/blob/master/images/rendering-api-line.png?raw=true" width="200">

[Back to top](#0)
[Source code](http://sourcecode)
- - -

<a name="#2"></a>
### 2. Drawing a Triangle

Using the same Shader and Renderer set-up from the previous [Drawing a Line](#1) example, we can modify the geometry to draw a triangle. The geometry will use ``Geometry::TRIANGLES`` topology type in order to render filled triangle.

```c++
Vertex vertexData[3] =
{
  { Vector2(  0.45f,  0.45f) },
  { Vector2( -0.45f,  0.45f) },
  { Vector2(  0.0f,  -0.45f) }
};
vertices.SetData( vertexData, 3 );
Geometry geometry = Geometry::New();
geometry.AddVertexBuffer( vertices );
geometry.SetType( Geometry::TRIANGLES );
```

We can also call ``Actor::SetColor( Color::RED )`` to get something more colorful:

<img src="https://github.com/dalihub/dalihub.github.io/blob/master/images/rendering-api-triangle.png?raw=true" width="200">

[Back to top](#0)
- - -


<a name="#3"></a>
### 3. Drawing a Cube

Drawing a colored cube requires a slightly more complicated shader & geometry format.

**Step 1. Create shader source code**

The aPosition attribute has been changed to a vec3, since the cube has 3 dimensions.

```c++
const char* VERTEX_SHADER = DALI_COMPOSE_SHADER(
attribute mediump vec3 aPosition;
attribute mediump vec3 aColor;
uniform   mediump mat4 uMvpMatrix;
uniform   mediump vec3 uSize;
varying mediump vec4 vColor;
void main()
{
  mediump vec4 vertexPosition = vec4(aPosition, 1.0);
  vertexPosition.xyz *= uSize;
  gl_Position = uMvpMatrix * vertexPosition;
  vColor = vec4(aColor, 1.0);
}
);
```

Each face of the cube will be given a different color using the vColor varying.

```c++
const char* FRAGMENT_SHADER = DALI_COMPOSE_SHADER(
varying mediump vec4 vColor;
void main()
{
  gl_FragColor = vColor;
}
);
```

**Step 2. Create the cube geometry**

The vertex format was extended to match the shader. Each of the 6 cube faces requires 4 vertices (24 in total).  Each vertex consists of a vec3 and RGB color component.

```c++
Property::Map vertexFormat;
vertexFormat["aPosition"] = Property::VECTOR3;
vertexFormat["aColor"]    = Property::VECTOR3;
PropertyBuffer vertices = PropertyBuffer::New( vertexFormat );

struct Vertex
{
  Vector3 position;
  Vector3 color;
};

Vertex vertexData[24] =
{
  { Vector3( -0.5, -0.5,  0.5 ), Vector3( 1.0, 0.0, 0.0 ) },
  { Vector3(  0.5, -0.5,  0.5 ), Vector3( 1.0, 0.0, 0.0 ) },
  { Vector3( -0.5,  0.5,  0.5 ), Vector3( 1.0, 0.0, 0.0 ) },
  { Vector3(  0.5,  0.5,  0.5 ), Vector3( 1.0, 0.0, 0.0 ) },
  { Vector3( -0.5, -0.5, -0.5 ), Vector3( 0.0, 1.0, 0.0 ) },
  { Vector3(  0.5, -0.5, -0.5 ), Vector3( 0.0, 1.0, 0.0 ) },
  { Vector3( -0.5,  0.5, -0.5 ), Vector3( 0.0, 1.0, 0.0 ) },
  { Vector3(  0.5,  0.5, -0.5 ), Vector3( 0.0, 1.0, 0.0 ) },
  { Vector3( -0.5, -0.5, -0.5 ), Vector3( 0.0, 0.0, 1.0 ) },
  { Vector3(  0.5, -0.5, -0.5 ), Vector3( 0.0, 0.0, 1.0 ) },
  { Vector3( -0.5, -0.5,  0.5 ), Vector3( 0.0, 0.0, 1.0 ) },
  { Vector3(  0.5, -0.5,  0.5 ), Vector3( 0.0, 0.0, 1.0 ) },
  { Vector3( -0.5,  0.5, -0.5 ), Vector3( 1.0, 1.0, 0.0 ) },
  { Vector3(  0.5,  0.5, -0.5 ), Vector3( 1.0, 1.0, 0.0 ) },
  { Vector3( -0.5,  0.5,  0.5 ), Vector3( 1.0, 1.0, 0.0 ) },
  { Vector3(  0.5,  0.5,  0.5 ), Vector3( 1.0, 1.0, 0.0 ) },
  { Vector3( -0.5, -0.5, -0.5 ), Vector3( 1.0, 0.0, 1.0 ) },
  { Vector3( -0.5,  0.5, -0.5 ), Vector3( 1.0, 0.0, 1.0 ) },
  { Vector3( -0.5, -0.5,  0.5 ), Vector3( 1.0, 0.0, 1.0 ) },
  { Vector3( -0.5,  0.5,  0.5 ), Vector3( 1.0, 0.0, 1.0 ) },
  { Vector3(  0.5, -0.5, -0.5 ), Vector3( 0.0, 1.0, 1.0 ) },
  { Vector3(  0.5,  0.5, -0.5 ), Vector3( 0.0, 1.0, 1.0 ) },
  { Vector3(  0.5, -0.5,  0.5 ), Vector3( 0.0, 1.0, 1.0 ) },
  { Vector3(  0.5,  0.5,  0.5 ), Vector3( 0.0, 1.0, 1.0 ) },
};

vertices.SetData( vertexData, 24 );
Geometry geometry = Geometry::New();
geometry.AddVertexBuffer( vertices );
geometry.SetType( Geometry::TRIANGLES );
```

Single vertex may participate in creating more than one face. To avoid needless duplication of vertices the geometry may use **indexed draw**. In order to use an indexed draw mode the table of indices has to be provided:

```c++
const unsigned short INDEX_CUBE[] = { 0,  2,  3,  0,  3,  1,
                                      5,  7,  6,  5,  6,  4,
                                      8, 10, 11,  8, 11,  9,
                                     14, 12, 13, 14, 13, 15,
                                     16, 17, 19, 16, 19, 18,
                                     22, 23, 21, 22, 21, 20 };
```

Then the **index buffer** has to be set for the Geometry object:

```c++
geometry.SetIndexBuffer(&INDEX_CUBE[0],
                        sizeof(INDEX_CUBE)/sizeof(INDEX_CUBE[0]) );

```

**Step 3. Create Renderer**

There is no SetColor needed for the actor, since we are not using the uColor uniform.  Face culling is enabled to hide the backwards facing sides of the cube.

```c++
Shader shader = Shader::New( VERTEX_SHADER, FRAGMENT_SHADER );
Renderer renderer = Renderer::New( geometry, shader );
renderer.SetProperty( Renderer::Property::FACE_CULLING_MODE, FaceCullingMode::BACK );

Actor actor = Actor::New();
float length = stage.GetSize().width * 0.5f;
actor.SetSize( length, length, length );
actor.SetParentOrigin( ParentOrigin::CENTER );
actor.AddRenderer( renderer );
stage.Add( actor );
```

To make it more interesting we may add animation ( after all, cubes always look better when they spin in 3D space ). For more details see tutorials about [DALi Animation API](#todo-add-tutorial).


```c++
mAnimation = Animation::New( 10.0f );
mAnimation.AnimateTo( Property( actor, Actor::Property::ORIENTATION ), Quaternion( Radian( Degree( 180 ) ), Vector3::ZAXIS ) );
mAnimation.AnimateTo( Property( actor, Actor::Property::ORIENTATION ), Quaternion( Radian( Degree( 180 ) ), Vector3::YAXIS ) );
mAnimation.Play();
```

The following screenshot was taken whilst the animation was running:

<img src="https://github.com/dalihub/dalihub.github.io/blob/master/images/rendering-api-cube.png?raw=true" width="200">


[Back to top](#0)
[Source code](sourcecode)
- - -
