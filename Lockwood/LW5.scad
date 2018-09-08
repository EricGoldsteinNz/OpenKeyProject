
//Pin reference Table
//0 = .300"
//1 = .285
//2 = .270
//3 = .255"
//4 = .240"
//5 = .225"
//6 = .210"
//7 = .195"
//8 = .180"
//9 = .165" 
//10 = .150"
//test lock is a 47413
//cuts are ordered the same as key codes
//(cut at the handle of key)
cut_1 = 6; //[0:10]
cut_2 = 3; //[0:10]
cut_3 = 6; //[0:10]
cut_4 = 9; //[0:10]
cut_5 = 7; //[0:10]
cut_6 = 9; //[0:10]
//(cut at the tip of key)


function mm(i) = i*25.4;

module handle(size, r) {
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
  w = mm(1/4);
  difference() {
    translate([-w/2, 0, 0]) cube([w, mm(1), w]);
    translate([-mm(7/256), 0, 0]) rotate([0, 0, 135]) cube([w, w, w]);
    translate([mm(7/256), 0, 0]) rotate([0, 0, -45]) cube([w, w, w]);
  }
}

// Schlage SC1 5 pin key.  The measurements are mostly guesses based on reverse
// engineering some keys I have and some publicly available information.
module sc1(bits) {
  // You may need to adjust these to fit your specific printer settings
  thickness = 2;
  length = 31;
  width = mm(.335);
  
  shoulder = 4.5;
  pin_spacing = mm(.156);
  depth_inc = mm(.015);
  
  // A fudge factor.  Printing with your average RepRap, the bottom layer is
  // going to be squeezed larger than you want. You can make the pins
  // go slighly deeper by a fudge amount to make up for it if you aren't
  // adjusting for it elsewhere like Skeinforge or in your firmware.
  // 0.5mm works well for me.
  fudge = 0;
  

  
  // Handle size
  h_l = 20;
  h_w = 20;
  difference() {
    // blade and key handle
    union() {
      translate([-h_l, -h_w/2 + width/2, 0]) handle([h_l, h_w, thickness], mm(1/4));
      intersection() {
        // cut a little off the tip to avoid going too long
        cube([length - mm(1/64), width, thickness]);
        translate([0, mm(1/4), thickness*3/4]) rotate([0, 90, 0]) cylinder(h=length, r=mm(1/4), $fn=64);
      }
    }
    
    // chamfer the tip
    translate([length, mm(1/8), 0]) {
      rotate([0, 0, 45]) cube([10, 10, thickness]);
      rotate([0, 0, 225]) cube([10, 10, thickness]);
    }


    // cut the channels in the key.  designed more for printability than accuracy
    //Side A 
    translate([-thickness, 0.65, 0.75]) cube([length + thickness, 2, thickness-0.75]);  
    translate([-thickness, 4, thickness])rotate([-30,0,0]) cube([length + thickness, 2.5, thickness-0.75]);
    translate([-thickness, 6, 0.75]) cube([length + thickness, 4, thickness-0.75]);
    
    //Side B
    translate([-thickness, 3, 0]) cube([length + thickness, 2, 1]);  
    
    // Do the actual bitting
    for (b = [0:5]) {
      translate([shoulder + b*pin_spacing, width - bits[b]*depth_inc, 0]) bit();
    }
  }
}

sc1([cut_1,cut_2,cut_3,cut_4,cut_5,cut_6]);

