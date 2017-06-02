<a name="0"></a>
# Setting up the NUI development environment on Ubuntu

This guide explains how to setup, build and run NUI (DALi C#) applications using Visual Studio Core (VSC).

It assumes the starting point is a completely 'clean' system, though that is not essential.

The [Hello World tutorial](../NUItutorials/hello-world.md) provides an introduction into NUI application development,
describing how to display text in a text label.

## Overview
This document covers:

[Installation of .NET Core and VSC](#1)<br>
[Getting NUI source code](#2)<br>
[NUI build environment](#3)<br>
[Building NUI source code](#4)<br>
[Build and run the Hello World tutorial](#5)<br>
[Appendix A - Configuring firewall proxy settings](#6)<br>

## Step-by-step guide

<a name="1"></a>
### Installation of .NET Core and Visual Studio Core (VSC)

* Install dot net core for Ubuntu
    1. Follow instructions for [installing dotnet core for Ubuntu](https://www.microsoft.com/net/core#linuxubuntu)

* Install latest VSC for Ubuntu
    1. [Download deb package](https://code.visualstudio.com).
    2. Install deb package with:
~~~{.sh}
    $ sudo dpkg -i code_1.10.2xXXXXXXXXXX_amd64.deb
~~~

* Open VSC via Launch button
    1. In the desktop launcher, select _Search your Computer_ > _Applications_ for the Visual Studio Code icon.
    2. Select the _Launch_ button to open VSC

* Open VSC via desktop launcher
    1. In the desktop launcher, select _Search your Computer_ > _Applications_ for the Visual Studio Code icon.
    2. Copy VSC icon to Launcher.
    3. Double click on the VSC icon in Launcher.

* Open VSC via terminal
~~~{.sh}	
    $ code
    $ code myfile
~~~

* Firewall proxy settings
VSC requires installation of required packages and libraries. It may be necessary to configure the firewall
proxy settings to enable download via http. The procedures for firewall setup are described in [Appendix A](#6).

* Install C# extension from within VSC, via the Extensions View
    1. Bring up the Extensions view by clicking on the extensions icon in the Activity Bar, or Ctrl+Shift+X (View extensions command).
    2. This will bring up all the extensions in the VS code marketplace.
    3. Click the Install button next to C#. After a successful install, you will see the Reload button, click to restart VSC.

* Alternatively, install C# extension from website
    1. Install [Install _C# extension_ from visual studio marketplace](https://marketplace.visualstudio.com)

#### Recommended - Familiarisation with VSC

+ Build VSC with a console hello world

[Getting started with Visual Studio code](https://docs.microsoft.com/en-us/dotnet/csharp/getting-started/with-visual-studio-code)
will give you a basic understanding of building, debugging and running projects in VSC.

[Back to top](#0)

<a name="2"></a>
### Get NUI source code from Git

* Create a 'NUI root folder' for the source code, _I am using ~/DALiNUI as an example_
~~~{.sh}	
    $ mkdir ~/DALiNUI
    $ cd ~/DALiNUI
~~~

* Get code from git (via _review.tizen.org_ server)
~~~{.sh}
    $ git clone ssh://[Tizen.org username]@review.tizen.org:29418/platform/core/uifw/dali-core
    $ git clone ssh://[Tizen.org username]@review.tizen.org:29418/platform/core/uifw/dali-adaptor
    $ git clone ssh://[Tizen.org username]@review.tizen.org:29418/platform/core/uifw/dali-csharp-binder
    $ git clone ssh://[Tizen.org username]@review.tizen.org:29418/platform/core/uifw/dali-toolkit
    $ git clone ssh://[Tizen.org username]@review.tizen.org:29418/platform/core/csapi/nui
~~~

**Observation:** _only the .git file is pulled into the dali-csharp-binder and nui folders._

* Switch to the 'devel master' branch for each required repo

~~~{.sh}
    $ cd ~/DALiNUI/dali-core
    $ git checkout devel/master
    $ git pull
~~~

Repeat above steps for the dali-adaptor and dali-toolkit folders.

[Back to top](#0)

<a name="3"></a>
### NUI build environment

* Build environment setup, saving to a file:

~~~{.sh}
    $ cd ~/DALiNUI
    $ dali-core/build/scripts/dali_env -c
    $ dali-env/opt/bin/dali_env -s > setenv
    $ . setenv
~~~

These steps only need to be done once.

You will have to source your environment variables every time you open up a new terminal (or you can add to .bashrc if you prefer).
You can do this by sourcing the ''setenv'' script you created above: 

~~~{.sh}
    $ . setenv
~~~

[Back to top](#0)

<a name="4"></a>
### Building NUI source code

* Build DALi *native* repo's in the following order, follow instructions in the README file in each repo folder.
    1. Build dali-core
    2. Build dali-adaptor
    3. Build dali-toolkit

_The shared library files (.so) will be built and installed into the ~/DALiNUI/dali-env/opt/lib_ folder.

* To subsequently clean the build
~~~{.sh}
    $ make maintainer-clean	
~~~

* Optional - Run and test DALi Native (C++)
    1. Get code - This step requires the _dali_demo_ repo:

~~~{.sh}
    $ git clone ssh://[Tizen.org username]@review.tizen.org:29418/platform/core/uifw/dali-demo
~~~

~~~{.sh}
    $ cd ~/DALiNUI/dali-demo
    $ git checkout devel/master
    $ git pull
~~~

    2. Build from README

    3. run:
~~~{.sh}
    $ cd ~/DALiNUI/dali-env/opt/bin
    $ dali-demo
~~~

If ok, DALi demo window will appear.

* Build NUI csharp bindings
    1. In this step we build the C# bindings:
~~~{.sh}
   $ cd dali-csharp-binder
~~~

    2. Edit _file.list_ and remove the line "src/key-grab.cpp \".
       (_This is a tizen only dependency_). Do not leave a gap in the file.
    3. Build bindings by following the README file. (_"Building the Repositry"_)

* Overwrite existing NUI files in ~/DALiNUI/nuirun/src/public
    1. Create a sub folder (_I have used nuirun_), copy nui source code into sub folder:
~~~{.sh}
    $ cd ~/DALiNUI
    $ mkdir nuirun
    $ cp -r nui/Tizen.NUI/src nuirun
~~~

    2. Overwrite file by downloading [NUIApplication.cs](../NUIfilesForOverWriting/NUIApplication.cs) ~/DALiNUI/nuirun/src/public
    3. Overwrite file by downloading [CoreUIApplication.cs](../NUIfilesForOverWriting/CoreUIApplication.cs) ~/DALiNUI/nuirun/src/public

_This step of overwriting these files is necessary as NUI In Ubuntu is not fully supported just yet._

* Copy shared library:
~~~{.sh}
   cp  dali-env/opt/lib/libdali-csharp-binder.so ~/DALiNUI/nuirun/bin/Debug/netcoreapp1.1/
~~~

[Back to top](#0)

<a name="5"></a>
### Build NUI and Run the Hello World (NUI) Tutorial

* Create a 'Hello World' project in VSC
    1. Open VSC, open the command prompt (Ctrl+`)
    2. In the Terminal, type the following:

~~~{.sh}
    $ cd ~/DALiNUI/nuirun
    $ . setenv
    $ dotnet new console
~~~

The setenv may not be necessary, depending on how the environment has been setup.

The _dotnet new console_ creates a Project file *nuirun.csproj* which is essential, and also Program.cs.

+ Delete Program.cs in VSC Explorer, as its not needed

+ Modify project file
    1. Edit nuirun.csproj, adding the following line inside the PropertyGroup element:
~~~{.sh}
    <DefineConstants>DOT_NET_CORE<DefineConstants>
~~~

+ Create tutorial file (in VSC)
    1. File > New File
    2. Copy code in (_"full example" section_) of [Hello World tutorial](../NUItutorials/hello-world.md) to new file
    3. Rename file, File > Save As "hello-world.cs", or select right click and Rename from menu

+ Build assets
    1. Resolve the build assets
~~~{.sh}
    $ dotnet restore
~~~

Running dotnet restore pulls down the required packages.

+ Configure VSC by creating tasks.json
    1. Press Ctrl+Shift+P to open the command Pallete, type "ctr", and select Configure Task runner > NET core

A _tasks.json_ file is essential, or else will get "No task runner configured", or "Error Could not find the Pre Launch Task 'build'"
message pane on building.

+ Build
~~~{.sh}
    $ dotnet build
~~~

#### Modify Hello World Application window size

This section provides an insight into the capability of launch.json.

In VSC, Open _launch.json_ via the Explorer. In the "configurations" section, add the required width and height:

~~~{.sh}
    "name": ".NET Core Launch (console)",

    ...
    ...
    "env": {
        "DALI_WINDOW_WIDTH":"600",
        "DALI_WINDOW_HEIGHT":"800"
    },
~~~

<a name="6"></a>
### Appendix A - Configuring Firewall proxy settings

* Setup System firewall Proxy settings for VSC _enable install of the VSC C# extension package_
    1. On desktop, select System Settings > Network > Network Proxy >  HTTP Proxy and type IP address e.g **http://xxx.xxx.xxx.xxx port xxxx**
    2. On desktop, select System Settings > Network > Network Proxy > HTTPS Proxy and type IP address e.g **http://xxx.xxx.xxx.xxx port xxxx**

* Configure VSC firewall proxy settings (_for install of library packages such as mono runtime and .NET Core Debugger_) 
    1. Select File > Preferences > Settings > Edit
    2. Select HTTP in middle pane
    3. Select Edit icon > Copy to settings. "http.proxy" should be copied to right hand pane:
~~~{.sh}
    {
       "http.proxy":
    }
~~~

    4. Add the proxy setting:
~~~{.sh}
    {
       "http.proxy": "http://xxx.xxx.xxx.xxx:xxxx
    }
~~~

The proxy settings are saved to the _settings.json_ file.

* OR Set the OS environment variables http_proxy and https_proxy, in a terminal from which VSC will be run
~~~{.sh}
   $ export http_proxy=http://xxx.xxx.xxx.xxx
   $ export https_proxy=http://xxx.xxx.xxx.xxx
~~~

These export variables could also be set in your .bashrc file

[Back to top](#0)

