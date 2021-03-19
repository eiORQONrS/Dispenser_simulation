import controlP5.*;

ControlP5 cp5;
Textarea myTextarea;
PointPath path;
PrintPath printer;
PImage img;

float EPS = 1e-10;

int WIDTH;
int HEIGHT;
int N=16;
float K=0.3;

void setup()
{
  fullScreen();
  //size(3000, 1800);
  background(255);
  smooth();

  WIDTH = width;
  HEIGHT = height;

  PFont font = createFont("Hack-Regular.ttf", HEIGHT*0.03);
  cp5 = new ControlP5(this);

  cp5.addTextfield("input")
    .setPosition(WIDTH*0.02, HEIGHT*0.1)
    .setSize(int(WIDTH*0.15), int(HEIGHT*0.05))
    .setFont(font)
    .setFocus(true)
    .setColorBackground(color(200, 200, 200))
    .setColorActive(color(220, 220, 220))
    .setColor(color(0, 0, 0))
    ;

  cp5.addButton("Del")
    .setValue(0)
    .setPosition(WIDTH*0.18, HEIGHT*0.1)
    .setSize(int(WIDTH*0.04), int(HEIGHT*0.05))
    .setFont(font)
    .setColorBackground(color(30, 30, 30))
    ;

  cp5.addButton("Plus")
    .setValue(0)
    .setPosition(WIDTH*0.5, HEIGHT*0.1)
    .setSize(int(WIDTH*0.02), int(HEIGHT*0.02))
    .setColorBackground(color(30, 30, 30))
    .setCaptionLabel("+")
    .setFont(font)
    ;
  cp5.addButton("Minus")
    .setValue(0)
    .setPosition(WIDTH*0.5, HEIGHT*0.13)
    .setSize(int(WIDTH*0.02), int(HEIGHT*0.02))
    .setColorBackground(color(30, 30, 30))
    .setCaptionLabel("-")
    .setFont(font)
    ;
  cp5.addButton("Default")
    .setValue(0)
    .setPosition(WIDTH*0.53, HEIGHT*0.1)
    .setSize(int(WIDTH*0.025), int(HEIGHT*0.05))
    .setColorBackground(color(255, 200, 30))
    .setCaptionLabel("C")
    .setFont(font)
    ;
  cp5.addButton("W_Plus")
    .setValue(0)
    .setPosition(WIDTH*0.635, HEIGHT*0.1)
    .setSize(int(WIDTH*0.02), int(HEIGHT*0.02))
    .setColorBackground(color(65, 105, 225))
    .setCaptionLabel("+")
    .setFont(font)
    ;
  cp5.addButton("W_Minus")
    .setValue(0)
    .setPosition(WIDTH*0.635, HEIGHT*0.13)
    .setSize(int(WIDTH*0.02), int(HEIGHT*0.02))
    .setColorBackground(color(65, 105, 225))
    .setCaptionLabel("-")
    .setFont(font)
    ;
  cp5.addButton("W_Default")
    .setValue(0)
    .setPosition(WIDTH*0.665, HEIGHT*0.1)
    .setSize(int(WIDTH*0.025), int(HEIGHT*0.05))
    .setColorBackground(color(255, 200, 30))
    .setCaptionLabel("C")
    .setFont(font)
    ;


  path = new PointPath();
  printer = new PrintPath();
  img = loadImage("tips.png");
}

void draw()
{ 
  background(255);

  int[] area = display_area();
  int[] area_grid = display_print(area[0], area[1], area[2], area[3]);

  display_path(path);
  printer.update(path.allPath(), area_grid[0], area_grid[1], N);
}

void display_path(PointPath path)
{ 
  fill(0, 0, 0);
  textSize(HEIGHT*0.02);

  image(img, WIDTH*0.02, 0, img.width/img.height*HEIGHT*0.12, HEIGHT*0.1);

  for (int i=1; i<=path.getSize(); i++)
  {
    int cnt=i;
    String str = path.getPath(i-1);
    if (cnt<=30) 
      text("p"+cnt+": "+str, WIDTH*0.02, HEIGHT*0.17+HEIGHT*0.025*cnt);
    if (cnt>30 && cnt<=60)
      text("p"+cnt+": "+str, WIDTH*0.02+WIDTH*0.12, HEIGHT*0.17+HEIGHT*0.025*(cnt-30));
    if (cnt>60)
      text("p"+cnt+": "+str, WIDTH*0.02+WIDTH*0.24, HEIGHT*0.17+HEIGHT*0.025*(cnt-60));
  }
}

