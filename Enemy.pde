class Enemy
{
  PVector position;
  float myWidth;
  float myHeight;
  float speed = 1.0f;
  int type;
  boolean alive = true;
  
  void setType()
  {
    if ((int) random(0,5) == 1)
    {
      type = 1;
    }
    else
    {
      type = 0;
    }
  }
  
  Enemy()
  {
    myWidth = width / 10;
    myHeight = width / 10;
    
    position = new PVector(width / 2 - (myWidth / 2), height - (myHeight * 1.5f));
    
    setType();
  }
  
  void setRandomX()
  {
      int spaces = width / (int)myWidth;            
      position.x = (int) random(0, spaces) * myWidth;      
  }
  
  void update()
  {
    position.y += speed;
    if (position.y > height)
    {
      position.y = - myHeight;
      setRandomX();
      if (! alive)
      {
        alive = true;
      }
      setType();
    }
  }
  
  void draw()
  {
    switch (type)
    {
      case 0:
        stroke(0);
        fill(0);
        break;
      case 1:
        stroke(255, 0,0);
        fill(255, 0,0);        
    }
    rect(position.x, position.y, myWidth - 1, myHeight - 1);
  }
}
