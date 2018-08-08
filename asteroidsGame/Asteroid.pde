class Asteroid
{
 float radius;
 float omegaLimit = .05;
 PVector position;
 PVector velocity;
 PVector rotation;
 float spin;
 int col = 100;
 PImage pic;
 int health;
 float r;
 boolean special;
 
 public Asteroid(PVector pos, float radius_, PImage pics_)
 {
   radius  = radius_;
   r = random(1, 10);
   
   // Generate Normal and Special asteroids based on the random value r
   if ( r <= 9 )
   {
     health = 100;
     special = false;
   }
   else
   {
     special = true;
   }
   
   position = pos;
   float angle = random(2 * PI);
   velocity = new PVector(cos(angle), sin(angle));
   velocity.mult((50*50)/(radius*radius));
 
   angle = random(2 * PI);
   rotation = new PVector(cos(angle), sin(angle));
   spin = random(-5,5);
   pic = pics_;  
 }
 
 void hit(ArrayList<Asteroid> asteroids)
 {
   // 100HP asteroids
   if( !special )
   {
     health-=10;
     if( health <= 0 )
     {
       asteroids.remove(this);
     }
   }
   // If special asteroid
   else if ( special )
   {
     float rand = random(0, 10);
     // 30% chance of being destroyed
     if ( rand > 7 )
     {
       asteroids.remove(this);
     }
   }
 }
 
 
 //update the asteroid's position and make it spin
 void update()
 {
   position.add(velocity);
   rotate2D(rotation, radians(spin));
 }
 
 //display the asteroid
 void render()
 {
   roundBack();  
 
   pushMatrix();
   translate(position.x,position.y);
   rotate(heading2D(rotation)+PI/2);
   image(pic, -radius,-radius,radius*2, radius*2);
   popMatrix();
     
 }
 
 void roundBack()
 {
    if (position.x < 0)
      position.x = width;
    
    if (position.y < 0) 
      position.y = height;
    
    if (position.x > width) 
      position.x = 0;
    
    if (position.y > height)
      position.y = 0;     
 }
 


/* float heading2D(PVector pvect)
 {
   return (float)(Math.atan2(pvect.y, pvect.x));  
 }

 void rotate2D(PVector v, float theta) 
 {
   float xTemp = v.x;
   v.x = v.x*cos(theta) - v.y*sin(theta);
   v.y = xTemp*sin(theta) + v.y*cos(theta);
 }*/
 
}
