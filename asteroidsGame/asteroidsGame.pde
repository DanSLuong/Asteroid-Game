import processing.sound.*;
SoundFile fire;
SoundFile destroyed;
SoundFile backgroundMusic;


Ship ship;

boolean upPressed = false;//CHANGE LEFT AND RIGHT TO UP AND DOWN( IN SHIP TOO)
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;

float shipSpeed = 2;
float bulletSpeed = 10;

int numAsteroids = 3; //the number of asteroids
int startingRadius = 50; //the size of an asteroid
int score; // The player's game score for the current level
int savedTime;
int timer; // The game's timer
int texty;
int bulletCount;  // Number of bullets
int count;  // Number of asteroids existing at the begining


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
      drawScreen("Welcome!", "\n\n Press s to START! \n\n\n Press c for credits");
      break;
    case PAUSE:
      drawScreen("PAUSED", "\n\n Press p to resume");
      break;
    case GAMEOVER:
      drawScreen("GAME OVER", "\n\n Press s to try again \n\n\n Press c for credits");
      break;
    case LEVELCLEAR:
      drawScreen("LEVEL CLEARED", "\n\n Press s to try again \n\n\n Press c for credits");
      break;
    case CREDITS:
      drawCredits();
      break;
    case PLAY:
      background(0);
      
      timer = (millis() - savedTime)/1000; // Game Clock/timer
      drawScore(timer, score);  // Draws the game time and current score at the top of the screen
      
      ship.update();
      ship.render(); 
      
      int levelScore = numAsteroids * 35;  // Score required to advance determined by the number of asteroids
      
      // Checks for collision of ship with asteroids
      // Checks time in game, score, and bullets remaining
      if( ship.checkCollision(asteroids) || ( timer >= 30 && score < levelScore ) || bulletCount <= 0 && ( score < levelScore || timer >= 30 ) )
      {
        backgroundMusic.stop();
        destroyed.play();  // Explosion when the ship collides with an asteroid
        gameState = GAMEOVER;
      }
      else if( timer < 30 && score >= levelScore && bulletCount >= 0 || asteroids.size() <=0 )
      {
        backgroundMusic.stop();
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
               score+=5;  // Five points for every asteroid hit by the bullets
               bullets.remove(i);
               i--;
            }
          }
     
 
          for(int i=0; i<asteroids.size(); i++)//(Asteroid a : asteroids)
          {
            // Checks if asteroid is destroyed
            if(count > asteroids.size())
            {
              destroyed.play();
              count--;
              score+=45;  // Destroy asteroid score bonus
              bulletCount+=3;  // Bonus Bullets when asteroid is destroyed
            }
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
   fire = new SoundFile(this, "fire.aiff");  // Lazer sound "8-bit Laser.aif" by timgormly on freesound.com
   destroyed = new SoundFile(this, "destroyed.aiff");  // Explosion sound "8-bit Explosion.aif" by timgormly on freesound.com
   backgroundMusic = new SoundFile(this, "backgroundMusic.mp3");  // Background music song "Cammipple.mp3" by ShnitzelKiller on freesound.com
   score = 0;
   savedTime = millis();
   bulletCount = 20;
   
   ship  = new Ship();
   bullets = new ArrayList<Bullet>();   
   asteroids = new ArrayList<Asteroid>();
   
   for(int i = 0; i <numAsteroids; i++)
   {
      PVector position = new PVector((int)(Math.random()*width), 50);      
      asteroids.add(new Asteroid(position, startingRadius, asteroidPic));
   }
   count = numAsteroids;
}


//
void fireBullet()
{ 
  println("fire");//this line is for debugging purpose

  PVector pos = new PVector(0, ship.r*2);
  rotate2D(pos,heading2D(ship.rotation) + PI/2);
  pos.add(ship.position);
  PVector vel  = new PVector(0, bulletSpeed);
  rotate2D(vel, heading2D(ship.rotation) + PI/2);
  bullets.add(new Bullet(pos, vel));
  
  // Laser sound when bullet is fired
  fire.play();
  bulletCount--;
  println(bulletCount);
}



void keyPressed()
{ 
  if(key== 's' && ( gameState==INTRO || gameState==GAMEOVER || gameState==LEVELCLEAR )) 
  {
    initializeGame();  
    gameState=PLAY;
    backgroundMusic.play();  // Initializes music when the game starts
  }
  
  
  if( key == 'p' && gameState == PLAY )
  {
    gameState=PAUSE;
    backgroundMusic.stop();
  }
  else if(key=='p' && gameState==PAUSE)
  {
    gameState=PLAY;
    backgroundMusic.play();
  }
  
  
  // Credits when c is pressed
  if( key == 'c' )
  {
    if( gameState == INTRO || gameState == GAMEOVER || gameState == LEVELCLEAR )
    {
      gameState = CREDITS;
    }
    else if( gameState == PLAY )
    {
      gameState = CREDITS;
      backgroundMusic.stop();
    }
    else if( key == 'c' && gameState == CREDITS )
    {
      gameState = INTRO;
    }
  }
  
  
  //when space key is pressed, fire a bullet
  if( key == ' ' && gameState == PLAY)
     fireBullet();
   
   
  if( key == CODED && gameState == PLAY )
  {         
     if( keyCode == UP ) 
       upPressed = true;
     else if( keyCode == DOWN )
       downPressed=true;
     else if( keyCode == LEFT )
       leftPressed = true;  
     else if( keyCode == RIGHT )
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
  textSize(25);
  textAlign(CENTER, TOP);
  text(instructions, width/2, height/2);
}


// Score and game time
void drawScore(int timer, int score)
{
  background(0,0,0,0);
  
  // draw time passed
  fill(255,100,0);
  textSize(30);
  textAlign(CENTER, BOTTOM);
  text(timer, width/2, height/10);
  
  // draw bullets left
  fill(255,100,0);
  textSize(30);
  textAlign(CENTER, CENTER);
  text("\n\n Bullets: " + bulletCount, width/2, height/10);
  
  // draw score
  fill(255,255,255);
  textSize(30);
  textAlign(CENTER, TOP);
  text("Current Score: " + score, width/2, height/10);
}


// Credits
void drawCredits()
{
  font = loadFont("AgencyFB-Reg-20.vlw");
  background(0,0,0,0);
  textFont(font, 32);
  textAlign(CENTER);
  text("A game developed/modified by \n" + 
       "Programmer: Danny Luong \n" + 
       "Sound files downloaded from freesound.com \n" +
       "Lazer sound: \n" +
       "Title: '8-bit Laser.aif' \n" +
       "Artist: timgormly \n" + 
       "Explosion sound: \n"+ 
       "Title: '8-bit Explosion.aif' \n" +
       "Artist: timgormly \n" +
       "Background music song: \n" +
       "Title: 'Cammipple.mp3' \n" +
       "Artist: ShnitzelKiller \n",
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
