class Obstacle {
  protected float x, y, size, bulletHeight, speedX, speedY;  // Position, size, bulletHeight and speed of the obstacle
  protected PImage obstacleImage;     // Images for bomb directions
  protected boolean hasCollided = false;      // Flag to indicate if the obstacle has collided
  protected String type;                      // Type of obstacle (e.g., "bomb", "bullet")

  //Constrcutor to setup obsttacle properties and type
  public Obstacle(float x, float y, float size, float speedX, float speedY, String type) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.bulletHeight =size/2;
    this.speedX = speedX;
    this.speedY = speedY;
    this.type = type != null ? type : "";  // Set type or default to empty string
  }

  // Display the obstacle
  public void display() {
    imageMode(CENTER); // Center the image when displaying

    // If the obstacle is a bullet, use the bulletWidth for the width
    if ("bullet".equals(type)) {
      image(obstacleImage, x, y, size, bulletHeight);  // Bullet has custom width (bulletWidth) and default height (size)
    } else {
      image(obstacleImage, x, y, size, size);  // Bomb use default width (size)
    }
  }

  // Update the obstacle's position
  public void updatePosition() {
    x += speedX; // Update x-position
    y += speedY;  // Update y-position
  }

  //Set the obstacle's image based on its type and direction
  public void setObstacleImage() {
    if ("bomb".equals(type)) {
      this.obstacleImage = (speedX > 0) ? rightBomb : leftBomb;  // Use bomb images
    } else if ("bullet".equals(type)) {
      this.obstacleImage = (speedX > 0) ? rightBullet :leftBullet ;    // Use bullet images
    } else {
      this.obstacleImage = null; 
    }
  }

  // Checks if the obstacle is off-screen
  public boolean isOffScreen() {
    return x < -size || x > width + size || y < -size || y > height + size;
  }
  
//// Method to check if obstacles have collided with character
  public boolean checkCollision(Character c) {
    float obstacleHeight = "bullet".equals(type) ? bulletHeight : size;   // check obstacle type, if bullet then use bulletHeight for "bullet", else use size.

    // Check if the objects overlap on the X axis (left to right)
    boolean overlapX = (x + size / 2 > c.getX() - c.getImageWidth() / 2) && (x - size / 2 < c.getX() + c.getImageWidth() / 2);

    // Check if the objects overlap on the Y axis (up and down)
    boolean overlapY = (y + obstacleHeight / 2 > c.getY() - c.getImageHeight() / 2) && (y - obstacleHeight / 2 < c.getY() + c.getImageHeight() / 2-28);
    
    return overlapX && overlapY; // Return true if both X and Y overlap, meaning a collision happened
  }


  //Check and Report a collision with the character
  public  boolean reportCollision(Character c) {
    if (checkCollision(c) && !hasCollided ) { // If a collision is detected
      hasCollided = true; // Mark as collided
      return true; // Return true to indicate a collision
    }
    hasCollided = false; // Reset collision when no longer colliding
    return false; // Return false if no collision is detected
  }


  // Replace the current obstacle with a new one of the same type
  public void replaceObstacle(ArrayList<Obstacle> obstacles) {
    obstacles.remove(this); // Removes the current obstacle from the list

    // Adds a new obstacle (bomb or bullet)  based on the current object type
    Obstacle newObstacle;
    if ("bomb".equals(this.type)) {
      newObstacle = new Obstacle(random(width), random(height), obstacleSize, random(-2, 2), random(-2, 2), "bomb");
    } else {
      newObstacle = new Obstacle(random(width), random(height), obstacleSize, random(-2, 2), random(-2, 2), "bullet");
    }
    newObstacle.setObstacleImage();  // Set the image for the new obstacle
    newObstacle.edgeStart();  // Set the obstacle to spawn at edge
    obstacles.add(newObstacle); // Add the new obstacle to the list
  }



  //Method to move obstacles
  public void move(char dir) {
    if (dir == 'U') {   // Move downward
      y -= 20;
    } else if (dir == 'D') {   // Move upward
      y += 20;
    } else if (dir == 'L') { // Move left
      x -= 20;
    } else if (dir == 'R') { // Move right
      x += 20;
    }
  }


  // Method to randomly set the starting position of an object at one of the four edges of the screen
  public void edgeStart() {
    int edge = (int) random(4); /// Randomly select an edge ( 0: left, 1: right, 2: top, 3: bottom)
    if (edge == 0) { // Left edge, set x to 100 and y to random value within screen for starting
      x = 100;
      y = random(height);
    } else if (edge == 1) { // Right edge, set x to right edge and y to random value within screen for starting
      x = width;
      y = random(height);
    } else if (edge == 2) { // Top edge, set y to 100 and x to random value within screen for starting
      x = random(width);
      y = 100;
    } else { // Bottom edge, set y to bottom edge and x to random value within screen for starting
      x = random(width);
      y = height;
    }
  }
}
