class Bullet
{
 PVector position;
 PVector velocity;
 int radius = 5;
 PImage img = loadImage("bullet.png");


 public Bullet(PVector pos, PVector vel)
 {
    position = pos;
    velocity = vel;
 } 
 
 
 //check whether the bullet collide with any asteroid (by examining the distance to each asteroid)
 boolean checkCollision(ArrayList<Asteroid> asteroids)
 {
   for(Asteroid a : asteroids)
   {
     PVector dist = PVector.sub(position, a.position);
     if(dist.mag() < a.radius)
     { 
      a.hit(asteroids);
      return true;
     }
   }
   return false;
 }
 
 
 //update the bullet's position
 void update()
 {
   position.add(velocity);
 }
 
 
 //display the bullet
 void render()
 {    
   pushMatrix();
   translate(position.x, position.y);
   rotate(heading2D(velocity)+PI/2);
   image(img, -radius/2, -2*radius, radius, radius*5); 
   popMatrix();
 }
 
/*float heading2D(PVector pvect){
   return (float)(Math.atan2(pvect.y, pvect.x));  
}*/

}
