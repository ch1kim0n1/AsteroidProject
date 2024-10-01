abstract class AsteroidsGameLevel extends GameLevel 
{
    Ship ship;
    CopyOnWriteArrayList<GameObject> asteroids;
    CopyOnWriteArrayList<GameObject> missiles;
    CopyOnWriteArrayList<GameObject> explosions;
    CopyOnWriteArrayList<GameObject> powerUps;
    protected int totalMissilesFired;
    protected int totalHits;

    AsteroidsGameLevel(PApplet game)
    {
        super(game);
        this.game = game;

        missiles = new CopyOnWriteArrayList<GameObject>();
        explosions = new CopyOnWriteArrayList<GameObject>();
        powerUps = new CopyOnWriteArrayList<GameObject>();
        asteroids = new CopyOnWriteArrayList<GameObject>();

        totalMissilesFired = 0;
        totalHits = 0;
    }

    void start() {
        // Not Used
    } 

    // Remove all GameObjects from the Level
    void stop()
    {
        ship.setInactive();
        for (GameObject missile : missiles) {
            missile.setInactive();
        }
        for (GameObject asteroid : asteroids) {
            asteroid.setInactive();
        }
        for (GameObject explosion : explosions) {
            explosion.setInactive();
        }
        for (GameObject powerup : powerUps) {
            powerup.setInactive();
        }

        sweepInactiveObjects();
    }

    void restart() {
        // Not Used
    } 

    void update() 
    {
        sweepInactiveObjects();
        updateObjects();

        if (isLevelOver()) {
            gameState = GameState.Finished;
        } 

        checkShipCollisions();
        checkMissileCollisions();
        checkPowerUpCollisions();
    }

    // The game ends when there are no asteroids and the ship is active. 
    private boolean isLevelOver() 
    {
        if (asteroids.size() == 0 && ship.isActive()) {
            return true;
        } else {
            return false;
        }
    }

    // Remove inactive GameObjects from their lists. 
    private void sweepInactiveObjects()
    {
        // Remove inactive missiles
        for (GameObject missile : missiles) {
            if (!missile.isActive()) {
                missiles.remove(missile);
            }
        }

        // Remove inactive asteroids
        for (GameObject asteroid : asteroids) {
            if (!asteroid.isActive()) {
                asteroids.remove(asteroid);
            }
        }

        // Remove inactive explosions
        for (GameObject explosion : explosions) {
            if (!explosion.isActive()) {
                explosions.remove(explosion);
            }
        }

        // Remove inactive PowerUps
        for (GameObject powerUp : powerUps) {
            if (!powerUp.isActive()) {
                powerUps.remove(powerUp);
            }
        }
    }

    // Cause each GameObject to update their state.
    private void updateObjects()
    {
        ship.update();

        for (GameObject asteroid : asteroids) {
            if (asteroid.isActive()) asteroid.update();
        }
        for (GameObject missile : missiles) {
            if (missile.isActive()) missile.update();
        }
        for (GameObject explosion : explosions) {
            if (explosion.isActive()) explosion.update();
        }
        for (GameObject powerUp : powerUps) {
            if (powerUp.isActive()) powerUp.update();
        }
    }

    // Check PowerUp to Missile collisions
    private void checkPowerUpCollisions() 
    {
        if (!ship.isActive()) return;

        for (GameObject powerUp : powerUps) {
            for (GameObject missile : missiles) {
                if (powerUp.isActive() && missile.isActive() && powerUp.checkCollision(missile)) {
                    ((PowerUp)powerUp).activate();
                    powerUp.setInactive();
                    missile.setInactive();
                    totalHits++;
                }
            }
        }
    }

    // Check missile to asteroid collisions
    private void checkMissileCollisions() 
    {
        if (!ship.isActive()) return;

        // Find and process missile - asteroid collisions
        for (GameObject missile : missiles) {
            for (GameObject asteroid : asteroids) {
                if (asteroid.isActive() && missile.isActive() && missile.checkCollision(asteroid)) {
                    totalHits++; // Increment total hits
                    missile.setInactive();
                    asteroid.setInactive();
                    int asteroidx = (int)asteroid.getX();
                    int asteroidy = (int)asteroid.getY();
                    explosions.add(new ExplosionSmall(game, asteroidx, asteroidy));
                    if (asteroid instanceof BigAsteroid) {
                        addSmallAsteroids(asteroid);
                    }
                }
            }
        }
    }

    // Check ship to asteroid collisions
    private void checkShipCollisions() 
    {
        if (!ship.isActive()) return;

        // Asteroids don't collide with ship when created and placed at center 
        if (ship.getX() == width/2 && ship.getY() == height/2) return;

        for (GameObject asteroid : asteroids) {
            if (asteroid.isActive() && !ship.isShielded() && ship.checkCollision(asteroid)) {

                int shipx = (int)ship.getX();
                int shipy = (int)ship.getY();
                explosions.add(new ExplosionLarge(game, shipx, shipy));

                ship.setInactive();
                remainingLives = remainingLives - 1;
                if (remainingLives > 0) {
                    ship = new Ship(game, width/2, height/2);
                } else {
                    gameState = GameState.Lost;
                }

                asteroid.setInactive();
                if (asteroid instanceof BigAsteroid) {
                    addSmallAsteroids(asteroid);
                }

                break; // Only happens once
            }
        }
    }

    private void addSmallAsteroids(GameObject go) 
    {
        int xpos = (int)go.getX();
        int ypos = (int)go.getY();
        asteroids.add(new SmallAsteroid(game, xpos, ypos, 0, 0.02, 44, PI*.5));
        asteroids.add(new SmallAsteroid(game, xpos, ypos, 1, -0.01, 44, PI*1));
        asteroids.add(new SmallAsteroid(game, xpos, ypos, 2, 0.01, 44, PI*1.7));
    }
}
