# Tutorials - Textured Cube


This tutorial shows how to create texture cube using DALi Rendering API.

## Setup

```c++
void Create( Application& application )
{
  // Get a handle to the stage
  Stage stage = Stage::GetCurrent();
  stage.SetBackgroundColor( Color::WHITE );

  // Step 1. Create shader
  CreateCubeShader();

  // Step 2. Load a texture
  CreateTexture();

  // Step 3. Prepare geometry
  CreateCubeGeometry();

  // Step 4. Create a renderer
  CreateRenderer();

  // Step 5. Create an Actor
  CreateActor();

  // Step 6. Play animation
  PlayAnimation();

  // Respond to a click anywhere on the stage
  stage.GetRootLayer().TouchSignal().Connect( this, &TexturedCubeController::OnTouch );
}

```

## Step 1: CreateCubeShader()

To render anything we will need a shader program. In this case, we need vertex positions and texture coordinates provided in order to render a textured cube. Since cube is a 3D object positions are represented as ``vec3`` types. The texture coordinates ( UVs ) are ``vec2``

```c++
const char* VERTEX_SHADER = DALI_COMPOSE_SHADER(
attribute mediump vec3 aPosition;
attribute mediump vec2 aTexCoord;
uniform   mediump mat4 uMvpMatrix;
uniform   mediump vec3 uSize;

varying mediump vec2 vTexCoord;
void main()
{
  mediump vec4 vertexPosition = vec4( aPosition, 1.0 );
  vertexPosition.xyz *= uSize;
  vTexCoord = aTexCoord;
  gl_Position = uMvpMatrix * vertexPosition;
}
);
```

Fragment shader contains single ``sampler2D`` uniform.

```c++
const char* FRAGMENT_SHADER = DALI_COMPOSE_SHADER(
uniform sampler2D uTexture;
varying mediump vec2 vTexCoord;
void main()
{
  mediump vec4 texColor = texture2D( uTexture, vTexCoord );
  gl_FragColor = texColor;
}
);
```

All we need to do is transforming incoming vertices by applying actor size ``uSize`` and ``uMvpMatrix`` and assing a result to the shader output variable ``gl_Position``. The texture coordinate will be interpolated between vertices and passed to the fragment shader as ``varying vec2 vTexCoord``. Then fragment shader will sample a texel at ``vTexCoord`` positon and apply obtained color to fragment shader output - ``gl_FragColor``.

Once we have needed shader code we can create a Shader object:

```c++
void CreateCubeShader()
{
  mShader = Shader::New( VERTEX_SHADER, FRAGMENT_SHADER );
}
```

## Step 2: CreateTexture()

DALi provides several types of objects related to texturing:

| Class | Description |
| --- | --- |
| ``Dali::Texture``| Represents 2D or CUBE texture object |
| ``Dali::TextureSet`` | Represents an array of textures which can be passed to the renderer and then shader |
| ``Dali::PixelData`` | Raw pixels which can be used as source to create ``Dali::Texture`` |
| ``Dali::Sampler`` | Describes sampler properties like filtering |

```c++
void CreateTexture()
{
  // Load image from file
  PixelData pixels = SyncImageLoader::Load( TEXTURE_URL );
```
The PixelData can be obtain either from file or from a binary data. In this case we are loading an image using ``SyncImageLoader`` utility from ``Dali::Toolkit``. It returns instantiated ``PixelData`` object or ``NULL`` on failure.

Next step is creating an instance of a ``Texture`` object which specifies what type of texture we want to create ( here is ``TextureType::TEXTURE_2D`` ) and additional details like pixel format, and width and height of a bitmap. ``PixelData`` provides all needed information so we can use it as well to set the texture parameters:

``c++
  Texture texture = Texture::New( TextureType::TEXTURE_2D, pixels.GetPixelFormat(), pixels.GetWidth(), pixels.GetHeight() );
``

Such created texture doesn't contain any data. In order to fill it with an actual image we need to upload previously obtained ``PixelData``:

```c++
  texture.Upload( pixels, 0, 0, 0, 0, pixels.GetWidth(), pixels.GetHeight() );
```

Optionally, we may generate mipmaps ( note, this must happen after uploading the data ). To use generated mipmaps it's important to provide a ``Dali::Sampler`` that specifies minification filter as ``FilterMode::LINEAR_MIPMAP_LINEAR``. Otherwise mipmapping will have no effect.

```c++
  texture.GenerateMipmaps();
```

