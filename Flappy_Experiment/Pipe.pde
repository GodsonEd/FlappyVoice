class Pipe
{
  int red;
  int green;
  int blue;
  
  int x;
  int y_1;
  int y_2;
  int w;
  int h_1;
  int h_2;
  int h_3;
  
  int speed;
  
  Pipe(int scr_width, int scr_height, int level)
  {
    if(level == 1)
    {
      speed = 2;
    }
    if(level == 2)
    {
      speed = (int)(random(2,4));
    }
    if(level == 3)
    {
      speed = (int)(random(1,5));
    }
    
    x = scr_width;
    w = 20;
    h_1 = (int)(random((scr_height-20)*.7));
    h_2 = ((scr_height-20)-h_1)-20;
    y_1 = 20;
    y_2 = (scr_height)-h_2;
    h_3 = (y_2)-(h_1+20);
    
    red = 255;
    green = 0;
    blue = 0;
  }
  
  void drawPipe()
  {
    //fill(0);
    //rect(x,y_1,w,h_1);
    //rect(x,y_2,w,h_2);
    fill(red,green,blue);
    rect(x,h_1+20,w,h_3);
    
    x-=speed;
  }
  
  int isGreen(boolean ans)
  {
    if(ans == true)
    {
      return 1;
    }
    return 0;
  }
  
  boolean isTouched(int cx, int cy, int radius, int rx, int ry, int rw, int rh)
  {
    // temporary variables to set edges for testing
    float testX = cx;
    float testY = cy;
    
    // which edge is closest?
    if (cx < rx)         
      testX = rx;      // test left edge
    else if (cx > rx+rw) 
      testX = rx+rw;   // right edge
    if (cy < ry)         
      testY = ry;      // top edge
    else if (cy > ry+rh) 
      testY = ry+rh;   // bottom edge
    
    // get distance from closest edges
    float distX = cx-testX;
    float distY = cy-testY;
    float distance = sqrt( (distX*distX) + (distY*distY) );

    // if the distance is less than the radius, collision!
    if (distance <= radius) {
      return true;
    }
    return false;
  }
}
