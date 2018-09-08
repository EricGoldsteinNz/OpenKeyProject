// Original Key by Nirav Patel <http://eclecti.cc>
// This work is licensed under a Creative Commons Attribution 3.0 Unported License.

//The measurements used below are from the center of the key to the cut. All measurements are in mm. 
//(cut at the handle of key)
cut_1 = 150;
cut_2 = 150;
cut_3 = 85;
cut_4 = 220;
cut_5 = 150;
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
  w = 6;
  difference() {
    translate([-w/2, 0, 0]) cube([w, 20, w]);
    translate([-mm(7/256), 0, 0]) rotate([0, 0, 135]) cube([w, w, w]);
    translate([mm(7/256), 0, 0]) rotate([0, 0, -45]) cube([w, w, w]);
  }
}

// Schlage SC1 5 pin key.  The measurements are mostly guesses based on reverse
// engineering some keys I have and some publicly available information.
module safeKey(bits) {
  // You may need to adjust these to fit your specific printer settings
  thickness = 1.75;//mm
  length = 20.5;//mm
  width = 8.5;//mm
  
  shoulder = 7;
  pin_spacing = 2.5;
  depth_inc = 0.01;

  // Handle size
  h_l = 15;
  h_d = thickness;
  difference() {
    // blade and key handle
    union() {
      translate([-h_l, -h_l/2, -h_d/2]) rounded([h_l, h_l, thickness], 3);
      translate([0, -width/2, -thickness/2])intersection() {
        // cut a little off the tip to avoid going too long
        cube([length - mm(1/64), width, thickness]);
        translate([0, mm(1/4), thickness*3/4]) rotate([0, 90, 0]) cylinder(h=length, r=mm(1/4), $fn=64);
      }
    }
    
    // chamfer the tip
    translate([length, 0, -thickness/2]) {
      rotate([0, 0, 45]) cube([10, 10, thickness]);
      rotate([0, 0, 225]) cube([10, 10, thickness]);
      
    }
    translate([length -6, -width/2 + bits[4]*depth_inc, thickness/2])rotate([180,0,0])cube([10, 10, thickness *2]);
    
    // cut the channels in the key.
    union() {
      translate([0, -width/2 + 3.7, thickness/2-0.5]) cube([length, 1.25, 0.5]);
      translate([0, -width/2 + 6.5, thickness/2-0.5]) cube([length, 1.75, 0.5]);
    }
    // cut the reverse channels in the key.
    rotate([180,0,0])union() {
      translate([0, -width/2 + 3.7, thickness/2-0.5]) cube([length, 1.25, 0.6]);
      translate([0, -width/2 + 6.5, thickness/2-0.5]) cube([length, 1.75, 0.6]);
    }

    // Cut the bitting
    for (b = [0:4]) {
      translate([shoulder + b*pin_spacing, width/2 - bits[b]*depth_inc, -thickness]) bit();
      translate([shoulder + b*pin_spacing, -width/2+ bits[b]*depth_inc, thickness])rotate([180,0,0]) bit();  
    }
    
    //This is a bit of a hack to fix the last pin
    translate([length -6, width/2 - bits[4]*depth_inc, -thickness/2])cube([10, 10, thickness]);
  }
}


safeKey([cut_1,cut_2,cut_3,cut_4,cut_5]);
