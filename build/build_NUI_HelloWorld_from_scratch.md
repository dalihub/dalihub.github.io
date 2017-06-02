<a name="0"></a>
# Setting up the environment for building applications using NUI on Ubuntu

This guide explains how to setup, build and run NUI (Dali C#) applications using Visual Studio Core.

It assumes the starting point is a completely 'clean' system.

A "Hello World" tutorial ![](../NUItutorials/hello-world.md) provides an introduction into NUI application development.

## Step-by-step guide

+ Install dot net core for Ubuntu
	Follow instructions on installing dotnet core for Ubuntu [](www.microsoft.com/net/core#linuxubuntu)

+ Install latest Visual Studio Core (VSC) for Ubuntu

a. 	Download deb package from [](https://code.visualstudio.com)

b.   	Install deb package with:
~~~{.bash}
	$ sudo dpkg -I code_1.10.2xXXXXXXXXXX_amd64.deb
~~~
c.   	Setup firewall proxy settings in VSC, select File > Preferences > Settings > Edit "http.proxy" (_in settings.json_).
        This will enable dependencies to be downloaded. e.g "http.proxy": "http://106.1.18.35:8080"

d.      Install _C# extension_ from [](https://marketplace.visualstudio.com)

e.	Create _task.json_ by pressing Ctrl+Shift+P to open the command Pallete, type "ctr", and select
	Configure Task runner > NET core

+ Get code from git (_review.tizen.org_ server)

a.	Create a 'NUI root folder' for the source code e.g. mkdir ~/DALiNUI (_on my system_, used as the example for rest of tutorial)

b.  	$ cd ~/DALiNUI

c.  	Get code:
~~~{.sh}
	$ git clone ssh://[your account]@review.tizen.org:29418/platform/core/uifw/dali-core
	$ git clone ssh://[your account]@review.tizen.org:29418/platform/core/uifw/dali-adaptor
	$ git clone ssh://[your account]@review.tizen.org:29418/platform/core/uifw/dali-csharp-binder
	$ git clone ssh://[your account]@review.tizen.org:29418/platform/core/uifw/dali-toolkit
	$ git clone ssh://[your account]@review.tizen.org:29418/platform/core/csapi/nui
~~~

where 'your account' is 'm.castling' in my case, so-  ...://m.castling@review.tizen.org:29418.....

Observation: _only the .git file is pulled into the _dali-csharp-binder_ and _nui_ folders.

+ Switch to the 'devel master' branch for each repo

a.	$ cd ~/DALiNUI/dali-core

b.	$ git checkout devel/master

c.	$ git pull

Repeat above steps for dali-adaptor and dali-toolkit folders

+ Build environment setup, saving to a file

~~~{.sh}
a.	$ cd ~/DALiNUI

b.	$ dali-core/build/scripts/dali_env -c

c.	$ dali-env/opt/bin/dali_env -s > setenv

d.	$ . setenv
~~~

These steps only need to be done once.

You will have to source your environment variables every time you open up a new terminal (or you can add to .bashrc if you prefer). You can do this by sourcing the ''setenv'' script you created above: 

~~~{.sh}
	$ . setenv
~~~

+ Build DALi *native* repo's

To build, follow instructions in the README file in each repo folder.

a.	Build in the following order:
		dali-core
		dali-adaptor
		dali-toolkit

_The shared library files (.so) will be built and installed into the ~/DALiNUI/dali-env/opt/lib_ folder.

b.	To subsequently clean the build, use:
~~~{.sh}
	$ make maintainer-clean	
~~~

+  Run and debug DALi native (*Optional* step)

This step can be done if required to test native build.

This step requires the _dali_demo_ repo.

Repeat above steps for getting and building dali_demo repo:

a.	Get code:
~~~{.sh}
	$ git clone ssh://[your account]@review.tizen.org:29418/platform/core/uifw/dali-demo
~~~
b. 	Switch to 'devel master' branch

c. 	Build from README

d. 	run:
~~~{.sh}
	$ cd ~/DALiNUI/dali-env/opt/bin
	$ . setenv
	$ dali-demo
~~~

If ok, DALi demo window will appear.

+ Build NUI csharp bindings

In this step we build the C# bindings.

a. 	$ cd dali-csharp-binder

b. 	Edit _file.list_ and remove the line "src/key-grab.cpp \".
   	(_This is a tizen only dependency_)

c. 	Build bindings by following the README file. (_"Buildng the Repositry"_)

+ Overwrite existing NUI files

Create a sub folder (_I have used nuirun_), copy nui source code into sub folder:
~~~{.sh}
a. 	$ cd ~/DALiNUI

b.   	$ mkdir nuirun

c.	$ cp -r nui/Tizen.NUI/src nuirun
~~~

Overwrite *NUIApplication.cs* and *CoreApplication.cs* files in ~/DALiNUI/nuirun/src/public with
the same named files in this gerithub repositry (TBD).

_This step is necessary as NUI In Ubuntu is not fully supported just yet._

+ Build NUI with VSC with a console hello world

Follow this tutorial: [](https://docs.microsoft.com/en-us-dotnet/csharp/getting-started/with-visual-studio-code)

This tutorial will give a basic understanding of using VSC and will create a console Hello world.

+ Build NUI with VSC with a UI hello world

Create new project in VSC, add code in (_full example_) code in ![](./hello-world.md).

[Back to top](#0)

