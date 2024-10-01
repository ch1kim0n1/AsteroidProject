class AsteroidsLevel1 extends AsteroidsGameLevel 
{
  float missileSpeed = 200;
  StopWatch powerupSW;
  int periodBetweenPU = 10;
  StopWatch addAsteroidsSW;
  int periodBetweenAdds = 5;
  float asteroidSpeed;

  // Variables to track missiles fired and hits
  int missilesFired = 0;
  int missilesHit = 0;

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

    // Collision detection between missiles and asteroids
    for (int i = missiles.size() - 1; i >= 0; i--) {
      GameObject missileObj = missiles.get(i);
      for (int j = asteroids.size() - 1; j >= 0; j--) {
        GameObject asteroidObj = asteroids.get(j);
        if (missileObj.collidesWith(asteroidObj)) {
          missiles.remove(i);
          asteroidObj.hitBy(missileObj); // Handle asteroid destruction
          missilesHit++;
          break; // Exit the inner loop since the missile is destroyed
        }
      }
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

    // Calculate and display hit ratio
    float hitRatio = (missilesFired > 0) ? ((float)missilesHit / missilesFired) : 0;
    msg = String.format("Hit Ratio: %.2f%%", hitRatio * 100);
    text(msg, 10, 100);

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

      missilesFired++; // Increment missiles fired

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

  // Variables to track missiles fired and hits
  int missilesFired = 0;
  int missilesHit = 0;

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

    // Collision detection between missiles and asteroids
    for (int i = missiles.size() - 1; i >= 0; i--) {
      GameObject missileObj = missiles.get(i);
      for (int j = asteroids.size() - 1; j >= 0; j--) {
        GameObject asteroidObj = asteroids.get(j);
        if (missileObj.collidesWith(asteroidObj)) {
          missiles.remove(i);
          asteroidObj.hitBy(missileObj); // Handle asteroid destruction
          missilesHit++;
          break; // Exit the inner loop since the missile is destroyed
        }
      }
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

    // Calculate and display hit ratio
    float hitRatio = (missilesFired > 0) ? ((float)missilesHit / missilesFired) : 0;
    msg = String.format("Hit Ratio: %.2f%%", hitRatio * 100);
    text(msg, 10, 100);

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

      missilesFired++; // Increment missiles fired

      ship.energy -= ship.deplete;
    }
  }
}
