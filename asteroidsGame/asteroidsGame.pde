import processing.sound.*;
SoundFile fire;  // Lazer sound "8-bit Laser.aif" by timgormly on freesound.com
SoundFile destroyed;  // Explosion sound "8-bit Explosion.aif" by timgormly on freesound.com
SoundFile backgroundMusic;  // Background music song "Cammipple.mp3" by ShnitzelKiller on freesound.com


Ship ship;

boolean upPressed = false;//CHANGE LEFT AND RIGHT TO UP AND DOWN( IN SHIP TOO)
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;

float shipSpeed = 2;
float bulletSpeed = 10;

int numAsteroids = 3; //the number of asteroids
int startingRadius = 50; //the size of an asteroid
int score; // The player's score for the level
int timer; // The game timer
int savedTime;
int texty; // y for credits


PImage asteroidPic;
PImage rocket;

ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;

PFont font;

// game state variables
int gameState;
public final int INTRO = 1;
public final int PLAY = 2;
public final int PAUSE = 3;
public final int GAMEOVER = 4;
public final int LEVELCLEAR = 5;
public final int CREDITS = 6;



void setup()
{
  savedTime = millis();
  background(0);
  size(800,500);
  font = createFont("Cambria", 32); 
  frameRate(24);
 
  asteroidPic = loadImage("asteroid.png");
  rocket = loadImage("rocket.png");
 
  asteroids = new ArrayList<Asteroid>(0);
 
  gameState = INTRO;
}


void draw()
{  
  switch(gameState) 
  {
    case INTRO:
      drawScreen("Welcome!", "Press s to start");
      break;
    case PAUSE:
      drawScreen("PAUSED", "Press p to resume");
      break;
    case GAMEOVER:
      backgroundMusic.stop();
      drawScreen("GAME OVER", "Press s to try again");
      break;
    case LEVELCLEAR:
      backgroundMusic.stop();
      drawScreen("LEVEL CLEARED", "Press s to try again");
      break;
    case CREDITS:
      backgroundMusic.stop();
      drawCredits();
      break;
    case PLAY:
      background(0);
      
      timer = (millis()-savedTime)/1000;
      
      drawScore(timer, score);
      
      ship.update();
      ship.render();
      
      
      destroyed = new SoundFile(this, "destroyed.aiff");
      
      if( ship.checkCollision(asteroids) || timer >= 30 || asteroids.size() <=0 )
      {
            destroyed.play();
            gameState = GAMEOVER;
      }     
      // Determines the score required according to the number of asteroids in the level
      // Checks that the timer is greater than 0
      else if ( score >= numAsteroids*40 && timer < 30 )
      {
             gameState = LEVELCLEAR;
      }
      else
      {                    
          for(int i = 0; i < bullets.size(); i++)
          {    
             bullets.get(i).update();
             bullets.get(i).render();
    
            if(bullets.get(i).checkCollision(asteroids))
            {
               score+=5;
               bullets.remove(i);
               i--;
            }                        
          }
     
 
          for(int i=0; i<asteroids.size(); i++)//(Asteroid a : asteroids)
          {
            asteroids.get(i).update();            
            asteroids.get(i).render();
          }
          
         float theta = heading2D(ship.rotation)+PI/2;    
             
         if(leftPressed)
            rotate2D(ship.rotation,-radians(5));
        
         if(rightPressed)
            rotate2D(ship.rotation, radians(5));
   
         if(upPressed)
         {
            ship.acceleration = new PVector(0,shipSpeed); 
            rotate2D(ship.acceleration, theta);
         }    
          
       }
       break;
  }
}

//Initialize the game settings. Create ship, bullets, and asteroids
void initializeGame() 
{
   ship  = new Ship();
   bullets = new ArrayList<Bullet>();   
   asteroids = new ArrayList<Asteroid>();
   score = 0;
   
   for(int i = 0; i <numAsteroids; i++)
   {
      PVector position = new PVector((int)(Math.random()*width), 50);      
      asteroids.add(new Asteroid(position, startingRadius, asteroidPic));
   }
}


//
void fireBullet()
{ 
  println("fire");//this line is for debugging purpose
  
  fire = new SoundFile(this, "fire.aiff");
  fire.play();
  
  PVector pos = new PVector(0, ship.r*2);
  rotate2D(pos,heading2D(ship.rotation) + PI/2);
  pos.add(ship.position);
  PVector vel  = new PVector(0, bulletSpeed);
  rotate2D(vel, heading2D(ship.rotation) + PI/2);
  bullets.add(new Bullet(pos, vel));
}



void keyPressed()
{ 
  if(key== 's' && ( gameState==INTRO || gameState==GAMEOVER )) 
  {
    initializeGame();  
    gameState=PLAY;
    backgroundMusic = new SoundFile(this, "backgroundMusic.mp3");
    backgroundMusic.play();
  }
  
  if(key== 'c')
  {
    gameState=CREDITS;
  }
  
  
  if(key=='p' && gameState==PLAY)
  {
    gameState=PAUSE;
    backgroundMusic.stop();
  }
  else if(key=='p' && gameState==PAUSE)
  {
    gameState=PLAY;
    backgroundMusic.play();
  }
  
  //when space key is pressed, fire a bullet
  if(key == ' ' && gameState == PLAY)
     fireBullet();
   
   
  if(key==CODED && gameState == PLAY)
  {         
     if(keyCode==UP) 
       upPressed=true;
     else if(keyCode==DOWN)
       downPressed=true;
     else if(keyCode == LEFT)
       leftPressed = true;  
     else if(keyCode==RIGHT)
       rightPressed = true;        
  }

}
 

void keyReleased()
{
  if(key==CODED)
  {
   if(keyCode==UP)
   {
     upPressed=false;
     ship.acceleration = new PVector(0,0);  
   } 
   else if(keyCode==DOWN)
   {
     downPressed=false;
     ship.acceleration = new PVector(0,0); 
   } 
   else if(keyCode==LEFT)
      leftPressed = false; 
   else if(keyCode==RIGHT)
      rightPressed = false;           
  } 
}


void drawScreen(String title, String instructions) 
{
  background(0,0,0);
  
  // draw title
  fill(255,100,0);
  textSize(60);
  textAlign(CENTER, BOTTOM);
  text(title, width/2, height/2);
  
  // draw instructions
  fill(255,255,255);
  textSize(32);
  textAlign(CENTER, TOP);
  text(instructions, width/2, height/2);
}


void drawScore(int timer, int score)
{
  background(0);
  
  // draw time passed
  fill(255,100,0);
  textSize(30);
  textAlign(CENTER, BOTTOM);
  text(timer, width/2, height/10);
  
  // draw score
  fill(255,255,255);
  textSize(30);
  textAlign(CENTER, TOP);
  text("Current Score: " + score, width/2, height/10);
}


void drawCredits()
{
  font = loadFont("AgencyFB-Reg-20.vlw");
  background(0,0,0,0);
  textFont(font, 32);
  textAlign(CENTER);
  text("A game modified by \n" + 
       "Programmer: Danny Luong",
       width/2, height - texty);
       texty += 1;
  // Returns to the title screen when credits end
  if (texty == height)
  {
    gameState = INTRO;
  }
}


float heading2D(PVector pvect)
{
   return (float)(Math.atan2(pvect.y, pvect.x));  
}


void rotate2D(PVector v, float theta) 
{
  float xTemp = v.x;
  v.x = v.x*cos(theta) - v.y*sin(theta);
  v.y = xTemp*sin(theta) + v.y*cos(theta);
}
