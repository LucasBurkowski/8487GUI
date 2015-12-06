int rectX, rectY;      
int rectSize = 480;     
int pointSize = 10;
int Value = 1;
int CurrentPoint = 1;
int CurrentXY = 0;
color rectColor, baseColor, PointColor;
color rectHighlight;
color currentColor;
boolean rectOver = false;
boolean circleOver = false;
int[][] Points = new int[480][480];
int[] PointXVal = new int[50];
int[] PointYVal = new int[50];
int[] leftTicks = new int[100];
int[] rightTicks = new int[100];
PrintWriter Coordinates;
PImage background;

void setup() {
  size(640, 640);
  strokeWeight(3);
  rectColor = color(255);
  baseColor = color(102);
  PointColor = color(650);
  currentColor = baseColor;
  rectX = width/2-rectSize/2;
  rectY = height/2-rectSize/2;
  Coordinates = createWriter("Coordinates.txt");
  ellipseMode(CENTER);
  textSize(20);
  background = loadImage("8487GUIBack.png");
}

void newPoint(){
  if ((mouseX <= 560 && mouseY <= 560) && (mouseX >= 81 && mouseY >= 81)){
    Points[mouseX-81][mouseY-81] = CurrentPoint;
  }
}
void getPoint(){
  for(int i = 0; i < 480; i++){
    for(int j = 0; j < 480; j++){
      if(Points[i][j] == CurrentPoint && CurrentXY < 50){
        PointXVal[CurrentXY] = i;
        PointYVal[CurrentXY] = j;
        CurrentXY++;
      }
    }
  }
  CurrentPoint++;
}

void draw() {
  background(currentColor);
  fill(rectColor);
  stroke(255);
  image(background, rectX, rectY);
  rect(270, 580, 100, 50);
  rect(470, 580, 100, 50);
  stroke(0);
  fill(204, 102, 0);
  text("Clear", 295, 615);
  text("Write", 495, 615);
  drawLines();
  for(int i = 0; i < 50; i++){
      if (PointXVal[i] > 0 && PointYVal[i] > 0){
        ellipse(PointXVal[i]+80, PointYVal[i]+80, 10, 10);
      }
    } 
}

void drawLines(){
 for(int i = 0; i < 49; i++){
   if((PointXVal[i+1] != 0 && PointYVal[i+1] != 0) && PointXVal[i] > 0){
     stroke(0);
     line(PointXVal[i]+80, PointYVal[i]+80, PointXVal[i+1]+80, PointYVal[i+1]+80);
   }
 }
}

void clearPoints(){
 for(int i = 0; i < 480; i++){
   for(int j = 0; j < 480; j++){
    Points[i][j] = 0; 
   }
 }
 for(int k = 0; k < 50; k++){
   PointXVal[k] = 0;
   PointYVal[k] = 0; 
 }
 Value = 1;
 CurrentXY = 1;
}

void writeToFile(){
  calculatePoints();
 for(int i = 0; i < 50; i++){
  Coordinates.print(leftTicks[i]+", ");
 }
 Coordinates.println();
 for(int j = 0; j < 50; j++){
   Coordinates.print(rightTicks[j]+", ");
 }
 Coordinates.println();
 Coordinates.close();
}

void mouseClicked(){
  if(mouseButton == LEFT){
    newPoint();
    getPoint();
    if (overRect(270, 580, 100, 50)){
     clearPoints(); 
    }
    if (overRect(470, 580, 100, 50)){
     writeToFile(); 
    }
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
void calculatePoints(){
  for(int i = 1; i < 47; i += 1){
    getTicks(i);
  }
}
void getTicks(int num){
  float turn;
    float distance = dist(PointXVal[num], PointYVal[num], PointXVal[num - 1], PointYVal[num - 1]);
    distance = distance * 23.4375;
    leftTicks[num * 2] = round(distance);
    rightTicks[num * 2] = round(distance);
    if((PointYVal[num + 1] - PointYVal[num]) == 0 || (PointYVal[num + 2] - PointYVal[num + 1]) == 0){
      turn = 0;
    }else{
    float current = atan((PointXVal[num + 1] - PointXVal[num]) / (PointYVal[num + 1] - PointYVal[num]));
    float next = atan((PointXVal[num + 2] - PointXVal[num + 1]) / (PointYVal[num + 2] - PointYVal[num + 1]));
    current = degrees(current); //<>//
    next = degrees(next);
    turn = next - current;
    if(turn > 180){
      turn = 360 - turn;
    }
    turn = 1000/90 * turn;
    }
    leftTicks[num * 2 + 1] = round(-turn);
    rightTicks[num * 2 + 1] = round(turn);
}