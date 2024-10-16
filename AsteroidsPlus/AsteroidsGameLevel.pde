import processing.sound.*;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

abstract class AsteroidsGameLevel extends GameLevel 
{
    Ship ship;
    CopyOnWriteArrayList<GameObject> asteroids;
    CopyOnWriteArrayList<GameObject> missiles;
    CopyOnWriteArrayList<GameObject> explosions;
    CopyOnWriteArrayList<GameObject> powerUps;
    protected int totalMissilesFired;
    protected int totalHits;
    public int currentStreak;   // Made public
    protected int bestStreak;    
    protected int streakBonus;     

    // HashMap to track missiles and their launch times
    private HashMap<Missile, Float> missileLaunchTimes;

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
        currentStreak = 0;   
        bestStreak = 0; 

        // Initialize the missileLaunchTimes HashMap
        missileLaunchTimes = new HashMap<Missile, Float>();
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

        // Check for missiles that have reached the screen edge
        checkMissilesAtScreenEdge();

        // Now check for missiles that have missed due to lifespan expiration
        checkForMissedMissiles();
    }

    // The game ends when there are no asteroids and the ship is active. 
    private boolean isLevelOver() 
    {
        return asteroids.size() == 0 && ship.isActive();
    }

    // Remove inactive GameObjects from their lists. 
    private void sweepInactiveObjects()
    {
        // Remove inactive missiles
        for (GameObject missile : missiles) {
            if (!missile.isActive()) {
                missiles.remove(missile);
                missileLaunchTimes.remove(missile); // Remove from tracking
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

    // Check for missiles that have reached the screen edge
    private void checkMissilesAtScreenEdge() {
        for (GameObject missileObj : missiles) {
            Missile missile = (Missile) missileObj;
            if (!missile.isActive()) continue;

            double x = missile.getX();
            double y = missile.getY();

            // Check if missile is outside the screen boundaries
            if (x < 0 || x > width || y < 0 || y > height) {
                missile.setInactive(); // Destroy the missile
                currentStreak = 0; // Reset the streak

                // Remove missile from missileLaunchTimes if tracking it
                missileLaunchTimes.remove(missile);

                // Add an explosion at the missile's position
                explosions.add(new ExplosionSmall(game, (int)x, (int)y));
            }
        }
    }

    // Check for missiles that have missed and reset the streak if necessary
    private void checkForMissedMissiles() 
    {
        float currentTime = game.millis() / 1000.0f; // Current time in seconds
        Iterator<Map.Entry<Missile, Float>> iterator = missileLaunchTimes.entrySet().iterator();

        while (iterator.hasNext()) {
            Map.Entry<Missile, Float> entry = iterator.next();
            Missile missile = entry.getKey();
            float launchTime = entry.getValue();

            // Check if missile has been active for more than 2 seconds
            if ((currentTime - launchTime) >= 2.0f) {
                if (missile.isActive()) {
                    missile.setInactive(); // Destroy the missile
                    // Add an explosion at the missile's position
                    explosions.add(new ExplosionSmall(game, (int)missile.getX(), (int)missile.getY()));
                }
                currentStreak = 0; // Reset the streak
                iterator.remove(); // Remove from tracking
            }
            else if (!missile.isActive()) {
                // Missile is inactive (e.g., hit an asteroid or destroyed at edge), remove from tracking
                iterator.remove();
            }
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

                    // Remove missile from missileLaunchTimes
                    missileLaunchTimes.remove(missile);
                }
            }
        }
    }
    
    void playSound(int streak){
        if (streak == 2) {
            soundPlayer.streakTwo();
        } else if (streak == 3) {
            soundPlayer.streakThree();
        } else if (streak == 4) {
            soundPlayer.streakFour();
        } else if (streak >= 5) {
            soundPlayer.streakFivePlus();
        }
    }

    private void checkMissileCollisions() 
    {
        for (GameObject missileObj : missiles) {
            Missile missile = (Missile) missileObj;
            if (!missile.isActive()) continue;

            for (GameObject asteroid : asteroids) {
                if (asteroid.isActive() && missile.checkCollision(asteroid)) {
                    totalHits++;            // Increment total hits
                    currentStreak++;        // Increment hit streak
                    bestStreak = Math.max(bestStreak, currentStreak);

                    missile.setInactive();
                    asteroid.setInactive();

                    // Remove missile from missileLaunchTimes
                    missileLaunchTimes.remove(missile);

                    int asteroidx = (int)asteroid.getX();
                    int asteroidy = (int)asteroid.getY();
                    explosions.add(new ExplosionSmall(game, asteroidx, asteroidy));

                    if (asteroid instanceof BigAsteroid) {
                        addSmallAsteroids(asteroid);
                    }

                    playSound(currentStreak);
                    break; // Exit the asteroid loop since the missile is inactive
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
                currentStreak = 0; // Reset streak on ship collision
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
        asteroids.add(new SmallAsteroid(game, xpos, ypos, 0, 0.02f, 44, PI*.5f));
        asteroids.add(new SmallAsteroid(game, xpos, ypos, 1, -0.01f, 44, PI*1f));
        asteroids.add(new SmallAsteroid(game, xpos, ypos, 2, 0.01f, 44, PI*1.7f));
    }

    protected void launchMissile(float speed) 
    {
        if (ship.energy >= .2) {
            int shipx = (int)ship.getX();
            int shipy = (int)ship.getY();
            
            Missile missile = new Missile(game, shipx, shipy);
            missile.setRot(ship.getRot() - 1.5708f);
            missile.setSpeed(speed);
            missiles.add(missile);

            ship.energy -= ship.deplete;

            // Increment total missiles fired
            totalMissilesFired++;

            // Add missile to missileLaunchTimes with the current time
            float launchTime = game.millis() / 1000.0f; // Convert milliseconds to seconds
            missileLaunchTimes.put(missile, launchTime);
        }
    }
}
