// color wheel
$fn=64;
text_h = 2.5;

function hsv(h, s = 1, v = 1, a = 1, p, q, t) = (p == undef || q == undef || t == undef)
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

module small_text(txt, algn) {
    linear_extrude(text_h) text(txt, font="FreeSans:style=Bold", size = 6, halign = algn, valign = "center");
}

module colorwheel() { 
    for (h = [0:15:359]) {
                    rotate([0,0,h]) {
                    translate([60, 0, 0])
                    color(hsv1(h, 100, 100))
                    cube(12, center=true);
                    translate([75,0,0])
                    rotate([0,0,-h])
                    color("Black")
                    small_text(str(h),"center");
                }
    }
    
    color("Black")
    difference() {
        difference() {
            circle(r = 91);
            circle(r = 89);
        }
        hull() {
            rotate([0,0,45])
            square([200,1]);
            rotate([0,0,75])
            square([200,1]);
        }
        hull() {
            rotate([0,0,285])
            square([200,1]);
            rotate([0,0,315])
            square([200,1]);
        }
    }
    
    color("Black")
    translate([-100,0,0])
    small_text("Dark in red lens","right");
    
    color("Black")
    translate([100,0,0])
    small_text("Dark in cyan lens","left");
    
    color("Black")
    translate([0, -100,0])
    small_text("Color wheel with hue numbers","center");
}

colorwheel();