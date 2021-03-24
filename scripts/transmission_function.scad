// transmission function estimation

// this script displays cubes with various colors on screen.
// horizontal axis is hue, 0 ... 360 in steps of 10 degree
// vertical axis is saturation, 0.20 ... 1.00 in steps of 0.2

// measure transmission function of filter this way:
// look through left (red) filter of 3D anaglyph glasses.
// for every column, mark the lowest square which is invisible.
// this gives the transmission function for the left (red) filter.
// repeat for right (cyan) filter.

// set viewport
$vpt=[275, 50, 5];
$vpr=[0, 0, 0];
$vpd=1000;

function hsv(h, s, v) = hsv1(h/360,s/100,v/100, 1);
function hsv1(h, s = 1, v = 1, a = 1, p, q, t) = (p == undef || q == undef || t == undef) // by LightAtPlay
	? hsv1(
		(h%1) * 6,
		s<0?0:s>1?1:s,
		v<0?0:v>1?1:v,
		a,
		(v<0?0:v>1?1:v) * (1 - (s<0?0:s>1?1:s)),
		(v<0?0:v>1?1:v) * (1 - (s<0?0:s>1?1:s) * ((h%1)*6-floor((h%1)*6))),
		(v<0?0:v>1?1:v) * (1 - (s<0?0:s>1?1:s) * (1 - ((h%1)*6-floor((h%1)*6))))
	)
	:
	h < 1 ? [v,t,p,a] :
	h < 2 ? [q,v,p,a] :
	h < 3 ? [p,v,t,a] :
	h < 4 ? [p,q,v,a] :
	h < 5 ? [t,p,v,a] :
	        [v,p,q,a];

// x axis is hue, y axis is saturation
for (h = [0:10:360]) {
  for (s = [20:20:100]) {
    translate([h*1.5, s/20*15, 0])
    color(hsv(h, s, 100))
    cube(10);
  }
}

// draw 5% grey background
translate([-10, 5, -20])
color(hsv(0, 0, 95))
cube([38*15, 6*15, 10]); 
// not truncated
