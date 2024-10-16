/* This source code is copyrighted materials owned by the UT system and cannot be placed 
into any public site or public GitHub repository. Placing this material, or any material 
derived from it, in a publically accessible site or repository is facilitating cheating 
and subjects the student to penalities as defined by the UT code of ethics. */

import processing.sound.*;

class SoundPlayer 
{
  SoundFile boomPlayer, popPlayer, gameOverPlayer;
  SoundFile k2, k3, k4, k5;
  SoundFile explosionLargeAsteroid, explosionShip, explosionSmallAsteroid;
  SoundFile ohYea, missileLaunch;
  
  SoundPlayer(PApplet app, float globalVolume) 
  {
    boomPlayer = new SoundFile(app, "explode.wav"); 
    boomPlayer.amp(globalVolume);
    
    gameOverPlayer = new SoundFile(app, "ThatsAllFolks.wav"); 
    gameOverPlayer.amp(globalVolume);
    
    k2 = new SoundFile(app, "k2.wav");
    k3 = new SoundFile(app, "k3.wav");
    k4 = new SoundFile(app, "k4.wav");
    k5 = new SoundFile(app, "k5.wav");
    
    k2.amp(globalVolume);
    k3.amp(globalVolume);
    k4.amp(globalVolume);
    k5.amp(globalVolume);
    
    popPlayer = new SoundFile(app, "pop.wav");
    popPlayer.amp(globalVolume);
    
    explosionLargeAsteroid = new SoundFile(app, "LargAsteroidExplosion.wav");
    explosionLargeAsteroid.amp(globalVolume);
    
    explosionSmallAsteroid = new SoundFile(app, "SmallAsteroidExplosion.wav");
    explosionSmallAsteroid.amp(globalVolume);
    
    explosionShip = new SoundFile(app, "ExplosionShip.wav");
    explosionShip.amp(globalVolume);
    
    ohYea = new SoundFile(app, "OhYea.wav");
    ohYea.amp(globalVolume);
    
    missileLaunch = new SoundFile(app, "MissileLaunch.wav");
    missileLaunch.amp(globalVolume);
  }

  void playExplosion() 
  {
    boomPlayer.play();
    boomPlayer.amp(0.2);
  }

  void playPop() 
  {
    popPlayer.play();
  }

  void playGameOver() 
  {
    gameOverPlayer.play();
  }
  
  void playExplosionLargeAsteroid() 
  {
    explosionLargeAsteroid.play();
    explosionLargeAsteroid.amp(0.2);
  }

  void playExplosionSmallAsteroid() 
  {
    explosionSmallAsteroid.play();
    explosionSmallAsteroid.amp(0.2);
  }
  
  void playExplosionShip() 
  {
    explosionShip.play();
    explosionShip.amp(0.2);
  }

  void playOhYea() 
  {
    ohYea.play();
  }

  void playMissileLaunch() 
  {
    missileLaunch.play();
  }
  
   void streakTwo(){
    k2.play();
  }
     void streakThree(){
    k3.play();
  }
 void streakFour(){
    k4.play();
  }
 void streakFivePlus(){
    k5.play();
  }
}
