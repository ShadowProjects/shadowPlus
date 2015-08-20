void drawing(int blobs, int i){
  int lenx, leny;
  
  if(hole == false && area<w*h/50){
    for(int n=0; n<blobs; n++){  
      lenx = nowx[n] - rects.x;
      leny = nowy[n] - rects.y;
      
      print(lenx + ", ");
      
      //隣2個
      if((50<lenx && lenx<150) && (-30<leny && leny<30) && flag2[i]==0){
        flag2[i] = 1;
        buf = id[n];
      }
      //隣3個
      //if((150<lenx && lenx<250) && (-50<leny && leny<50) && flag2[i]==1){
        //flag2[i] = 3;
        //flag2[n] = 4;
        //flag2[buf] = 5;
      //}
    }
    print("\n");
        
    tint(0);
    if(flag2[i]==1){
      image(anime[4], rects.x+rects.width/2-10, rects.y+rects.height-40, 25, 45);
    }
    if(id[i]==buf){
      image(anime[5], rects.x+rects.width/2-10, rects.y+rects.height-40, 25, 45);
    }
    else if(flag2[i]==3){
      image(anime[3], rects.x+rects.width/2-15, rects.y+rects.height-40, 30, 40);
    }else if(flag2[i]==4){
      image(anime[7], rects.x+rects.width/2-15, rects.y+rects.height-40, 30, 40);
    }else if(flag2[i]==5){
      image(anime[6], rects.x+rects.width/2-15, rects.y+rects.height-40, 40, 45);
    }
    stroke(255, 250, 0);
      noFill();
      //rect(rects.x, rects.y, rects.width, rects.height);
      
  
    if(flag2[i]==0 && id[i]!=buf){
      stroke(255, 0, 0);
      tint(0);
      if(count == 0){
        image(anime[count], rects.x+rects.width/2-10, rects.y+rects.height-40, 25, 40);
      }else if(count == 1){
        image(anime[count], rects.x+rects.width/2-10, rects.y+rects.height-25, 23, 25);
      }else if(count == 2){
        image(anime[count], rects.x+rects.width/2-10, rects.y+rects.height-40, 25, 40);
      }
      /*fill(255, 0, 0);
      text(id[i] + ", " + buf, rects.x+10, rects.y+10);
      noFill();*/
      //rect(rects.x, rects.y, rects.width, rects.height);
    }else if(hole == true && area>w*h/10){
      stroke(0, 0, 255);
      tint(0);
      image(anime[3], rects.x+rects.width/2-50, rects.y-36, 30, 40);
      //rect(rects.x, rects.y, rects.width, rects.height);
    }
    fill(255, 0, 0);
      //text(id[i] + ", " + rects.width, rects.x+10, rects.y+10);
  }
}


