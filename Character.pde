class Character {
  private int x = width/2;        //Initial x-value
  private int y = height/2;       //Initial y-value
  private int imageWidth =50 ;          // Default width
  private int imageHeight = 30;         // Default height
  private char direction = 'U';       // Default direction (right)
  private PImage upMan, downMan, leftMan, rightMan, currentImage;       //Images for different directions

  // Constructor to set-up the character
  public Character(PImage upMan, PImage downMan, PImage leftMan, PImage rightMan) {
    this.upMan = upMan;
    this.downMan = downMan;
    this.leftMan = leftMan;
    this.rightMan = rightMan;
    currentImage = upMan; // Default image is facing up
  }

  // Method to display the character's current image at the provided position
  public void display() {
    imageMode(CENTER); // Center the image when displaying
    image(currentImage, x - imageWidth/ 2, y - imageHeight/ 2, imageWidth, imageHeight); // Draw the character
  }

  // Update the character's direction, corresponding image and Set the width and height of the image
  public void facedirection(char dir) {
    direction = dir;
    // Change the character's image based on the direction
    if (direction == 'L' || direction == 'R') {  //check if characyer direction is left or rigt, choose appropriate image
      currentImage = (direction == 'L') ? leftMan : rightMan;
      imageWidth = 30;  //setImageWidth
      imageHeight= 50;  //setImageHeight
    } else if (direction == 'U' || direction == 'D') {
      currentImage = (direction == 'U') ? upMan : downMan;
      imageWidth= 50;
      imageHeight = 30;
    }
  }


  // Getter methods  to access private variable
  public int getX() {
    return x;  // Returns the current X position 
  }

  public int getY() {
    return y;
  }

  public int getImageWidth() {
    return imageWidth;  // Returns the width of the character's current image
  }

  public int getImageHeight() {
    return imageHeight;
  }
}
