# OpenSCAD on Raspberry Pi Build Notes

These are build notes on compiling [OpenSCAD-2019.05](http://www.openscad.org) to an [AppImage](http://www.appimage.org) on a [raspberry pi 4](https://www.raspberrypi.org) running 2019-07-10-raspbian-buster-full.
You can download the binary [here](https://github.com/koendv/openscad-raspberrypi/releases/download/v1.0/OpenSCAD-2019.05-armhf.AppImage).

## Install build dependencies
```
sudo apt-get install cmake gawk bison flex gettext itstool libqt4-opengl-dev libboost-all-dev libxmu-dev libxi-dev libzip-dev libxml2-dev libfontconfig1-dev libharfbuzz-dev uuid-dev libglew-dev libxml2-dev ragel libqscintilla2-qt4-dev libdouble-conversion-dev libcgal-dev libeigen3-dev libopencsg-dev
```
### Install lib3MF from source
lib3mf-dev is missing from raspbian. Compile from source, and install in /usr .
```
git clone https://github.com/3MFConsortium/lib3mf.git
cd lib3mf
git submodule init
git submodule update --init
cmake -DCMAKE_INSTALL_PREFIX=/usr
make
sudo make install
```
## Build openscad
```
tar xvf openscad-2019.05.src.tar.gz
cd openscad-2019.05
source ./scripts/setenv-unibuild.sh
./scripts/check-dependencies.sh
```
Output of `check-dependencies.sh`:
```
koen@raspberrypi:~/src/openscad-2019.05 $ ./scripts/check-dependencies.sh
depname           minimum           found             OKness
qt                4.4               4.8.7             OK
qscintilla2       2.7               2.10.4            OK
cgal              3.6               4.13              OK
gmp               5.0               6.1.2             OK
mpfr              3.0               4.0.2             OK
boost             1.35              1.67              OK
opencsg           1.3.2             1.4.2             OK
glew              1.5.4             1.7.0             OK
eigen             3.0               3.3.7             OK
glib2             2.0               2.58.3            OK
fontconfig        2.10              2.13.             OK
freetype2         2.4               2.9.1             OK
harfbuzz          0.9.19            2.3.1             OK
libzip            0.10.1            1.5.1             OK
bison             2.4               3.3.2             OK
flex              2.5.35            2.6.4             OK
make              3                 4.2.1             OK
double-conversion 2.0.1             2.0.1             OK
```
Build:
```
qmake-qt4 openscad.pro "PREFIX=/usr"
make
```
When using Qt4, before running `make` edit the Makefile: in the line `LIBS =` remove `-lQtMultimedia`. Else `make` fails with the message `/usr/bin/ld: cannot find -lQtMultimedia`.

## Create AppImage
The AppImage contains the application (here: openscad), all shared libraries and config files needed to run the application.

Copy openSCAD binaries to appimage:
```
export INSTALL_ROOT=/home/koen/src/OpenSCAD-2019.05-armhf.AppDir
mkdir $INSTALL_ROOT
make install

```
Copy Qt translations:
```
(cd /; tar cvhf - usr/share/qt4/translations/) | (cd $INSTALL_ROOT; tar xvpf -)
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

From `https://github.com/AppImage/AppImageKit/releases/` download `AppRun-armhf`.
```
cp ~/Downloads/AppRun-armhf $INSTALL_ROOT/AppRun
chmod a+x $INSTALL_ROOT/AppRun

```
Copy desktop shortcut and icon:
```
cd $INSTALL_ROOT
cp usr/share/pixmaps/openscad.png .
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
X-AppImage-Version=2019.05
```
Create AppStream metadata:
```
cd $INSTALL_ROOT/usr/share/metainfo/
cp org.openscad.OpenSCAD.appdata.xml openscad.appdata.xml
```
Create AppImage:
```
cd $INSTALL_ROOT/..
appimagetool-armhf.AppImage $INSTALL_ROOT
```
Test AppImage:
```
./OpenSCAD-armhf.AppImage
```
Run the AppImage on a clean install of the operating system to check all dependencies have been caught.

# Debugging
In case of shared library problems, try comparing the output of
```
LD_DEBUG=libs ./OpenSCAD-armhf.AppImage
```
with the output of
```
LD_DEBUG=libs ./openscad
```
