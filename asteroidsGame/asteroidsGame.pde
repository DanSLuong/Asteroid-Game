
Ship ship;

boolean upPressed = false;//CHANGE LEFT AND RIGHT TO UP AND DOWN( IN SHIP TOO)
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;

float shipSpeed = 2;
float bulletSpeed = 10;

int numAsteroids = 2; //the number of asteroids
int startingRadius = 50; //the size of an asteroid


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
      drawScreen("Welcome!", "Press s to start");
      break;
    case PAUSE:
      drawScreen("PAUSED", "Press p to resume");
      break;
    case GAMEOVER:
      drawScreen("GAME OVER", "Press s to try again");
      break;
    case PLAY:
      background(0);
      
      ship.update();
      ship.render(); 
              
      if(ship.checkCollision(asteroids) || asteroids.size() <=0)
             gameState = GAMEOVER;
      else
      {                    
          for(int i = 0; i < bullets.size(); i++)
          {    
             bullets.get(i).update();
             bullets.get(i).render();
    
            if(bullets.get(i).checkCollision(asteroids))
            {
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
  }
  
  
  if(key=='p' && gameState==PLAY)
    gameState=PAUSE;
  else if(key=='p' && gameState==PAUSE)
    gameState=PLAY;
  
  
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