public void input(String theText) {
  // automatically receives results from controller input
  println("Text: "+theText);
  path.addPath(theText);
}

public void Del(int theValue) {
  println("a button event from DEL: "+theValue);
  if (theValue == 0)
    path.popPath();
}

public void Plus(int theValue) {
  if (theValue == 0)
  {
    N = min(N+1, 40);
    printer.setWeight(int(N*K));
  }
}

public void Minus(int theValue) {
  if (theValue == 0)
  {
    N = max(N-1, 5);
    printer.setWeight(int(N*K));
  }
}

public void Default(int theValue) {
  if (theValue == 0)
  {
    N = 16;
    K = 0.3;
    printer.setWeight(int(N*K));
  }
}
public void W_Plus(int theValue) {
  if (theValue == 0)
  {
    K=min(2, K+0.05);
    printer.setWeight(int(N*K));  
  }
}

public void W_Minus(int theValue) {
  if (theValue == 0)
  {
    K=max(0, K-0.05);
    printer.setWeight(int(N*K));
  }
}

public void W_Default(int theValue) {
  if (theValue == 0)
  {
    N=16;
    K=0.3;
    printer.setWeight(int(N*K));  
  }
}

int[] display_area()
{
  strokeWeight(5);
  stroke(0, 0, 0);
  fill(255, 255, 255);
  int center_x = WIDTH/2;
  int center_y = HEIGHT/2;

  int[] area = {int(WIDTH*0.38), int(Y+center_y-0.3*HEIGHT), int(WIDTH*0.6), int(HEIGHT*0.7)};
  rect(area[0], area[1], area[2], area[3]);

  return area;
}

int[] display_print(int X, int Y, int W, int H)
{
  strokeWeight(5);
  stroke(20, 100, 235, 20);
  fill(255, 255, 255);
  int[] area = {int(X+W*0.1), int(Y+H*0.1), int(W*0.8), int(H*0.8)};
  int n = N;
  for (int i = 0; i <= (area[2]/n)*n; i+=n)
    line(area[0]+i, area[1], area[0]+i, area[1]+(area[3]/n)*n);
  for (int i = 0; i <= (area[3]/n)*n; i+=n)
    line(area[0], area[1]+i, area[0]+(area[2]/n)*n, area[1]+i);

  stroke(20, 100, 235);
  for (int i = 0; i <= int(WIDTH*0.025); i+=n)
    line(WIDTH*0.6+i, HEIGHT*0.1, WIDTH*0.6+i, HEIGHT*0.1+int(HEIGHT*0.05));
  for (int i = 0; i <= int(HEIGHT*0.05); i+=n)
    line(WIDTH*0.6, HEIGHT*0.1+i, WIDTH*0.6+int(WIDTH*0.025), HEIGHT*0.1+i);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  circle((WIDTH*0.6+WIDTH*0.025/2), (HEIGHT*0.1+HEIGHT*0.05/2), printer.getWeight());
  text("Stroke: "+String.format("%.2f", K)+" mm", WIDTH*0.595, HEIGHT*0.095);

  fill(255, 255, 255);
  //fill(240, 240, 240);
  stroke(20, 20, 20, 20);
  rect(X, HEIGHT*0.1, int(WIDTH*0.106), int(HEIGHT*0.05));
  fill(0, 0, 0);
  textSize(HEIGHT*0.03); 
  String s = (area[3]/n+1)+" X "+ (area[2]/n+1);
  text(s, X+int(WIDTH*0.106)/2-textWidth(s)/2, HEIGHT*0.135);
  textSize(HEIGHT*0.02); 
  text("Resolution", X, HEIGHT*0.095);


  //Position(WIDTH*0.53, HEIGHT*0.1)
  //Size(int(WIDTH*0.025), int(HEIGHT*0.05))

  return area;
}
