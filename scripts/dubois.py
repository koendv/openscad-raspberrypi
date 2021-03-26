import colorsys
import math

# python3 ./dubois.py > dubois.csv
# for hue:
# gnuplot
#   set datafile separator ','
#   set title "Dubois Shading"
#   set xlabel "hue before"
#   set ylabel "hue after"
#   set xrange [-50:400]
#   set yrange [0:450]
#   plot "dubois.csv" using 1:2 with lines title "dubois", "dubois.csv" using 1:3 with lines title "piecewise linear"
# for saturation:
# gnuplot
#   set datafile separator ','
#   set title "Dubois Shading"
#   set xlabel "hue"
#   set ylabel "saturation"
#   set xrange [0:360]
#   set yrange [0:105]
#   plot "dubois.csv" using 1:4 with lines notitle
# for value:
# gnuplot
#   set datafile separator ','
#   set title "Dubois Shading"
#   set xlabel "hue"
#   set ylabel "value"
#   set xrange [0:360]
#   set yrange [0:105]
#   plot "dubois.csv" using 1:5 with lines notitle
# for luminance:
# gnuplot
#   set datafile separator ','
#   set title "Dubois Shading"
#   set xlabel "hue"
#   set ylabel "luminance"
#   set xrange [0:360]
#   set yrange [0:100]
#   plot "dubois.csv" using 1:6 with lines title "before", "dubois.csv" using 1:7 with lines title "after"

hue0 = 75
slope0 = 67/360
sat0 = 0.28
pi = 3.1415926535

def dubois(c_in):
  r = (0.4561   -.0434706)*c_in[0]+ ( .500484 -.0879388)*c_in[1]+( .176381  -0.00155529)*c_in[2];
  g = (-.0400822+.378476) *c_in[0]+ (-.0378246+.73364)  *c_in[1]+(-.0157589  -.0184503) *c_in[2];
  b = (-.0152161-.0721527)*c_in[0]+ (-.0205971-.112961) *c_in[1]+(-.00546856+1.2264)    *c_in[2];
  r=max(0,min(r,1))
  g=max(0,min(g,1))
  b=max(0,min(b,1))
  return (r, g, b)

def luminance(c):
  r = c[0]
  g = c[1]
  b = c[2]
  return math.sqrt( 0.299*r*r + 0.587*g*g + 0.114*b*b )

def newhue(h):
  hin = (h + 90 - hue0) % 360
  if (hin <= 180):
    hout = slope0 * (hin - 90) + hue0
  else:
    hout = slope0 * (hin - 270) + hue0 + 180
  return hout

def newsat(h, s):
  hin = (h + 90 - hue0) % 180
  f = (90 - hin) / 90
  satout =  s * (sat0 + (1 - sat0) * (1 - f*f))
  return satout

for h10 in range(-150, 3600):
  h = h10/10
  rgb1 = colorsys.hsv_to_rgb(h/360.0, 1, 1)
  rgb2 = dubois(rgb1)
  hsv2 = colorsys.rgb_to_hsv(rgb2[0], rgb2[1], rgb2[2])
  hue2 = hsv2[0]
  sat2 = hsv2[1]
  val2 = hsv2[2]
  nh = newhue(h)
  lum1 = luminance(rgb1)
  lum2 = luminance(rgb2)
  print(h10/10, ",", hue2*360, "," , nh, ",", sat2 * 100, ",", val2 * 100, ",", lum1 * 100, ",", lum2 * 100)

