---
layout: default
title: Tracing
---
[ Home Page ]({{site.baseurl}}/index) <br>

# Tracing[](#top)

DALi provides a tracing mechanism which allows developers to optimize application performance by measuring and visualizing intrumented function calls. It aids in the understanding of where the systems is spending most of its time while an application is running.

## [](#addTrace)Adding Tracing To Code

Some Macros have been provided to make adding tracing to the code much simpler.

* To add tracing to code, include the DALi trace header file:
```c++
#include <dali/integration-api/trace.h>
```
* Then initialize the tracing filter at the beginnning of the file.
```c++
DALI_INIT_TRACE_FILTER( gFilter, "UPDATE_MANAGER_TRACE", false );
```
  - Here, **gFilter** is just the name of your trace filter, it is created in an anonymous namespace.  
  - **UPDATE_MANAGER_TRACE** is the environment variable that can be used to enable/disable this tracing filter at runtime (only if libraries are built with tracing enabled).  
  - The final parameter is whether the tracing is enabled or disabled by default. Checked in code should, ideally have this disabled by default. It can be enabled via the environment-variable at runtime.
* To trace a particular piece of code, use the **DALI_TRACE_BEGIN** and **DALI_TRACE_END** macros:
```c++
  void UpdateManager::Update()
  {
    DALI_TRACE_BEGIN( gFilter, "UPDATE" );

    ... // Code to do the Update

    DALI_TRACE_END( gFilter, "UPDATE" );
  }
```
* **DALI_TRACE_SCOPE** is also provided where tracing is just required within a particular scope. This can be used as an alternative to the begin and end macros.

## [](#building)Building DALi with Tracing Enabled

### [](#buildingUbuntu)Ubuntu

* Add **\--enable-trace** & **\--enable-networklogging** to **./configure** when building DALi Core, Adaptor and, if required, Toolkit.

### [](#buildingTizen)Tizen

* When doing a GBS build add **\--define "enable_trace 1"** to the **gbs build** command, e.g:
```
gbs build -A armv7l --define "enable_trace 1"
```

## [](#running)Running

### [](#runningUbuntu)Ubuntu

* Enable network control using the environment variable:
```
export DALI_NETWORK_CONTROL=1
```
* Then run the DALi application as follows, enabling the environment variable of the trace filter required:
```
UPDATE_MANAGER_TRACE=1 dali-demo
```
* In another terminal run the following commands while the DALi application is running:
```
nc localhost 3031
set_marker 255
```
* The is an example of the output generated on UBUNTU:
```
4597695.809673 (seconds), UPDATE_START
4597695.810460 (seconds), UPDATE_END
4597695.832570 (seconds), UPDATE_START
4597695.833282 (seconds), UPDATE_END
4597695.843046 (seconds), UPDATE_START
4597695.843849 (seconds), UPDATE_END
```

### [](#runningTizen)Tizen

TTrace is used on Tizen for tracing. More information about TTrace can be found [here](https://developer.tizen.org/development/tizen-studio/native-tools/debugging-your-app/t-trace).

You need Tizen Studio on your machine to run TTrace. You can download it from [here](https://developer.tizen.org/development/tizen-studio/download).

To run and view the tracing output, follow the steps below:

* After installing the trace-enabled libraries on target, modify the profile startup script, for mobile this is **/etc/profile.d/efl_mobile.sh**, and add the lines to export the tracing envrionemnt variables required:
```
export UPDATE_MANAGER_TRACE=1
```
* Restart the Tizen device.
* Then run the application that requires tracing.
* While the DALi application is running on the Tizen target, and the device is connected, run the following command on your machine:
```
~/tizen-studio/tools/ttrace/ttrace.py -t 15 -b 40000 -o page.html
```
  This will save 15 seconds with a 40KB buffer size to **page.html**.

* You can view the generated HTML file with **Chrome**. An example of the output generated is shown below:
  ![TTrace Output](https://developer.tizen.org/sites/default/files/images/ttrace_viewer.png)  
  **PLEASE NOTE:** The html only seems to work with Chrome.

## [](#enablingAllTracing)Enabling All Tracing

If enabling all tracing is required, then follow the following steps:

* Ensure TRACE_ENABLED is defined when building the application i.e. **-DTRACE_ENABLED**.
* Add the trace header file to the application source file.
```c++
#include <dali/integration-api/trace.h>
```
* In your **main** function call the following function:
```c++
Dali::Integration::Trace::Filter::EnableGlobalTrace();
```

[Back to top](#top)
