void calibration(){
  PImage capture = opencv.image();
  ellipseMode(CENTER);
  noFill();
  strokeWeight(1);
  
  for(int i=0; i <4; i++){
    stroke(255*(i%2),64*(i%4),0);
    
    ellipse(points[i].x, points[i].y, 10, 10);
    line(points[i%4].x, points[i%4].y, points[(i+1)%4].x, points[(i+1)%4].y);
  } 
}

PImage setTransform(PImage pimg,
int destWidth, int destHeight,
Point p0, Point p1,
Point p2, Point p3){
  if ( p0 == null || p1 == null || p2 == null || p3 == null ) return null;
  float[] system = new float[8];
  system = getSystem(p0,p1,p2,p3);
  PImage target = new PImage(destWidth,destHeight);
 
  int i,j,x,y,u,v;
  Point p;
 
  for(i = 0; i<destHeight;i++){
    y = i;
    for(j = 0; j <destWidth; j++){
      x = j;
      p = invert((float)x/destWidth,(float)y/destHeight,system);
      target.set(x,y,pimg.get((int)p.x,(int)p.y));
    }
  }
 
  return target;
}
 
  float[] getSystem(Point p0,Point p1,Point p2,Point p3){
  float[] system = new float[8];
  float sx = (p0.x-p1.x)+(p2.x-p3.x);
  float sy = (p0.y-p1.y)+(p2.y-p3.y);
  float dx1 = p1.x-p2.x;
  float dx2 = p3.x-p2.x;
  float dy1 = p1.y-p2.y;
  float dy2 = p3.y-p2.y;
  float z = (dx1*dy2)-(dy1*dx2);
  float g = ((sx*dy2)-(sy*dx2))/z;
  float h = ((sy*dx1)-(sx*dy1))/z;
 
  system[0]=p1.x-p0.x+g*p1.x;
  system[1]=p3.x-p0.x+h*p3.x;
  system[2]=p0.x;
  system[3]=p1.y-p0.y+g*p1.y;
  system[4]=p3.y-p0.y+h*p3.y;
  system[5]=p0.y;
  system[6]=g;
  system[7]=h;
  return system;
}
 
Point invert(float u,float v, float[] system){
  return new Point(
  (system[0]*u + system[1] * v + system[2] ) / ( system[6] * u + system[7]*v+1)
    ,
  (system[3]*u+system[4]*v+system[5])/(system[6]*u+system[7]*v+1)
    );
}
