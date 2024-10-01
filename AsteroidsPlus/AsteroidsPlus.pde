/* This source code is copyrighted materials owned by the UT system and cannot be placed 
 into any public site or public GitHub repository. Placing this material, or any material 
 derived from it, in a publically accessible site or repository is facilitating cheating 
 and subjects the student to penalities as defined by the UT code of ethics. */

import sprites.*;
import sprites.utils.*;
import sprites.maths.*;
import java.util.*;
import java.util.concurrent.*;
import ddf.minim.*;


GameLevel currentGameLevel; 
PImage background;

KeyboardController kbController;
SoundPlayer soundPlayer;
StopWatch stopWatch = new StopWatch();
int totalLives = 3;
int remainingLives;
float globalVolume = .2;
    Minim minim;
    AudioPlayer bgMusic;

boolean startButtonRegistered = false;

void setup() 
{
  size(1000, 700);

  // BG Image must be same size as window. 
  background = loadImage("bg.jpg");

  kbController = new KeyboardController();
  soundPlayer = new SoundPlayer(this, globalVolume);  

  currentGameLevel = new StartLevel(this);
  currentGameLevel.start();

  // register the function (pre) that will be called
  // by Processing before the draw() function. 
  registerMethod("pre", this);
  
  minim = new Minim(this);
    bgMusic = minim.loadFile("bg_music.wav");
    bgMusic.setGain(-20); // Reduce volume by 10 decibels
    bgMusic.loop();
}

// Executed before each next frame is drawn. 
void pre() 
{
  currentGameLevel.update();
  S4P.updateSprites(stopWatch.getElapsedTime()); 
  nextLevelStateMachine();
}

// Determine if the current GameLevel is finished
// and which new GameLevel is next. 
void nextLevelStateMachine()
{
  GameState state = currentGameLevel.getGameState();

  if (currentGameLevel instanceof StartLevel) {
    if (state == GameState.Finished) {
      currentGameLevel.stop(); // Stop the current GameLevel
      currentGameLevel = new AsteroidsLevel1(this); // Set the next GameLevel
      currentGameLevel.start(); // Start the new GameLevel
    }
  } else if (currentGameLevel instanceof AsteroidsLevel1) {
    if (state == GameState.Finished) {
      currentGameLevel.stop();
      currentGameLevel = new AsteroidsLevel2(this);
      currentGameLevel.start();
    } else if (state == GameState.Lost) {
      currentGameLevel.stop();
      currentGameLevel = new LoseLevel(this);
      currentGameLevel.start();
    }
  } else if (currentGameLevel instanceof AsteroidsLevel2) {
    if (state == GameState.Finished) {
      currentGameLevel.stop();
      currentGameLevel = new WinLevel(this);
      currentGameLevel.start();
    } else if (state == GameState.Lost) {
      currentGameLevel.stop();
      currentGameLevel = new LoseLevel(this);
      currentGameLevel.start();
    }
  } else if (currentGameLevel instanceof WinLevel) {
    if (state == GameState.Finished) {
      currentGameLevel.stop();
      currentGameLevel = new StartLevel(this);
      currentGameLevel.start();
    }
  } else if (currentGameLevel instanceof LoseLevel) {
    if (state == GameState.Finished) {
      currentGameLevel.stop();
      currentGameLevel = new StartLevel(this);
      currentGameLevel.start();
    }
  }
}

// Activated by Processing when a key is pressed
void keyPressed() 
{
  currentGameLevel.keyPressed();
  kbController.keyPressed(keyCode, key);
}

void keyReleased() 
{
  kbController.keyReleased(keyCode, key);
}

// Activated by Processing when the mouse button is pressed in the canvas
void mousePressed()
{
  currentGameLevel.mousePressed();
}

void draw() 
{
  background(0); // Set background to default black
  
  currentGameLevel.drawBackground();
  S4P.drawSprites();
  currentGameLevel.drawOnScreen();
}

public void stop() {
    bgMusic.close();
    minim.stop();
    super.stop();
}
