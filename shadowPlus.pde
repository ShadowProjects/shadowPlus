import java.awt.Rectangle;
import java.awt.Point;

import fullscreen.*;
import gifAnimation.*;
import hypermedia.video.*;

OpenCV opencv;
FullScreen fs;
 
PImage capture, convert;
PFont txt;
boolean dragged = false;
int selector = 0;
int threshold = 140;
int w = 800;
int h = 600;
int flag = 0; //画面の切り替え用
int frame;  //最初のフレームかの判定用
int count = 0;  //パターン外のときの表示する画像の決定
int count2 = 1;  //一致するIDがないときに増やすやつ
int nowx[] = new int[30];  //現在のx座標
int nowy[] = new int[30];  //現在のy座標
int prex[] = new int[30];  //１つ前のx座標
int prey[] = new int[30];  //１つ前のy座標
int flag2[] = new int[30];
int buf;
int num;  //1つ前のカタマリの個数
int id[] = new int[30];  //現在のID
int preid[] = new int[30];  //１つ前のID
Rectangle rects;
float area;
boolean hole;
Point[] points = {new Point(), new Point(), new Point(), new Point()};
Gif[] anime;
 
void setup(){
  size(w, h);
  opencv = new OpenCV(this);
  opencv.capture(w, h);
  capture = new PImage(w, h);
  convert = new PImage(w, h);
  points[0].setPoint(0, 0);
  points[1].setPoint(w, 0);
  points[2].setPoint(w, h);
  points[3].setPoint(0, h);
  
  anime = new Gif[8];
  for(int i=0; i<8; i++){
    anime[i] = new Gif(this, "img" + i + ".gif");
    anime[i].loop();
  }
  
  txt = loadFont("Arial-Black-10.vlw");
  textFont(txt, 10);
  
  //フルスクリーン
  fs = new FullScreen(this);
  fs.enter();
  fs.setResolution(800, 600);
}

void draw(){
  opencv.read();
  background(255);
  noTint();
  
  if(flag == 0){  //キャリブレーション画面
    capture = opencv.image();
    image(capture, 0, 0, w, h);
    calibration();
    frame = 0;
    count2 = 1;
  }else if(flag == 1){  //投影画面
    opencv.convert(GRAY);
    opencv.threshold(threshold);
    capture = opencv.image();
    convert = setTransform(capture, w, h, points[0], points[1], points[2], points[3]);
    //opencv.allocate(w, h);
    opencv.copy(convert);
    noTint();
    image(convert, 0, 0, w, h);
  
    Blob[] blobs = opencv.blobs(300, w*h/3, 30, true);
    
    //現在の全カタマリの座標値格納
    for(int i=0; i<blobs.length; i++){
      rects = blobs[i].rectangle;
      rects.x = rects.x;
      rects.y = rects.y;
      rects.width = rects.width;
      rects.height = rects.height;
      
      nowx[i] = rects.x;
      nowy[i] = rects.y;
      flag2[i] = 0;
    }
    
    for(int i=0; i<blobs.length; i++){
      rects = blobs[i].rectangle;
      area = blobs[i].area;
      hole = blobs[i].isHole;
      
      if((hole==false && area<w*h/50) || (hole==true && area>w*h/10)){
        //同じ塊を探す
        if(frame == 0){
          id[i] = i;  //最初にIDをふる
          count2 = 1;
          //print("StartID" + id[i] + "[" + rects.x + "," + rects.y + "]  ");
        }else{  //以降は前のと比べてIDを決める
          for(int n=0; n<num; n++){
            int len = int(dist(prex[n], prey[n], rects.x, rects.y));  //前座標と現座標の距離
            //距離が30以下なら同じ塊と認識
            if(len<=20){
              //print("ID" + preid[n] + "[" + rects.x + "," + rects.y + "]  ");
              id[i] = preid[n];
              break;
            }else if(n==num-1){
              id[i] = num + count2;
              count2++;
              //print("ないよ(´・ω・｀)ID" + id[i] + "[" + rects.x + "," + rects.y + "]  ");
              break;
            }
          }
        }
      }
      count = id[i] % 3;  //表示する画像を決める
      drawing(blobs.length, i);  //画像を表示
    }
    for(int i=0; i<blobs.length; i++){
      rects = blobs[i].rectangle;
      prex[i] = rects.x;
      prey[i] = rects.y;
      preid[i] = id[i];
    }
    frame = 1;
    num = blobs.length;  //現在のフレームのカタマリの数
    print("\n");
  }
}


//マウス・キー操作
void mousePressed(){
  if(dragged == false){
    for(int i=0; i <4; i++){
      if(points[i].x -50 <mouseX && points[i].x + 50>mouseX){
        if(points[i].y -50 <mouseY && points[i].y + 50>mouseY){
          dragged = true;
          selector = i;
        }
      }
    }
  }
}
void mouseDragged(){
  if(dragged){
    if(mouseX> 0 && mouseX <w){
      points[selector].setPoint(mouseX,points[selector].y);
    }
    if(mouseY> 0 && mouseY <h){
      points[selector].setPoint(points[selector].x,mouseY);
    }
  }
}
void mouseReleased(){
  dragged = false;
}
void keyPressed(){
  if(key == ' '){
    if(flag == 0) flag = 1;
    else flag = 0;
  }
}