Since this example uses mipmaps we need to create a ``Dali::Sampler`` to set the filtering mode:

```c++
Sampler sampler = Sampler::New();
sampler.SetFilterMode( FilterMode::LINEAR_MIPMAP_LINEAR, FilterMode::LINEAR );
sampler.SetWrapMode( WrapMode::REPEAT, WrapMode::REPEAT, WrapMode::REPEAT );
```

Next we can create ``Dali::TextureSet`` and set the texture and sampler:

```c++
  // create TextureSet
  mTextureSet = TextureSet::New();
  mTextureSet.SetTexture( 0, texture );
  mTextureSet.SetSampler( 0, sampler );
```

Note that there is no requirement to create and set a ``Dali::Sampler`` and the default one will be used, however it makes it clearer to set it explicitly without relying on the defaults.

``TextureSet::SetTexture()`` and ``TextureSet::SetSampler`` takes an sampler/texture index as the first argument.

==**Unlike normal uniforms textures don't use GLSL reflection ( in other words actual names don't matter ). An index passed to ``TextureSet::SetTexture()`` and ``TextureSet::SetSampler`` must match an index of sampler in the shader code ( first sampler as index 0, second sampler as index 1 etc. ).**==

## Step 3: CreateCubeGeometry()

Once we have a texture loaded, the geometry can be created. For that we need vertices and texture coordinates.

| Class | Description |
| --- | --- |
| ``Dali::PropertyBuffer`` | Describes per-vertex data ( positions, UVs etc. ) |
| ``Dali::Property::Map`` | Describes single vertex format per property buffer |
| ``Dali::Geometry`` | Describes geometry including drawing mode, topology, etc. |


The helper structure ``Vertex`` describes a single vertex data format.
```c++
void CreateCubeGeometry()
{
  struct Vertex
  {
    Vector3 aPosition;
    Vector2 aTexCoord;
  };
```

Next we can create an array containing vertex data ( 36 vertices, each of 5 floats ):
```c++
  Vertex vertices[] = {
    { Vector3(  1.0f,-1.0f,-1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3( -1.0f, 1.0f,-1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3(  1.0f, 1.0f,-1.0f ), Vector2( 0.0, 1.0 ) },
    { Vector3( -1.0f, 1.0f, 1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3(  1.0f,-1.0f, 1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3(  1.0f, 1.0f, 1.0f ), Vector2( 0.0, 1.0 ) },
    { Vector3(  1.0f, 1.0f, 1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3(  1.0f,-1.0f,-1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3(  1.0f, 1.0f,-1.0f ), Vector2( 0.0, 1.0 ) },
    { Vector3(  1.0f,-1.0f, 1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3( -1.0f,-1.0f,-1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3(  1.0f,-1.0f,-1.0f ), Vector2( 0.0, 1.0 ) },
    { Vector3( -1.0f,-1.0f,-1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3( -1.0f, 1.0f, 1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3( -1.0f, 1.0f,-1.0f ), Vector2( 0.0, 1.0 ) },
    { Vector3(  1.0f, 1.0f,-1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3( -1.0f, 1.0f, 1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3(  1.0f, 1.0f, 1.0f ), Vector2( 0.0, 1.0 ) },
    { Vector3(  1.0f,-1.0f,-1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3( -1.0f,-1.0f,-1.0f ), Vector2( 1.0, 0.0 ) },
    { Vector3( -1.0f, 1.0f,-1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3( -1.0f, 1.0f, 1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3( -1.0f,-1.0f, 1.0f ), Vector2( 1.0, 0.0 ) },
    { Vector3(  1.0f,-1.0f, 1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3(  1.0f, 1.0f, 1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3(  1.0f,-1.0f, 1.0f ), Vector2( 1.0, 0.0 ) },
    { Vector3(  1.0f,-1.0f,-1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3(  1.0f,-1.0f, 1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3( -1.0f,-1.0f, 1.0f ), Vector2( 1.0, 0.0 ) },
    { Vector3( -1.0f,-1.0f,-1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3( -1.0f,-1.0f,-1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3( -1.0f,-1.0f, 1.0f ), Vector2( 1.0, 0.0 ) },
    { Vector3( -1.0f, 1.0f, 1.0f ), Vector2( 0.0, 0.0 ) },
    { Vector3(  1.0f, 1.0f,-1.0f ), Vector2( 1.0, 1.0 ) },
    { Vector3( -1.0f, 1.0f,-1.0f ), Vector2( 1.0, 0.0 ) },
    { Vector3( -1.0f, 1.0f, 1.0f ), Vector2( 0.0, 0.0 ) },
  };
```

