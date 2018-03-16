---
layout: default
title: Nui Build Instructions
---
[ Home Page ]({{site.baseurl}}/index) <br>

<a name="top"></a>
# NUI Build Instructions

## The tutorial shows how to build NUI for Ubuntu

The required Dali repositories are hosted here in DaliHub github and the NUI repository is hosted in the Samsung github.  
### Step-by-step guide

#### Setup

Dotnet will need to be setup. <br>
dali-csharpi-binder will need a Tizen.org ID for downloading.
Other repos are in dalihub hosted in github.

    Install dotnet 2.0, follow the instructions below:
    https://www.microsoft.com/net/core#linuxubuntu

    Clone the following repos into your main repository folder:

    git@github.com:dalihub/dali-adaptor
    git@github.com:dalihub/dali-toolkit
    git@github.com:dalihub/tizenfx-stub.git
    git@github.com:Samsung/tizenfx.git
    review.tizen.org:29418/platform/core/uifw/dali-csharp-binder

    Optional:

    Set up a new application repo or folder,<br>
    your csproj should contain the following references:

    <ItemGroup>
      <ProjectReference Include="..\tizenfx\src\Tizen.NUI\Tizen.NUI.csproj" />
    </ItemGroup>

#### Building

The Dali repositories need to be built into the dali-env (environment), then the Tizen stub and Tizen NUI repo built.

    Follow README instructions in dali-core repository to create dali-env folder.

    "Source" your dali-env environment script, see README in dali-core

    Build dali repos as indicated in the README for each repository.

    Build dali-csharp-binder:
        cd <<dali-csharp-binder>>
        autoreconf --install
        ./configure --prefix=$DESKTOP_PREFIX
        make -j8 install

    Build tizenfx-stub:
        cd <<tizenfx-stub>>
        cmake -DCMAKE_INSTALL_PREFIX=$DESKTOP_PREFIX
        make install

    Build TizenFX ( See README for latest instructions )
        cd <<TizenFX directory>>
        ./build.sh full

    Build your demo app
        dotnet build
        dotnet run

[Back to top](#top)
