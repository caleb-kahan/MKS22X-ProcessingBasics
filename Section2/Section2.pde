int levels;
color bg, fg;
boolean isGasket;

void setup() {
  size(800, 600);
  levels = 0;
  isGasket = true;
}

/*Create Sierpiski's Gasket (google an image of this)
 The outer triangle are the vertices: (v1x, v1y), (v2x,v2y), (v3x, v3y)
 levels:
 0 = regular triangle
 1 = triforce (looks like 3 triangles)
 2 = each of the 3 triangles will be cut into 3 triangles.
 etc.
 */
void gasket(int levels, float v1x, float v1y, float v2x, float v2y, float v3x, float v3y) {
  fill(255, 0, 0);
  if (levels >=0)
  {    
    triangle(  v1x, v1y, v2x, v2y, v3x, v3y );
    fill(50);
    gasketH(levels, v1x, v1y, v2x, v2y, v3x, v3y );
  }
}
void koch(int levels, float v1x, float v1y, float v2x, float v2y) {
  if (levels == 0) line(v1x, v1y, v2x, v2y);
  else {
    kochH(levels, v1x, v1y, v2x, v2y);
  }
}
void kochH(int levels, float v1x, float v1y, float v2x, float v2y) {
  if (levels<1) return;
  float vm1x = v1x + (v2x-v1x) / 3;
  float vm2x = v1x + 2* (v2x-v1x) / 3;
  float vm1y = v1y + (v2y-v1y) / 3;
  float vm2y = v1y + 2* (v2y-v1y) / 3;
  float bigAngle = atan((vm2y-vm1y)/(vm2x-vm1x));
  if (vm2x>vm1x) bigAngle += PI;
  bigAngle=PI/3+bigAngle;
  float distance = dist(vm1x, vm1y, vm2x, vm2y);
  float vspecialy;
  float vspecialx;
  vspecialy= vm1y - distance*sin(bigAngle);
  vspecialx = vm1x - distance*cos(bigAngle);
  stroke(255, 0, 255);
  if (levels==1) {
    line(v1x, v1y, vm1x, vm1y);
    line(v2x, v2y, vm2x, vm2y);
    line(vm1x, vm1y, vspecialx, vspecialy);
    line(vm2x, vm2y, vspecialx, vspecialy);
  }
  kochH(levels-1, v1x, v1y, vm1x, vm1y);
  kochH(levels-1, vm1x, vm1y, vspecialx, vspecialy);
  kochH(levels-1, vspecialx, vspecialy, vm2x, vm2y);
  kochH(levels-1, vm2x, vm2y, v2x, v2y);
}

void gasketH(int levels, float v1x, float v1y, float v2x, float v2y, float v3x, float v3y) {
  if (levels<1) return;
  float v12x = (v1x+v2x)/2;
  float v12y = (v1y+v2y)/2;
  float v13x = (v1x+v3x)/2;
  float v13y = (v1y+v3y)/2;
  float v23x = (v2x+v3x)/2;
  float v23y = (v2y+v3y)/2;
  triangle(v12x, v12y, v13x, v13y, v23x, v23y);
  gasket(levels-1, v13x, v13y, v23x, v23y, v3x, v3y);
  gasket(levels-1, v12x, v12y, v23x, v23y, v2x, v2y);
  gasket(levels-1, v13x, v13y, v12x, v12y, v1x, v1y);
}


void draw() { 
  background(50);  

  fill(255);
  text("Press the up arrow to increase the level,down arrow to decrease the level", 20, 20);
  textSize(10);
  text("Click to switch modes", 20, 50);
  if (isGasket) {
    gasket(levels, 0, height-10, width, height-10, width/2, 10);
  } else {
    stroke(255, 0, 0);
    koch(levels, width-10, height/2, 10, height/3 );
  }
}

void mouseClicked() { 
  isGasket = ! isGasket;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (levels<0) levels = 0;
      else levels++;
    } else if (keyCode == DOWN) {
      levels--;
    }
  }
}
