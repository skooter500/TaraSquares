import ddf.minim.*;

void setup()
{
  frame.setTitle("Tara Squares");
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
    enemies[i].setType();
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
  if (player.lives <= 0)
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
