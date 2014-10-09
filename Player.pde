class Player
{
  PVector position;
  float myWidth;
  float myHeight;
  float speed = 1.0f;
  int lives = 3;
  int score = 0;
  
  Player()
  {
    myWidth = width / 10;
    myHeight = width / 10;    
    position = new PVector(width / 2 - (myWidth / 2), height - (myHeight * 1.5f));
  }
  
  boolean collidesWith(Enemy enemy)
  {
    if (position.x > enemy.position.x + enemy.myWidth)
    {
      return false;
    }
    if (position.x + myWidth < enemy.position.x)
    {
      return false;
    }
    if (position.y > enemy.position.y + enemy.myHeight)
    {
      return false;
    }
    if (position.y + myWidth < enemy.position.y)
    {
      return false;
    }
    
    return true;
  }
  
  void update()
  {
    if (keyPressed)
    {
      if (keyCode == LEFT)
      {
        position.x -= speed;
      }
      if (keyCode == RIGHT)
      {
        position.x += speed;
      }       
    }
  }
  
  void draw()
  {
    fill(0,0,255);
    stroke(0,0,255);
    rect(position.x, position.y, myWidth, myHeight);
  }
}
