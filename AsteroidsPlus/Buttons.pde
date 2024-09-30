/* This source code is copyrighted materials owned by the UT system and cannot be placed 
 into any public site or public GitHub repository. Placing this material, or any material 
 derived from it, in a publically accessible site or repository is facilitating cheating 
 and subjects the student to penalities as defined by the UT code of ethics. */

public abstract class Button
{
  public Sprite sprite;

  Button(PApplet applet, String imageFilename, int xpos, int ypos)
  {
    sprite = new Sprite(applet, imageFilename, 70);
    sprite.setXY(xpos, ypos);
    sprite.setVelXY(0, 0);
  }

  void setInactive() 
  {
    sprite.setDead(true);
    S4P.deregisterSprite(sprite);
  }

  void activateIfPressed(int xpos, int ypos)
  {
     if(sprite.isOver(xpos, ypos)) {
       onPress();
     }
  }
  
  boolean isPressed(int xpos, int ypos)
  {
    return sprite.isOver(xpos, ypos);
  }
  
  abstract public void onPress();
}


/*****************************************/


public class StartButton extends Button
{
  GameLevel level;

  StartButton(PApplet applet, int xpos, int ypos, GameLevel level)
  {
    super(applet, "Start Button.png", xpos, ypos);
    this.level = level;
  }

  public void onPress()
  {
    level.gameState = GameState.Finished;
  }
}
