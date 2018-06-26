---
layout: default
title: NUI Build Instructions
---
[ Home Page ]({{site.baseurl}}/index) <br>

<a name="top"></a>
# NUI Build Instructions

## The tutorial shows how to build NUI for Ubuntu

The required DALi repositories are hosted here in DaliHub github.
It also contains a fork of the TizenFX repository (originally hosted in the Samsung github).

### Step-by-step guide

#### Setup

* Install dotnet 2.0 using the instructions <a href="https://www.microsoft.com/net/core#linuxubuntu">here</a>
* Clone the following repos into your main repository folder:

```
  git@github.com:dalihub/dali-core
  git@github.com:dalihub/dali-adaptor
  git@github.com:dalihub/dali-toolkit
  git@github.com:dalihub/dali-csharp-binder
  git@github.com:dalihub/tizenfx-stub.git
  git@github.com:dalihub/TizenFX.git
  git@github.com:dalihub/nui-demo.git
```

#### Building

The DALi repositories need to be built into the dali-env (environment), then the Tizen stub and Tizen NUI repo built.

* Follow README instructions in dali-core repository to create dali-env folder
* "Source" your dali-env environment script, see README in dali-core
* Build DALi repos as indicated in the README for each repository
* Build tizenfx-stub:
```
  cd <<tizenfx-stub>>
  cmake -DCMAKE_INSTALL_PREFIX=$DESKTOP_PREFIX
  make install
```
* Build TizenFX ( See README for latest instructions )
```
  cd <<TizenFX>>
  ./build.sh full
```
* Build nui-demo
```
  cd <<nui-demo>>
  dotnet build
  dotnet run
```

[Back to top](#top)