The ``Dali::PropertyBuffer`` must be told what vertex format it's going to deal with. To handle that we can instantiate a ``Property::Map`` object. A key is a string matching a corresponding attribute name in the vertex shader. The value is a data type which **must** be compatible with one in the vertex shader:

```c++
  PropertyBuffer vertexBuffer = PropertyBuffer::New( Property::Map()
                                                     .Add( "aPosition", Property::VECTOR3 )
                                                     .Add( "aTexCoord", Property::VECTOR2 ) );
```

Now we can set the data using ``PropertyBuffer::SetData()``:
```c++
  vertexBuffer.SetData( vertices, sizeof(vertices) / sizeof(Vertex) );
```

We are going to use *indexed draw* mode ( equivalent of ``glDrawElements()`` ) so we need to define an index buffer:

```c++
  // create indices
  const unsigned short INDEX_CUBE[] = {
    2, 1, 0,
    5, 4, 3,
    8, 7, 6,
    11, 10, 9,
    14, 13, 12,
    17, 16, 15,
    20, 19, 18,
    23, 22, 21,
    26, 25, 24,
    29, 28, 27,
    32, 31, 30,
    35, 34, 33
  };
```

Next we create new ``Dali::Geometry``, add ``vertexBuffer``, set an index buffer and set the topology to ``Geometry::TRIANGLES``:

```c++
  mGeometry = Geometry::New();
  mGeometry.AddVertexBuffer( vertexBuffer );
  mGeometry.SetIndexBuffer( INDEX_CUBE,
                            sizeof(INDEX_CUBE)/sizeof(INDEX_CUBE[0]) );
  mGeometry.SetType( Geometry::TRIANGLES );
}
```

The Geometry is ready to be used.

## Step 4: CreateRenderer()


This function create a ``Dali::Renderer``.

| Class | Description |
| --- | --- |
| ``Dali::Renderer`` | Represents single draw call and maintains a pipeline states |


New ``Dali::Renderer`` requires to pass **valid** ``Dali::Geometry`` and ``Dali::Shader``. Hence, these objects must be instantiated beforehand. However, the geometry and shader may be changed dynamically later with use of ``Renderer::SetShader()`` and ``Renderer::SetGeometry()`` functions.

```c++
void CreateRenderer()
{
  mRenderer = Renderer::New( mGeometry, mShader );
```

We want to use textures so now it's time to set previously instantiated ``Dali::TextureSet``:
```c++
  mRenderer.SetTextures( mTextureSet );
```

To avoid glitches caused by depth testing we need to turn on depth test and depth write ( however using LAYER_3D turns them on by default ):

```c++
  mRenderer.SetProperty( Renderer::Property::DEPTH_TEST_MODE, DepthTestMode::ON );
  mRenderer.SetProperty( Renderer::Property::DEPTH_WRITE_MODE, DepthWriteMode::ON );
}
```

## Step 5: CreateActor()

The Renderer is pretty much useless without an actor. To make it working we need to create an actor and attach the Renderer:

```c++
void CreateActor()
{
  Stage stage = Stage::GetCurrent();
  Size size = stage.GetSize() * 0.25f;
  mActor = Actor::New();
  mActor.SetAnchorPoint( AnchorPoint::CENTER );
  mActor.SetParentOrigin( ParentOrigin::CENTER );
  mActor.SetPosition( Vector3( 0.0f, 0.0f, 0.0f ) );
  mActor.SetSize( Vector3( size.x, size.x, size.x ) );
  mActor.AddRenderer( mRenderer );
  stage.Add( mActor );
}
```

## Step 6: PlayAnimation()

Last, optional step is just making our cube animated. Everything looks better when it animates and cubes are no exception to the rule:

```c++
void PlayAnimation()
{
  mAnimation = Animation::New( 5.0f );
  mAnimation.SetLooping( true );
  mAnimation.AnimateBy( Property( mActor, Actor::Property::ORIENTATION ), Quaternion( Radian( Degree( 180 ) ), Vector3::ZAXIS ) );
  mAnimation.AnimateBy( Property( mActor, Actor::Property::ORIENTATION ), Quaternion( Radian( Degree( 180 ) ), Vector3::YAXIS ) );
  mAnimation.Play();
}
```

[Link to the source]()<br>
