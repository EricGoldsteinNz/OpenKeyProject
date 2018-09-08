// Original Key by Nirav Patel <http://eclecti.cc>
// This work is licensed under a Creative Commons Attribution 3.0 Unported License.

//The measurements used below are from the center of the key to the cut. All measurements are in mm. 
//(this is just a reference table to help pick cuts below)
//0:0 = .335"
//1:1 = .320"
//2:2 = .305"
//3:3 = .290"
//4:4 = .275"
//5:5 = .260"
//6:6 = .245"
//7:7 = .230"
//8:8 = .215"
//9:9 = .200"

//(cut at the handle of key)
cut_1 = 0; //[0:9] Don't change cut_1, currently it fixes a shoulder issue.
cut_2 = 70; //[0:9] 6.30mm
cut_3 = 130; //[0:9] 5.70mm
cut_4 = 180; //[0:9] 5.20mm
cut_5 = 180; //[0:9] 5.20mm
//(cut at the tip of key)


function mm(i) = i*25.4;
$fn=30;

module rounded(size, r) {
  union() {
    translate([r, 0, 0]) cube([size[0]-2*r, size[1], size[2]]);
    translate([0, r, 0]) cube([size[0], size[1]-2*r, size[2]]);
    translate([r, r, 0]) cylinder(h=size[2], r=r);
    translate([size[0]-r, r, 0]) cylinder(h=size[2], r=r);
    translate([r, size[1]-r, 0]) cylinder(h=size[2], r=r);
    translate([size[0]-r, size[1]-r, 0]) cylinder(h=size[2], r=r);
  }
}

module bit() {
  w = 4;
  difference() {
    translate([-w/2, 0, 0]) cube([w, mm(1), w]);
    translate([-mm(7/256), 0, 0]) rotate([0, 0, 135]) cube([w, w, w]);
    translate([mm(7/256), 0, 0]) rotate([0, 0, -45]) cube([w, w, w]);
  }
}

module masterPadlock(bits) {
  thickness = 2;//mm
  length = 18;//mm
  width = 9.4;//mm
  
  shoulder = 3;
  pin_spacing = 3;
  depth_inc = 0.01;
  
  // Handle size
  h_l = 20;
  h_w = 20;
  h_d = 2;
  difference() {
    // blade and key handle
    union() {
      translate([-h_l, -h_w/2, -h_d/2]) rounded([h_l, h_w, thickness], 5);
      translate([0, -width/2, -thickness/2])intersection() {
        // cut a little off the tip to avoid going too long
        cube([length - mm(1/64), width, thickness]);
        translate([0, mm(1/4), thickness*3/4]) rotate([0, 90, 0]) cylinder(h=length,r=6, r=6);
      }
    }
    
    // chamfer the tip
    translate([length, -width/2 + 3.5, -thickness/2]) {
      rotate([0, 0, 45]) cube([10, 10, thickness]);
      rotate([0, 0, 225]) cube([10, 10, thickness]);
    }
 


    // cut the channels in the key.  designed more for printability than accuracy
    union() {
      translate([0, -width/2 + 1, thickness/2-0.6]) cube([length, 1.5, 0.6]);
      translate([0, -width/2 + 1.3, -thickness/2]) cube([length, 1.2, 0.6]);
      translate([0, -width/2 + 3.5, thickness/2-1]) cube([length, 4, 1]);
      translate([shoulder, -width/2 + 3.5, thickness/2-1]) cube([length, 5, 1]);
    }

    // Do the actual bitting
    for (b = [0:4]) {
      translate([shoulder + b*pin_spacing, width/4 - bits[b]*depth_inc, -thickness]) bit();
    }
    
  }
}

masterPadlock([cut_1,cut_2,cut_3,cut_4,cut_5]);
