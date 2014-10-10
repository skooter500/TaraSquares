import ddf.minim.*;

void setup()
{
  size(500, 500);
  
  minim = new Minim(this);
  
  player = new Player();
  enemies = new Enemy[11];
  for (int i = 0 ; i < enemies.length ; i ++)
  {
    enemies[i] = new Enemy();
  }  
  
  myFont = loadFont("ComicSansMS-48.vlw");
  screenFont = loadFont("ComicSansMS-16.vlw");
  growl = minim.loadSnippet("growl.mp3");
  growl1 = minim.loadSnippet("growl1.mp3");
  textFont(myFont);
  
  images = new PImage[3];
  for (int i = 0 ; i < images.length ; i ++)
  {
    images[i] = loadImage(i + ".png");
  }  
  
  
}

void playSound(AudioSnippet snippet)
{  
  if (!snippet.isPlaying()) 
  {
    snippet.rewind(); 
    snippet.play();
  }
}

void setupEnemies()
{
  float gap = height / (enemies.length - 1);
  for (int i = 0 ; i < enemies.length ; i ++)
  {    
    enemies[i].setRandomX();
    enemies[i].position.y = - (gap * i);
  }
}

Player player;
Enemy[] enemies;
Minim minim;
AudioSnippet growl; 
AudioSnippet growl1; 
PFont myFont;
PImage[] images;
PFont screenFont;

int state = 0;
int enemyGap;

int textCount = 0;

void printMessage(String message)
{
  fill(0,0,255);
  textFont(myFont, 48);  
  textAlign(CENTER, CENTER);
  text(message, width/2, height / 2);  
}

void splashState()
{
  image(images[state], 0, 0);
  printMessage("Tara Squares!\nPress Space Key\nTo Begin");
  
  if (keyPressed && key == ' ')
  {
    player.score = 0;
    player.lives = 3;
    state ++;
    setEnemySpeed(1);
    setupEnemies();
    player.speed = 1;
  }
}

void gameOverState()
{
  image(images[state], 0, 0);

  String message = "";
  message += "Game Over\n";
  message += "You scored: " + player.score + "\n";
  message += "Press space key\nTo play again";
  printMessage(message);
  
  if (keyPressed && key == ' ')
  {
    state = 0;
  }
}

void gameState()
{
  image(images[state], 0, 0);

  player.update();
  player.draw();
  
  for (int i = 0 ; i < enemies.length ; i ++)
  {    
    enemies[i].update();
    if (enemies[i].alive)
    {
      if (player.collidesWith(enemies[i]))
      {        
        enemies[i].alive = false;
        switch(enemies[i].type)
        {
          case 0:
            playSound(growl1);
            player.lives --;
            break;
          case 1:
            playSound(growl);          
            player.score ++;
            break;  
        }
        
      }
      enemies[i].draw();
    }        
  }  
  fill(255);
  
  textFont(screenFont, 16);
  textAlign(LEFT, CENTER);
  text("Lives: " + player.lives, 10, 10);
  text("Score: " + player.score, 10, 30);
  if (player.lives < 0)
  {
    state ++;
  }
  
  if (frameCount % 300 == 0)
  {
    setEnemySpeed(enemies[0].speed + 0.25f);
    player.speed += 0.25f;
  }
}

void setEnemySpeed(float speed)
{
  for (int i = 0 ; i < enemies.length ; i ++)
  {
    enemies[i].speed = speed;
  }
}

void draw()
{
  background(127);
  switch(state)
  {
    case 0:
      splashState();
      break;
    case 1:
      gameState();
      break;
    case 2:
      gameOverState();
      break;
  }
}
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

