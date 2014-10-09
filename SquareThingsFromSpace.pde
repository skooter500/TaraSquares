void setup()
{
  size(500, 500);
  
  player = new Player();
  enemies = new Enemy[11];
  for (int i = 0 ; i < enemies.length ; i ++)
  {
    enemies[i] = new Enemy();
  }  
}

void setupEnemies()
{
  float gap = height / (enemies.length - 1);
  for (int i = 0 ; i < enemies.length ; i ++)
  {    
    enemies[i].position.x = random(0, width - enemies[i].myWidth);
    enemies[i].position.y = - (gap * i);
  }
}

Player player;
Enemy[] enemies;

int state = 0;
int enemyGap;

void splashState()
{
  text("Square Things from Space", 200, 200);
  text("Press any key to begin", 200, 300);
  
  if (keyPressed)
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
  text("Game Over", 50, 50);
  text("You scored: " + player.score, 50, 100);
  text("Press space key to begin again", 50, 150);
  
  if (keyPressed && key == ' ')
  {
    state = 0;
  }
}

void gameState()
{
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
            player.lives --;
            break;
          case 1:
            player.score ++;
            break;  
        }
        
      }
      enemies[i].draw();
    }        
  }  
  fill(255);
  text("Lives: " + player.lives, 10, 10);
  text("Score: " + player.score, 10, 30);
  if (player.lives == 0)
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
