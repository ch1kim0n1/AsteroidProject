/* This source code is copyrighted materials owned by the UT system and cannot be placed 
 into any public site or public GitHub repository. Placing this material, or any material 
 derived from it, in a publically accessible site or repository is facilitating cheating 
 and subjects the student to penalities as defined by the UT code of ethics. */

public enum GameState
{
  NotRunning, 
    Running, 
    Finished, 
    Lost;
}

/***********************************************/


abstract class GameLevel 
{
  PApplet game;
  GameState gameState; 

  GameLevel(PApplet applet)
  {
    this.game = applet;
    gameState = GameState.NotRunning;
  }

  GameState getGameState()
  {
    return gameState;
  }

  // Initialize all the resources needed by the level
  void start() { }

  // Deallocate the resources maintained by the level
  void stop() { }

  // Reinitialize the resources maintained by the level.
  void restart() { }

  // Called every frame to update the resources maintained by the level.
  void update() { }

  // Use raw Processing to draw the level's background.
  void drawBackground() { }
  
  // Use raw Processing operations to draw on the screen.
  void drawOnScreen() { }

  // Called when a key is pressed in the active level. 
  // Use Processing's builtin variable 'key;  to determine which key
  void keyPressed() { }

  // Called when mouse button is pressed in the active level. 
  // Use Processing's builtin variables mouseX, mouseY, mouseButton
  void mousePressed() { }
}


/*********************************************/


class StartLevel extends GameLevel
{
  StartButton startButton;

  StartLevel(PApplet game)
  {
    super(game);
    gameState = GameState.NotRunning;
  }

  void start()
  {
    startButton = new StartButton(game, width/2, height/2, this);
    remainingLives = totalLives;
    gameState = GameState.Running;
  }

  void stop()
  {
    startButton.setInactive();
  }

  void restart()
  {
  }

  void update()
  {
  }

  GameState getGameState()
  {
    return gameState;
  }

  void drawBackground() 
  {
      // Background image must be same size as window. 
      background(background);
  }
  
  void drawOnScreen()
  {
  }

  void keyPressed()
  {
  }

  void mousePressed()
  {
    // mouseX and mouseY are builtin Processing varibles with the canvas location where 
    // the mouse button was pressed
    startButton.activateIfPressed(mouseX, mouseY);
    
    // Alternative method of activating a button...
    //if (startButton.isPressed(mouseX, mouseY)) {
    //  startButton.onPress();
    //}
  }
}


/*********************************************/


class LoseLevel extends GameLevel
{
  GameOver gameOver;

  LoseLevel(PApplet applet)
  {
    super(applet);
  }

  void start()
  {
    gameOver = new GameOver(game, width/2, height/2);
    gameOver.setActive();

    soundPlayer.playGameOver();
    gameState = GameState.Running;
  }

  void stop()
  {
    gameOver.setInactive();
  }

  void restart()
  {
  }

  void update()
  {
    gameOver.update();
    if (!soundPlayer.gameOverPlayer.isPlaying()) {
       gameState = GameState.Finished;
    }
  }

  void drawBackground() 
  {
    // Background image must be same size as window. 
    background(background);
  }
  
  void drawOnScreen()
  {
  }

  void keyPressed()
  {
  }

  void mousePressed()
  {
  }
}


/*********************************************/


class WinLevel extends GameLevel
{
  OhYea ohYea;
  Ship ship;
  float scale = 0;
  float scaleInc = .05;
 
  WinLevel(PApplet applet)
  {
    super(applet);
  }

  void start()
  {
    soundPlayer.playOhYea();

    ohYea = new OhYea(game, width/2, height/2);
    ohYea.setXY(width/2, height/2);
    ohYea.setRot(0);
    ohYea.setActive();

    ship = new Ship(game, width/2, height/2);
    gameState = GameState.Running;
  }

  void stop()
  {
    ohYea.setInactive();
    ship.setInactive();
  }

  void restart()
  {
  }

  void update()
  {
    // Stop animation when sound ends.    
    if (soundPlayer.ohYea.isPlaying()) {
      ohYea.update();

      // Manipulate the ship directly.
      scale += scaleInc;
      ship.setScale(abs(cos(scale)*1.5));
      ship.setX((cos(scale) * 100) + width/2);
      ship.setY((sin(scale) * 200) + height/2);
      ship.setRot((sin(scale) * PI));
    } 
    else {
      gameState = GameState.Finished;
    }
  }

  void drawBackground() 
  {
    // Background image must be same size as window. 
    background(background);
  }
  
  void drawOnScreen()
  {
  }

  void keyPressed()
  {
  }

  void mousePressed()
  {
  }
}
