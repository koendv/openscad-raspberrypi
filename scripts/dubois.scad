
text_h=2.5;

function hsv(h, s = 1, v = 1, a = 1, p, q, t) = (p == undef || q == undef || t == undef) // by LightAtPlay
	? hsv(
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

function hsv1(h, s, v) = hsv(h/360,s/100,v/100);

// dubois anaglyph shading
// (rl, gl, rl) is left image color
// (rr, gr, rr) is right image color

function dubois(rl, gl, bl, rr, gr, br) = [
  max(0, min(1, 0.4154*rl+0.4710*gl+0.1669*bl-0.0109*rr-0.0364*gr-0.0060*br)),
  max(0, min(1, -0.0458*rl-0.0484*gl-0.0257*bl+0.3756*rr+0.7333*gr+0.0111*br)),
  max(0, min(1, -0.0547*rl-0.0615*gl+0.0128*bl-0.0651*rr-0.1287*gr+1.2971*br))
];

function dubois1(c) = dubois(c[0], c[1], c[2], c[0], c[1], c[2]);

module small_text(txt, algn) {
    linear_extrude(text_h) text(txt, font="FreeSans:style=Bold", size = 6, halign = algn, valign = "center");
}

// color wheel
for (h = [0:15:359]) {
    // original color
    rotate([0, 0, h])
    translate([50,0,0])
    color(hsv1(h,100,100))
    cube(10, center=true);
    // dubois
    rotate([0, 0, h])
    translate([65,0,0])
    color(dubois1(hsv1(h,100,100)))
    cube(10, center=true);
    // label
    rotate([0, 0, h])
    translate([80,0,0])
    rotate([0,0,-h])
    color("Black")
    small_text(str(h),"center");

}
