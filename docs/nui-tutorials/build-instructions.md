---
layout: default
title: Nui Build Instructions
---
[ Home Page ]({{site.baseurl}}/index) <br>

<a name="top"></a>
# NUI Build Instructions

## The tutorial shows how to build NUI for Ubuntu

The required Dali repositories are hosted in here in DaliHub github and the NUI repository is hosted in the Samsung github.  

### Step-by-step guide

#### Setup

Dotnet, Dali, TizenFX and tizenfx-stub need to be setup.

    Install dotnet 2.0: follow the instructions here: https://www.microsoft.com/net/core#linuxubuntu

    Clone the repository git@github.com:dalihub/dali into your main repository folder.
    Clone the repository git@github.com:dalihub/dali-adaptor into your main repository folder.
    Clone the repository git@github.com:dalihub/dali-toolkit into your main repository folder.
    Clone the repository git@github.com:dalihub/tizenfx-stub.git into your main repository folder.
    Clone  ssh://<your tizen id>@review.tizen.org:29418/platform/core/uifw/dali-csharp-binder
    Clone the repository git@github.com:Samsung/tizenfx.git into your main repository folder.

    Optional: Set up a new application repo or folder,<br>
              e.g. you could clone 106.1.8.182:~david.steele/Git/Tizen/nui-contact-demo
              your csproj should contain the following references:

             <ItemGroup>
               <ProjectReference Include="..\tizenfx\src\Tizen.NUI\Tizen.NUI.csproj" />
             </ItemGroup>

#### Building

The Dali repositories need to be built into the dali-env (environment), then the Tizen stub and Tizen NUI repo built.

    Follow README instructions in dali-core repository to create dali-env folder.

    Source your dali-env environment script, see README in dali-core

    Build dali repos as indicated in the README for each repository.

    Build dali-csharp-binder:
        in the root folder, run
        autoreconf --install
        ./configure --prefix=$DESKTOP_PREFIX
        make -j8 install

    Build tizenfx-stub:
        cd tizenfx-stub
        cmake -DCMAKE_INSTALL_PREFIX=$DESKTOP_PREFIX
        make install

    Build TizenFX
        cd tizenfx
        ./build.sh full

    Build your demo app
        dotnet build
        dotnet runs

[Back to top](#top)
