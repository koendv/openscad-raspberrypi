
# OpenSCAD with 3D glasses

![Reel3D No. 7020 plastic flip-up clip-on](images/anaglyph_glasses.gif)

This is the OpenSCAD CAD modeller, compiled for raspberry pi, with support for showing your designs in 3D when viewed with anaglyph 3D glasses. The anaglyph 3D glasses used are glasses with red and cyan colored lenses.

## Sample screen

[![screenshot](images/openscad_screenshot_big.png)](https://raw.githubusercontent.com/koendv/openscad-raspberrypi/master/images/openscad_screenshot_big.png)

You need red/cyan colored glasses to see the 3D effect.

## Downloads

- [Binaries](https://github.com/koendv/openscad-raspberrypi/releases) for raspberry pi and others.
- [Patch](https://raw.githubusercontent.com/koendv/openscad-raspberrypi/master/anaglyph.patch) and [icon](images/Anaglyph-32.png) for compiling openscad with support for 3D glasses.

If you like this, maybe you want to buy me a cup of tea:

[![ko-fi](images/kofibutton.svg)](https://ko-fi.com/Q5Q03LPDQ)
## Usage

A walk-through that shows how to see a model in anaglyph 3D.

- Start OpenSCAD and load your .scad source file. As an example, we will render the OpenSCAD logo. From the menu, choose *File->Examples->Basics->logo.scad*.

- Choose the "3D Glasses" color scheme. From the menu, choose *Edit->Preferences->3D View*.
Select color scheme "3D Glasses".

- Switch axis ![axes](images/blackaxes.png) off.  The mind rebels if an axis sticks out of the screen, coming straight at you. Also, objects "behind" the screen are easier on the eye than objects that "stick out" from the screen.

- Click the render icon ![render](images/render-32.png) to render your object. There are two buttons to display your model: preview and render. Preview ![render](images/preview-32.png) renders fast, colors and transparencies are preserved, but rotating the 3D model is somewhat sluggish. Render ![render](images/render-32.png) renders slower, colors and transparencies are lost, but rotating the model is fluid, and the rendering output can be written to an STL file for 3D printing.

- Reset view ![reset view](images/Command-Reset-32.png) and zoom out ![view all](images/zoom-all.png) so the whole object is visible.

- Put 3D glasses on.

- Click the 3D glasses icon ![anaglyph](images/Anaglyph-32.png) to toggle stereo mode.

- Press *Ctrl* and rotate the mouse scroll wheel to adjust the eye separation. Too little eye separation and the 3D effect disappears; too much and you get eyestrain. Adjust for your viewing comfort.

## Programming

When programming OpenSCAD, the built-in variable $anaglyph is true when rendering in 3d anaglyph mode, false otherwise.  You can use this variable in your OpenSCAD scripts.
 
## Which colors are suitable for anaglyph 3D?

[![colorwheel](images/colorwheel.png)](https://raw.githubusercontent.com/koendv/openscad-raspberrypi/master/images/colorwheel.svg)

This color wheel shows all colors of the rainbow. The numbers are the color [hue](https://en.wikipedia.org/wiki/HSL_and_HSV), a number from 0 to 360. 

The glasses used to see 3D anaglyphs have red lenses for the left eye, and cyan (blue-green) lenses for the right eye. Red (hue 0) and cyan (hue 180) are complementary colours. Complementary colours are in opposite positions on the colour wheel.

To see depth, both eyes need to see an image. If you look at a color wheel through 3D glasses, blue-green colors appear dark through the red lens; red colors appear dark through the cyan lens. If an object has pure red or cyan color, the depth illusion will fail because only one eye gets an image. Colors most suitable for anaglyph are a mix of red and cyan; this way both left and right eye see an image. These colors include grey, green (hue around 75) and purple (hue around 285). To some degree colors are subjective, and what colors to use is dependent upon the combination of display and 3D glasses used.

Apart from hue, saturation also plays a role. If a color has strong green but weak red, the green may be so strong that it persists even after filtering through the cyan lens. The eye then sees two images superimposed. This is called *ghosting*. To lessen this effect, saturated colors should be avoided.

## Color Schemes

Two color schemes are provided. The color scheme "Ash" uses grey colors for the object, and green for the highlights. The color scheme "3D Glasses" uses green for the object, and purple for the highlight. Because colors are a matter of personal taste, a small [python script](gencolorscheme.py) is included to allow adapting the color scheme.

The ideal color scheme depends upon display and glasses used. If you wanted to print anaglyphs, the ideal colors might be slightly different. To determine which colors are best, you might want to print a color wheel and look at the printed color wheel, once through the left lens, and once through the right lens, and this way choose the colors to use.

## Dubois shading

![Dubois shading](images/dubois.png)

[Dubois shading](http://www.site.uottawa.ca/~edubois/anaglyph/) is an algorithm that replaces all colors with the closest color suitable for anaglyphs. The picture above shows on the inside a color wheel, and on the outside what the same colors look like after Dubois shading. Notice how red and cyan change. Also, after applying Dubois filtering, colors are less saturated, more "washed out".

The Dubois algorithm is designed to make 3D anaglyphs from two photographs. To make an anaglyph from two photographs, the Dubois algorithm iterates over all pixels, and does a matrix multiplication of a 3x6 matrix with a 6x1 vector for every pixel. 

However, in OpenSCAD we are not taking pictures; we are *generating* pictures. OpenSCAD renders your model with the color scheme chosen in *Edit->Preferences->3D View->Color Scheme*. A color scheme includes surface front and back color, edge color, background color, highlight color. Instead of changing the color of millions of pixels of the rendered model, it is faster to only change the small number of colors of the color scheme. In OpenSCAD 3D anaglyph mode, the colors of the color scheme, and the arguments of *color()* instructions in user scripts, are changed in a way similar to the Dubois algorithm.

Comparing both, the Dubois algorithm is applied to the pixels after rendering. The algorithm used here in OpenSCAD is applied to the color before rendering. The advantage is a savings of tens of millions of multiplications and additions per frame.

A small walkthrough to see the algorithm at work:

- Start OpenSCAD. From the file menu, choose *File->Examples->Basics->rotate_extrude.scad*. 

- Choose perspective view ![perspective view](images/perspective1.png) and preview ![render](images/preview-32.png). Reset view ![reset view](images/Command-Reset-32.png) and zoom out ![view all](images/zoom-all.png). Note four objects with saturated colors - red, cyan, green and purple. 

- Click the 3D glasses icon ![anaglyph](images/Anaglyph-32.png) to toggle stereo mode. Look using 3D glasses. Note the objects in saturated red and cyan are difficult to see in 3D. The object in green does not have this problem. [Screenshot before Dubois](images/before_dubois.png)

- Click preview ![render](images/preview-32.png) again. Because OpenSCAD is in anaglyph mode, the model is rendered with Dubois colors. The colors are changed, especially red and cyan, and now all four objects are easily viewed in 3D. [Screenshot after Dubois](images/after_dubois.png)

- Click perspective view ![perspective view](images/perspective1.png) to return to normal 2D view and preview ![render](images/preview-32.png) to restore normal colors.

The color scheme is updated automatically when changing to/from 3D view. Clicking preview to update the colors is only necessary if the OpenSCAD script contains *color()* instructions.

## Build notes

These are build notes on compiling [OpenSCAD](http://www.openscad.org) to an [AppImage](http://www.appimage.org) on a [raspberry pi 4](https://www.raspberrypi.org) running 2020-08-20-raspios-buster-arm64.

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

The 32-bit version for Raspberry Pi OS 2021-01-11-raspios-buster-armhf differs in that Qt5, lib3mf and QScintilla have been [compiled from source](https://github.com/koendv/qt5-opengl-raspberrypi). Configuration command line:
```
export QT_SELECT=qt5.15.2-opengl
qmake openscad.pro "PREFIX=/usr" "LIB3MF_INCLUDEPATH=/usr/include/Bindings/Cpp"  "LIB3MF_LIBPATH=-l3mf -lzip -lz"
```
or. if using cmake, 
```
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DLIB3MF_INCLUDE_DIRS=/usr/include/Bindings/Cpp "-DLIB3MF_LIBRARIES=-l3mf -lzip -lz" ..
```

## Credits
After a patch by Josef Pavlik
