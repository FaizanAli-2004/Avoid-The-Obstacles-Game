//class of collectScore which extends the Obstacle class
class collectScore extends Obstacle {
  private PImage collectImg; // Image to represent the collectable object

  // Constructor for collectScore that setup object
  public collectScore(float x, float y, float size, float speedX, float speedY, PImage collectImg) {
    super(x, y, size, speedX, speedY, null); // Call the superclass (Obstacle) class constructor
    this.collectImg = collectImg; // Set the image for the collectable object
  }


  // Method to display the collectable object on the screen
  public void display() {
    imageMode(CENTER);  // Set the image mode to center the image at its position
    image(collectImg, x, y, size, size); // Display the collectable image
  }

  // Change the updatePosition method to add custom behavior for the collectable object
  @Override
    public void updatePosition() {  
    super.updatePosition();  // Call the parent class method to update the position
    scoreWrapping(); // Call the method to handle wrapping the object around the screen
  }

  // Method to Wrap obstacles around the screen edges when goes off screen
  public void scoreWrapping() {
    if (x > width) x = 0;
    if (x < 0) x = width;
    if (y > height) y = 0;
    if (y < 0) y = height;
  }
}
