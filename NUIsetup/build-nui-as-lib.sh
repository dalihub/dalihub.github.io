#!/bin/bash

# Simple script to build nui as a library
# Expect this to be invoked in the root folder of 'nui' repository

if ! grep -q Tizen.NUI.Code .gitignore ; then
    echo "Tizen.NUI.Code/" >> .gitignore
fi
mkdir -p Tizen.NUI.Code
if ! [ -h Tizen.NUI.Code/src ] ; then
    ln -s ../Tizen.NUI/src Tizen.NUI.Code/src
fi
if ! [ -f Tizen.NUI.Code/Tizen.NUI.csproj ] ; then

    cat > Tizen.NUI.Code/Tizen.NUI.csproj <<"EOF"
<Project Sdk="Microsoft.NET.Sdk">
  <ItemGroup>
    <ProjectReference Include="../../app-stub/Tizen.Applications.csproj"/>
  </ItemGroup>

  <PropertyGroup>
    <OutputType>Library</OutputType>
    <DefineConstants>DOT_NET_CORE</DefineConstants>
    <TargetFramework>netcoreapp1.1</TargetFramework>
  </PropertyGroup>
</Project>
EOF

fi

cd Tizen.NUI.Code
dotnet restore
dotnet build
