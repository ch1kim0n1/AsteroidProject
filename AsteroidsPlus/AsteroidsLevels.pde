/* This source code is copyrighted materials owned by the UT system and cannot be placed 
 into any public site or public GitHub repository. Placing this material, or any material 
 derived from it, in a publically accessible site or repository is facilitating cheating 
 and subjects the student to penalities as defined by the UT code of ethics. */

class AsteroidsLevel1 extends AsteroidsGameLevel 
{
  float missileSpeed = 200;
  StopWatch powerupSW;
  int periodBetweenPU = 10;
  StopWatch addAsteroidsSW;
  int periodBetweenAdds = 5;
  float asteroidSpeed;

  AsteroidsLevel1(PApplet applet)
  {
    super(applet);

    powerupSW = new StopWatch();
    addAsteroidsSW = new StopWatch();
    asteroidSpeed = 3;
  }

  void start()
  {
    super.start();

    ship = new Ship(game, width/2, height/2);

    // Example of setting the ship's sprite to a custom image. 
    //ship = new Ship(game, "ships2.png", width/2, height/2);
    //ship.setScale(.5);

    asteroids.add(new BigAsteroid(game, 200, 500, 0, 0.02, 22, PI*.5));
    asteroids.add(new BigAsteroid(game, 500, 200, 1, -0.01, 22, PI*1));

    gameState = GameState.Running;
  }

  void update() 
  {
    super.update();

    if (powerupSW.getRunTime() > periodBetweenPU) {
      powerupSW.reset();

      int centerX = game.width/2;
      int centerY = game.height/2;
      powerUps.add(new ShieldPowerup(game, centerX, centerY, 100, ship));
    }

    // TEAMS: Example of adding additional asteroids for Infinite Level
    /*
    if (addAsteroidsSW.getRunTime() > periodBetweenAdds) {
     addAsteroidsSW.reset();
     
     asteroidSpeed += 20;
     int newX = ((int)ship.getX() + game.width/2) % game.width;
     int newy = ((int)ship.getY() + game.height/2) % game.height;
     asteroids.add(new BigAsteroid(game, newX, newy, 0, 0.02, asteroidSpeed, random(0, 6.5)));
     }
     */
  }

  void drawBackground() 
  {
    // Background image must be same size as window. 
    background(background);
  }

  void drawOnScreen() 
  {
    String msg;

    // **** TEAMS: Remove this text from your delivered games. 
    fill(255);
    textSize(20);
    msg = "Ship Pos: " + (int)ship.getX() + ", " + (int)ship.getY();
    text(msg, 10, 20);
    msg = "Ship Vel: " + (int)ship.getVelX() + ", " + (int)ship.getVelY();
    text(msg, 10, 40);
    msg = "Ship Accel: " + (int)ship.getAccX() + ", " + (int)ship.getAccY();
    text(msg, 10, 60);
    msg = "Ship Speed: " + (int)ship.getSpeed();
    text(msg, 10, 80);

    ship.drawOnScreen(); // Draws Energy Bar
  }

  void keyPressed() 
  {
    if ( key == ' ') {
      if (ship.isActive()) {
        launchMissile(missileSpeed);
      }
    }
  }

  void mousePressed()
  {
  }

  private void launchMissile(float speed) 
  {
    if (ship.energy >= .2) {
      int shipx = (int)ship.getX();
      int shipy = (int)ship.getY();
      
      Missile missile = new Missile(game, shipx, shipy);
      missile.setRot(ship.getRot() - 1.5708);
      missile.setSpeed(speed);
      missiles.add(missile);

      ship.energy -= ship.deplete;
    }
  }
}

/*****************************************************/

class AsteroidsLevel2 extends AsteroidsGameLevel 
{
  float missileSpeed = 400;
  StopWatch powerupSW;
  int periodBetweenPU = 10;

  AsteroidsLevel2(PApplet applet)
  {
    super(applet);

    powerupSW = new StopWatch();
  }

  void start()
  {
    super.start();

    ship = new Ship(game, width/2, height/2);
    asteroids.add(new BigAsteroid(game, 200, 500, 0, 0.02, 22, PI*.5));
    asteroids.add(new BigAsteroid(game, 500, 200, 1, -0.01, 22, PI*1));
    asteroids.add(new BigAsteroid(game, 100, 300, 2, 0.01, 22, PI*1.7));
    asteroids.add(new BigAsteroid(game, 500, 600, 0, -0.02, 22, PI*1.3));

    gameState = GameState.Running;
  }

  void update() 
  {
    super.update();

    if (powerupSW.getRunTime() > periodBetweenPU) {
      powerupSW.reset();
      powerUps.add(new ShieldPowerup(game, game.width/2, game.height/2, 100, ship));
    }
  }

  void drawBackground() 
  {
    // Background image must be same size as window. 
    background(background);
  }
  
  void drawOnScreen() 
  {
    String msg;

    // TEAMS: Remove this text from your delivered games. 
    fill(255);
    textSize(20);
    msg = "Ship Pos: " + (int)ship.getX() + ", " + (int)ship.getY();
    text(msg, 10, 20);
    msg = "Ship Vel: " + (int)ship.getVelX() + ", " + (int)ship.getVelY();
    text(msg, 10, 40);
    msg = "Ship Accel: " + (int)ship.getAccX() + ", " + (int)ship.getAccY();
    text(msg, 10, 60);
    msg = "Ship Speed: " + (int)ship.getSpeed();
    text(msg, 10, 80);

    ship.drawOnScreen(); // Draws Energy Bar
  }

  void keyPressed() 
  {
    if ( key == ' ') {
      if (ship.isActive()) {
        launchMissile(missileSpeed);
      }
    }
  }

  void mousePressed()
  {
  }

  private void launchMissile(float speed) 
  {
    if (ship.energy >= .2) {
      int shipx = (int)ship.getX();
      int shipy = (int)ship.getY();
      Missile missile = new Missile(game, shipx, shipy);
      missile.setRot(ship.getRot() - 1.5708);
      missile.setSpeed(speed);
      missiles.add(missile);

      ship.energy -= ship.deplete;
    }
  }
}
