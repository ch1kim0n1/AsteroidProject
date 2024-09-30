/* This source code is copyrighted materials owned by the UT system and cannot be placed 
into any public site or public GitHub repository. Placing this material, or any material 
derived from it, in a publically accessible site or repository is facilitating cheating 
and subjects the student to penalities as defined by the UT code of ethics. */

class KeyboardController
{
  boolean space, up, down, left, right;
  
  void keyPressed(int code, int key)
  {
    switch(key) {
      case ' ':
        space = true;
        break;
    }
    
    switch(code) {
      case UP:
        up = true;
        break;
      case DOWN:
        down = true;
        break;
      case LEFT:
        left = true;
        break;
      case RIGHT:
        right = true;
        break;
    }
    
  }
  
  void keyReleased(int code, int key)
  {
    switch(key) {
      case ' ':
        space = false;
        break;
    }

    switch(code) {
      case UP:
        up = false;
        break;
      case DOWN:
        down = false;
        break;
      case LEFT:
        left = false;
        break;
      case RIGHT:
        right = false;
        break;
    }
  }
  
  boolean isUp() 
  {
    return up;
  }

  boolean isDown() 
  {
    return down;
  }

  boolean isLeft() 
  {
    return left;
  }

  boolean isRight() 
  {
    return right;
  }

  boolean isSpace() 
  {
    return space;
  }
}
