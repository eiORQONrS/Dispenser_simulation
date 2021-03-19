public class PrintPath {

  private StringList p;
  private int offset_x;
  private int offset_y;
  private int scale;
  private int weight;
  public PrintPath() {
    this.weight = 5;
  }
  public void update(StringList path, int x, int y, int n) {
    this.p = path;
    this.offset_x = x;
    this.offset_y = y;
    this.scale = n;
    
    for (int i = 0; i<this.p.size(); i++)
    {
      String str = this.p.get(i);
      String op = getOp(str);
      float[] point = getPoint(str);

      if (op=="s") {
        float p1 = this.offset_x+point[1]*this.scale;
        float p2 = this.offset_y+point[0]*this.scale;
        circle(p1, p2, this.weight);
      } else if (op=="p" || op=="e")
      {
        float p1 = this.offset_x+point[1]*this.scale;
        float p2 = this.offset_y+point[0]*this.scale;
        String lastpoint = this.p.get(i-1);
        if (lastpoint.indexOf("cp") == 0) 
        {
          String fpoint = this.p.get(i-2);

          point = this.getPoint(lastpoint);
          float cp1 = this.offset_x+point[1]*this.scale;
          float cp2 = this.offset_y+point[0]*this.scale;

          point = this.getPoint(fpoint);
          float fp1 = this.offset_x+point[1]*this.scale;
          float fp2 = this.offset_y+point[0]*this.scale;

          //p,cp,fp
          float[] pa = {cp1, cp2};
          float[] pb = {fp1, fp2};
          float[] pc = {p1, p2};
          point = CircumscribedCircle(pa, pb, pc);
          float rp1 = point[0];
          float rp2 = point[1];
          float r = point[2];
          // OAB OCB pointA->pointB
          float[] pA = new float[2];
          float[] pB = new float[2];
          if (ccw(new float[]{rp1, rp2}, new float[]{fp1, fp2}, new float[]{cp1, cp2})=="CW" && ccw(new float[]{rp1, rp2}, new float[]{p1, p2}, new float[]{cp1, cp2})=="CCW")
          {
            pA[0] = fp1;
            pA[1] = fp2;
            pB[0] = p1;
            pB[1] = p2;
          } else {
            pA[0] = p1;
            pA[1] = p2;
            pB[0] = fp1;
            pB[1] = fp2;
          }
          float start = atan2(pA[1]-rp2, pA[0]-rp1);
          float stop = atan2(pB[1]-rp2, pB[0]-rp1);

          //start = changeAngle(start);
          //stop = changeAngle(stop);
          //if(stop<start)
          //  stop+=2*PI;
          
          stroke(this.weight);
          strokeWeight(this.weight);
          fill(0,0,0);
          noFill();
          if(start<stop)
            start+=2*PI;
          arc(rp1, rp2, 2*r, 2*r, stop, start, OPEN);
          println(start/PI*180, stop/PI*180);
          
        } else
        {
          strokeWeight(this.weight);
          point = this.getPoint(lastpoint);
          float lp1 = this.offset_x+point[1]*this.scale;
          float lp2 = this.offset_y+point[0]*this.scale;
          stroke(this.weight);
          line(p1, p2, lp1, lp2);
        }
        
      }
    }
  }
  public void setWeight(int size)
  {
     this.weight = size; 
  }
  public int getWeight()
  {
     return this.weight; 
  }
  //public float changeAngle(float angle)
  //{ 
  //    if(angle==-PI)
  //      angle=PI;
  //    else if(angle>0 && angle<PI)
  //      angle=2*PI-angle;
  //    else if(angle<0)
  //      angle = -angle;
  //    else if(angle==2*PI)
  //      angle = 0;
  //    return angle;
  //}
  public float[] getPoint(String str)
  {
    String substr = str.substring(str.indexOf("(")+1, str.indexOf(")"));
    float[] nums = float(split(substr, ","));
    return nums;
  }
  public String getOp(String str) {
    String op = "";
    if (str.indexOf("(") == 0)
      op="p";
    else if (str.indexOf("cp") == 0)
      op="cp";
    else if (str.indexOf("s") == 0)
      op="s";
    else if (str.indexOf("e") == 0)
      op="e";
    return op;
  }
  public float norm(float[] a)
  {
    return a[0]*a[0]+a[1]*a[1];
  }
  public float dot(float[] a, float[] b)
  {
    return a[0]*b[0]+a[1]*b[1];
  }
  public float cross(float[] a, float[] b)
  {
    return a[0]*b[1]-a[1]*b[0];
  }
  public float abs(float[] a)
  {
    return sqrt(norm(a));
  }
  public float abs(float[] a, float[] b)
  {
    float[] x = {b[0]-a[0], b[1]-a[1]};
    return sqrt(norm(x));
  }
  float[] CircumscribedCircle(float[] a, float[] b, float[] c)
  {
    float x=0.5*(norm(b)*c[1]+norm(c)*a[1]+norm(a)*b[1]-norm(b)*a[1]-norm(c)*b[1]-norm(a)*c[1])
      /(b[0]*c[1]+c[0]*a[1]+a[0]*b[1]-b[0]*a[1]-c[0]*b[1]-a[0]*c[1]);
    float y=0.5*(norm(b)*a[0]+norm(c)*b[0]+norm(a)*c[0]-norm(b)*c[0]-norm(c)*a[0]-norm(a)*b[0])
      /(b[0]*c[1]+c[0]*a[1]+a[0]*b[1]-b[0]*a[1]-c[0]*b[1]-a[0]*c[1]);
    float[] O = {x, y};
    float r=abs(O, a);
    float[] m = {O[0], O[1], r};
    return m;
  }
  public String ccw(float[] p0, float[] p1, float[] p2)
  {
    float[] a = new float[2];
    float[] b = new float[2];
    a[0]=p1[0]-p0[0];
    a[1]=p1[1]-p0[1];
    b[0]=p2[0]-p0[0];
    b[1]=p2[1]-p0[1];
    if ( cross(a, b)>EPS ) return "CCW";
    if ( cross(a, b)<-EPS ) return "CW";
    if ( dot(a, b)<-EPS ) return "BACK";
    if ( norm(a)<norm(b) ) return "FRONT";
    return "ON";
  }
}
