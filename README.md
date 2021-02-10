
# OpenSCAD w/ 3D

![Reel3D No. 7020 plastic flip-up clip-on](images/anaglyph_glasses.gif)

This is the OpenSCAD CAD editor, compiled for raspberry pi, with support for showing your designs in 3D when viewed with anaglyph 3D glasses. Anaglyph 3D glasses are glasses with red and cyan colored lenses.

## Sample screen

[![screenshot](images/openscad_screenshot_big.png)](https://raw.githubusercontent.com/koendv/openscad-raspberrypi/master/images/openscad_screenshot_big.png)

You need red/cyan colored glasses to see the 3D effect.

## Downloads

- [Binary](https://github.com/koendv/openscad-raspberrypi/releases) for raspberry pi.
- [Patch](https://raw.githubusercontent.com/koendv/openscad-raspberrypi/master/anaglyph.patch) for compiling openscad with support for 3D glasses

## Usage

- Start OpenSCAD and load your .scad source file.

- Choose the "Ash" color scheme to get monochrome gray output. From the menu, choose *Edit->Preferences->3D View*.
Select color scheme "Ash".

- Click the render icon ![render](images/render-32.png) to render your object.

- Click the 3D glasses icon ![anaglyph](images/Anaglyph-32.png) to toggle stereo mode.

- Press *Ctrl* and rotate the mouse scroll wheel to adjust the eye separation. Too little eye separation and the 3D effect disappears; too much and you get eyestrain. Adjust for your viewing comfort.

## Notes

An anaglyph codes depth information using color. The algorithm used here works fine for objects that are gray or pastel color, but not for saturated colors. But for many simple tasks, grayscale is sufficient. 

Algorithms for full-color anaglyphs exist, e.g. [Dubois filtering](http://www.site.uottawa.ca/~edubois/anaglyph/). Dubois filtering maps colors to colors that do not clash with the 3D glasses. Implementing Dubois filtering in OpenGL requires rendering left and right images to textures, and a fragment shader that uses these textures as input. For the moment being, I'll use graytones.

When viewing, you may wish to set "Show axes" to off, as it's jarring if an axis protrudes from the screen and points straight at you. In general, objects "behind" the screen are easier on the eye than objects that "stick out"
from the screen.

## Build notes

These are build notes on compiling [OpenSCAD-2020.02](http://www.openscad.org) to an [AppImage](http://www.appimage.org) on a [raspberry pi 4](https://www.raspberrypi.org) running 2020-08-20-raspios-buster-arm64.

### Install build dependencies

```
sudo apt-get upgrade
sudo apt-get install cmake gawk bison flex gettext itstool libcgal-dev libeigen3-dev libfontconfig1-dev libharfbuzz-dev libopengl-dev libglew-dev libopencsg-dev libxml2-dev libboost-all-dev libzip-dev libcairo2-dev lib3mf-dev libqscintilla2-qt5-dev qtmultimedia5-dev imagemagick libqt5gamepad5-dev libhidapi-dev libspnav-dev libdouble-conversion-dev qt5-default
```
### Download sources

```
git clone http://github.com/openscad/openscad
cd openscad
git submodule update --init
```
### Patch for 3D anaglyph
Download patch and icon

```
wget https://raw.githubusercontent.com/koendv/openscad-raspberrypi/master/anaglyph.patch
wget https://github.com/koendv/openscad-raspberrypi/raw/master/images/Anaglyph-32.png
patch -p1 < anaglyph.patch
cp Anaglyph-32.png images/
```
### Build openscad
First check all dependencies are installed:

```
source ./scripts/setenv-unibuild.sh
./scripts/check-dependencies.sh
```
Check the output of *check-dependencies* is "OK", then build:
```
qmake openscad.pro "PREFIX=/usr"
make -j4
```
### Create appimage

The AppImage contains the application, and all shared libraries and files needed to run the application.

Copy openSCAD binaries to appimage:
```
export INSTALL_ROOT=$HOME/OpenSCAD-aarch64.AppDir
mkdir $INSTALL_ROOT
make install
```
Copy Qt translations:
```
(cd /; tar cvhf - usr/share/qt5/translations/) | (cd $INSTALL_ROOT; tar xvpf -)
```
Copy openSCAD library dependencies to AppImage.
First make a list of all shared libraries used by openscad, then copy these libraries to the AppImage directory.

```
mkdir $INSTALL_ROOT/usr/lib/
cd $INSTALL_ROOT
LIBS=$(ldd usr/bin/openscad | sed -e 's/^.* => //' -e 's/ (0x.*$//' | grep '/usr/')
for L in $LIBS
do
  cp --preserve $L $INSTALL_ROOT/usr/lib/
done
```
If the app uses any Qt plugins, the plugins would need to be copied too, just like any other shared library.

Copy AppImage files:

From `https://github.com/AppImage/AppImageKit/releases/` download `AppRun-aarch64`.
```
cp ~/Downloads/AppRun-aarch64 $INSTALL_ROOT/AppRun
chmod a+x $INSTALL_ROOT/AppRun
```
Copy desktop shortcut and icon:
```
cd $INSTALL_ROOT
cp usr/share/icons/hicolor/256x256/apps/openscad.png .
cp usr/share/applications/openscad.desktop .
```
Edit openscad.desktop and add X-AppImage-Version version info:
```
[Desktop Entry]
Type=Application
Version=1.0
Name=OpenSCAD
Icon=openscad
Exec=openscad %f
MimeType=application/x-openscad;
Categories=Graphics;3DGraphics;Engineering;
Keywords=3d;solid;geometry;csg;model;stl;
X-AppImage-Version=2021.02.09
```
Create AppStream metadata:
```
cd $INSTALL_ROOT/usr/share/metainfo/
cp org.openscad.OpenSCAD.appdata.xml openscad.appdata.xml
```
From `https://github.com/AppImage/AppImageKit/releases/` download `appimagetool-aarch64.AppImage`. Create AppImage:
```
cd $INSTALL_ROOT/..
appimagetool-aarch64.AppImage $INSTALL_ROOT
```
Test AppImage:
```
./OpenSCAD-aarch64.AppImage
```
Run the AppImage on a clean install of the operating system to check all dependencies have been caught.
## Credits
After a patch by Josef Pavlik
