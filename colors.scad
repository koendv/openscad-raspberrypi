// by LightAtPlay
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

// hue, saturation, and luminosity values
hval = [60, 75, 90, 270, 285, 300];
sval = [0, 25, 50, 75, 100];
vval = [50, 75, 100];

for (h = [0:5]) {
    for (s = [0:4]) {
        for (v = [0:2]) {
            translate([h*20, s*20, v*20])
            color(hsv1(hval[h],sval[s],vval[v]))
            cube(10, center=true);
        }
    }
}
