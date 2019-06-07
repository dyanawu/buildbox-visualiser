include <MCAD/units/metric.scad>

/*
// axes constants
X = [1,0,0];
Y = [0,1,0];
Z = [0,0,1];
*/

module placegrid ( vol = [150,120,100], //3-vector of build volume in mm
									 origin = [0,0],      //coordinates of origin
									 grid = 10,           //grid spacing in mm
									 type = 0,            //0 = rectangle bed, 1 = delta
									 vertalign = 1        //0 = vertical grids aligned to [0,0], 1 = [x max, y max]
	) {
	translate (-origin) {
		buildbox (vol, grid, type, vertalign);
	}
}

module buildbox (vol, grid, type, vertalign) {
	if (type == 1) {
		deltaplanes (vol, grid);
	}
	else {
		plane (X, Y, vol, grid);
		translate ([vertalign*vol[0],0,0]) {
			plane (Y, Z, vol, grid);
		}
		translate ([0,vertalign*vol[1],0]) {
			plane (X, Z, vol, grid);
		}
	}
}

module deltaplanes (vol, grid) {
	intersection () {
		plane (X, Y, vol, grid);
		translate ([vol[0]/2,vol[1]/2,-0.25]) {
			%cylinder (r = vol[0]/2, h = 1, $fa = 1, $fs = 0.1);
		}
	}
	translate ([0,0,vol[2]]) {
		intersection () {
			plane (X, Y, vol, grid);
			translate ([vol[0]/2,vol[1]/2,-0.25]) {
				%cylinder (r = vol[0]/2, h = 1, $fa = 1, $fs = 0.1);
			}
		}
	}
}

module plane (ax1, ax2, vol,grid) {
	array (ax1, vol, grid) line(vol, ax2);
	array (ax2, vol, grid) line(vol, ax1);
}

module line (vol, axis) {
	%cube ([
		(axis[0] ? axis[0]*vol[0] : 0.5),
		(axis[1] ? axis[1]*vol[1] : 0.5),
		(axis[2] ? axis[2]*vol[2] : 0.5)]);
}

module array (axis, vol, grid) {
	for (i = [0:floor(axis*vol/grid)]) {
		translate ((i*grid)*axis)
		children ();
	}
}

// example block

placegrid (
	vol = [150,150,100],
	origin = [5,5],
	grid = 10,
	type = 0,
	vertalign = 1
);
