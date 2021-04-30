
# OpenSCAD with 3D glasses

![Reel3D No. 7020 plastic flip-up clip-on](images/anaglyph_glasses.gif)

## Build notes

These are build notes on compiling [OpenSCAD](http://www.openscad.org) to an [AppImage](http://www.appimage.org) on a [raspberry pi 4](https://www.raspberrypi.org) running 2020-08-20-raspios-buster-arm64.

### Install build dependencies

```
sudo apt-get upgrade
sudo apt-get install cmake gawk bison flex gettext itstool libcgal-dev libeigen3-dev libfontconfig1-dev libharfbuzz-dev libopengl-dev libglew-dev libopencsg-dev libxml2-dev libboost-all-dev libzip-dev libcairo2-dev lib3mf-dev libqscintilla2-qt5-dev qtmultimedia5-dev imagemagick libqt5gamepad5-dev libhidapi-dev libspnav-dev libdouble-conversion-dev qt5-default
```
### Download sources

```
git clone http://github.com/koendv/openscad
cd openscad
git submodule update --init
```
### Build openscad
First check all dependencies are installed:

```
source ./scripts/setenv-unibuild.sh
./scripts/check-dependencies.sh
```
Check the output of *check-dependencies* is "OK", then build:
```
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make -j4
```
### Create appimage

The AppImage contains the application, and all shared libraries and files needed to run the application.

Copy openSCAD binaries to appimage:
```
export INSTALL_ROOT=$HOME/OpenSCAD-aarch64.AppDir
mkdir $INSTALL_ROOT
make install DESTDIR=$INSTALL_ROOT
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
X-AppImage-Version=2021.02.25
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

### 32-bit version

The 32-bit version for Raspberry Pi OS 2021-03-04-raspios-buster-armhf. It differs in that Qt5, lib3mf and QScintilla have been [compiled from source](https://github.com/koendv/qt5-opengl-raspberrypi). Configuration command line:
```
export QT_SELECT=qt5.15.2-opengl
qmake openscad.pro "PREFIX=/usr" "LIB3MF_INCLUDEPATH=/usr/include/Bindings/Cpp"  "LIB3MF_LIBPATH=-l3mf -lzip -lz"
```

## Editing an AppImage

If you wish to edit, add or remove a file in an existing AppImage, there is no need to recompile. Simply extract the file tree from the AppImage, edit, test and re-package:

```
$ OpenSCAD.AppImage --appimage-extract
$ gedit squashfs-root/usr/share/openscad/color-schemes/render/redcyanglasses.json
$ ./squashfs-root/AppRun
$ appimagetool.AppImage squashfs-root/ OpenSCAD-new.AppImage
```
## Links

- [Rendering 3D Anaglyph in OpenGL](https://quiescentspark.blogspot.com/2011/05/rendering-3d-anaglyph-in-opengl.html) - Geometry calculations used in file ``GLView.cc``, method ``GLView::setup3dCamera()``
- [Calculating Stereo Pairs](http://paulbourke.net/stereographics/stereorender/) - How to render and how not to.
- [Producing Anaglyphs from Synthetic Images](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.7.6968&rep=rep1&type=pdf#page=4) -  The coefficients used in file ``colormap.cc``, method ``ColorMap::anaglyphColor()``, are on page 4.
- [Pull Request](https://github.com/openscad/openscad/pull/3693) at openscad. Contribute to the source code.

## Credits
After a patch by Josef Pavlik
