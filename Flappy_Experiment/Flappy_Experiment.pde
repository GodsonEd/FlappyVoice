import processing.sound.*;

AudioIn input;
Amplitude analyzer;

//levels ideas
//  increasing speeds per level
//  randomizing speed of each block per level
//  different distance of each block per level

//  First level different distances, same speed
//  Second level different distances, shaky blocks
//  Third level different speeds per block

boolean start_screen = true;
boolean playing = false;
boolean game_over = false;
boolean next_level = false;
boolean win_screen = false;

int cir_rad = 5;

int score = 25;
int lives = 999;
int total_score = 0;

int level = 1;

ArrayList<Pipe> pipes = new ArrayList<Pipe>();

void setup() {
  size(500, 120);
  pipes.add(new Pipe(width,height,level));
  
  // Start listening to the microphone
  // Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);

  // start the Audio Input
  input.start();

  // create a new Amplitude analyzer
  analyzer = new Amplitude(this);

  // Patch the input to an volume analyzer
  analyzer.input(input);
}
void draw()
{
  background(255);
 
  if(start_screen==true)
  {
    textSize(40);
    fill(0);
    rect(width/4,height/4,width/2,height/2);
    
    fill(255);
    text("START",width/2.7,height/1.5);
  }
  if(playing == true)
  {
    // Get the overall volume (between 0 and 1.0)
    float vol = analyzer.analyze();
    
    textSize(20);
    
    fill(255);
    circle(20,height-(vol*150),cir_rad*2);
    
    fill(0);
    text("Score: "+score,width-100,17);
    text("Lives: "+lives,0,17);
    text("Level: "+level,200,17);
    
    if(pipes.get(pipes.size()-1).x<width-random(30,400))
    {
      pipes.add(new Pipe(width,height,level));
    }
    
    for(int x = 0;x<pipes.size();x++)
    {
       pipes.get(x).drawPipe();
       
       if(pipes.get(x).isTouched(20,(int)(height-(vol*200)),cir_rad,pipes.get(x).x,pipes.get(x).h_1,pipes.get(x).w,pipes.get(x).h_3) == true)
      {
        pipes.get(x).red = 0;
        pipes.get(x).green = 255;
      }
      
      if(width%pipes.get(x).speed == 0)
      {
        if(pipes.get(x).x == 0)
        {
          score+=pipes.get(x).isGreen(pipes.get(x).green == 255);
          if(score == 30&&level!=3)
          {
            next_level = true;
          }
        }
        if(pipes.get(x).x == 0&&pipes.get(x).green == 0&&next_level == false)
        {
          lives-=1;
        }
      }
      else if(width%pipes.get(x).speed != 0)
      {
        if(pipes.get(x).x == width%pipes.get(x).speed)
        {
          score+=pipes.get(x).isGreen(pipes.get(x).green == 255);
          if(score == 30&&level!=3)
          {
            next_level = true;
          }
        }
        if(pipes.get(x).x == width%pipes.get(x).speed&&pipes.get(x).green == 0&&next_level == false)
        {
          lives-=1;
        }
      }
    }
    if(lives == 0)
    {
      playing = false;
      game_over = true;
    }
    if(level == 3&&score == 30)
    {
      playing = false;
      win_screen = true;
    }
  }
  if(game_over == true)
  {
    fill(255,0,0);
    rect(0,0,width,height);
    
    fill(0);
    textSize(60);
    text("GAME OVER",80,60);
    textSize(20);
    text("Score: "+score,215,80);

    rect(215,90,80,20);
    fill(255,0,0);
    text("Retry?",225,107);
  }
  if(next_level == true)
  {
    fill(0);
    rect(197,90,100,20);
    fill(255,255,255);
    text("Next level?",195,107);
  }
  if(win_screen == true)
  {
    fill(0,255,0);
    rect(0,0,width,height);
    
    fill(0);
    textSize(60);
    text("GG, You Won",80,60);
    textSize(20);
    text("Total Score: "+total_score,185,80);

    rect(195,90,110,20);
    fill(255,255,255);
    text("Play Again?",195,107);
  }
}

void mousePressed()
{
  if(start_screen == true&&(mouseX>width/4)&&(mouseX<width/4+width/2)&&(mouseY>height/4)&&(mouseY<height/4+height/2))
  {
    playing = true;
    start_screen = false;
  }
  if(game_over == true&&mouseX>215&&mouseX<215+80&&mouseY>90&&mouseY<90+20)
  {
    reset();
  }
  if(next_level == true&&mouseX>197&&mouseX<197+100&&mouseY>90&&mouseY<90+20)
  {
    change_level();
  }
  if(win_screen == true&&mouseX>195&&mouseX<195+110&&mouseY>90&&mouseY<90+20)
  {
    reset();
  }
}
void reset()
{
  game_over = false;
  start_screen = true;
  win_screen = false;
  lives = 5;
  score = 0;
  level = 1;
  pipes.clear();
  pipes.add(new Pipe(width,height,level));
}
void change_level()
{
  next_level = false;
  playing = true;
  lives = 999;
  level+=1;
  total_score+=score;
  score = 25;
  pipes.clear();
  pipes.add(new Pipe(width,height,level));
}
