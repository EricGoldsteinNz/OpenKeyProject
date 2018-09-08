//(this is just a reference table to help pick cuts below)
//0 = .335",1:1 = .320",2:2 = .305",3:3 = .290",4:4 = .275",5:5 = .260",6:6 = .245",7:7 = .230",8:8 = .215",9:9 = .200"]

//cuts are ordered teh same as Schlage key codes
//(cut at the handle of key)
cut_1 = 2; 
cut_2 = 3;
cut_3 = 2; 
cut_4 = 5; 
cut_5 = 5; 
//(cut at the tip of key)

//Print label
keycode=1; 

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

// Schlage SC1 5 pin key.
module sc1(bits) {
  thickness = mm(0.080);
  width = mm(.335);
  shoulder = mm(.231);
  pin_spacing = mm(.156);
  depth_inc = mm(.015);
  tiplength = mm(.05);
  //length = mm(17/16);
  length = shoulder + 5 * pin_spacing + tiplength;

  
  // Handle size
  h_l = mm(1);
  h_w = mm(1);
  h_d = mm(1/16);
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
 
    // Keycode
    if (keycode==1){
        translate([-11,width/2, mm(-0.060)]) {
            linear_extrude(height=mm(0.080)) rotate([0,0,90]) scale([-1, 1, 1]) text(str(cut_1, cut_2, cut_3, cut_4, cut_5), font="Calibri-Bold", direction="ltr", halign="center", valign="center", size=5);
            }
    }  


    // cut the channels in the key.
    union() {
      translate([-h_d, mm(9/64), thickness/2]) rotate([62, 0, 0]) cube([length + h_d, width, width]);
      translate([-h_d, mm(7/64), thickness/2]) rotate([55, 0, 0]) cube([length + h_d, width, width]);
      translate([-h_d, mm(7/64), thickness/2]) cube([length + h_d, mm(1/32), width]);
    }
    
    translate([-h_d, width - mm(9/64), -0.2]) cube([length + h_d, width - (width - mm(10/64)), thickness/2]);
    translate([-h_d, width - mm(9/64), thickness/2]) rotate([-110, 0, 0]) cube([length + h_d, width, thickness/2]);
    
    intersection() {
      translate([-h_d, mm(1/32), thickness/2]) rotate([-118, 0, 0]) cube([length + h_d, width, width]);
      translate([-h_d, mm(1/32), thickness/2]) rotate([-110, 0, 0]) cube([length + h_d, width, width]);
    }
    
    // Do the actual bitting
    for (b = [0:4]) {
      translate([shoulder + b*pin_spacing, width - bits[b]*depth_inc, 0]) bit();
    }
  }
}
//Create the key
sc1([cut_1,cut_2,cut_3,cut_4,cut_5]);
