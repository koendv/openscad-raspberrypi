#!/usr/bin/python3
# print openscad color scheme

import colorsys

# print rgb as hex string
# r=0..255, g=0..255, b=0.255
def rgb(r, g, b):
  hexval = hex(256*256*256+r*256*256+g*256+b)
  return hexval[3:9]

# print rgb as hex string
# h=0..360, s=0..100, v=0..100
def hsv(h, s, v):
  color = tuple(int(round(i * 255)) for i in colorsys.hsv_to_rgb(h/360.0,s/100.0,v/100.0))
  return rgb(color[0], color[1], color[2])

# color scheme
background =         rgb(255,255,255)
highlight =          hsv(0,0,20)
axes_color =         hsv(290,50,100)
opencsg_face_front = hsv(75,50,100)
opencsg_face_back =  hsv(285,50,100)
cgal_face_front =    hsv(75,50,100)
cgal_face_back =     hsv(285,50,100)
cgal_face_2d =       hsv(90,50,100)
cgal_edge_front =    hsv(75,50,100)
cgal_edge_back =     hsv(290,50,100)
cgal_edge_2d =       hsv(275,50,100)
crosshair =          hsv(290,50,50)

print (f'''{{
    "name" : "3D Glasses",
    "index" : 2001,
    "show-in-gui" : true,
    "description" : "3d anaglyph",
    "_comment" : "created by gencolorscheme.py",

    "colors" : {{
        "background" :         "#{background}",
        "highlight" :          "#{highlight}80",
        "axes-color" :         "#{axes_color}",
        "opencsg-face-front" : "#{opencsg_face_front}",
        "opencsg-face-back" :  "#{opencsg_face_back}",
        "cgal-face-front" :    "#{cgal_face_front}",
        "cgal-face-back" :     "#{cgal_face_back}",
        "cgal-face-2d" :       "#{cgal_face_2d}",
        "cgal-edge-front" :    "#{cgal_edge_front}",
        "cgal-edge-back" :     "#{cgal_edge_back}",
        "cgal-edge-2d" :       "#{cgal_edge_2d}",
        "crosshair" :          "#{crosshair}"
    }}
}}''')

#not truncated
