class Utilities {
  PImage upMan, downMan, leftMan, rightMan, scoreImg, lifeImg; // Images for the character and game objects
  int gameTime;   // Game countdown timer
  int lifeImgSpaceing = 35; // Spacing between life(heart) images when displayed on the screen

  // Constructor to initialize the images and game time
  Utilities(PImage upMan, PImage downMan, PImage leftMan, PImage rightMan, PImage scoreImg, PImage lifeImg) {
    this.upMan = upMan;
    this.downMan = downMan;
    this.leftMan = leftMan;
    this.rightMan = rightMan;
    this.scoreImg = scoreImg;
    this.lifeImg = lifeImg;
    this.gameTime = 25;
  }

  // Method to display the game over screen
  void displayGameOver() {
    background(200);  // Set background color to light gray
    fill(0);  // Set text color to black
    textSize(28);  // Set text size to 28
    textAlign(CENTER, CENTER);  // Align text to the center
    text("Game Over! You Lose. \n Your Score was :" + score, width / 2, height / 2);  // Display game over message and score
    text("Press Space to Restart ", width / 2, height / 1.5);  // Display restart instructions
  }

  // Display the game won screen when the player wins
  void displayGameWon() {
    //highestScore = max(highestScore, score);
    background(200);
    fill(0);
    textSize(28);
    textAlign(CENTER, CENTER);
    text("Congratulation! You Won. \n Your Score was :" + score, width / 2, height / 2);
    text("Press Space to Play again ", width / 2, height / 1.5);
  }

  //function to display highest score and current score on screen
  void displayScores() {
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text("Highest Score: " + highestScore, 20, 30);
    text("Score: " + score, 20, 60);
  }

// Method to update and save the highest score in file
  void updateAndSaveHighScore() {
    if (score > highestScore) {
      highestScore = score;
      highScoreManager.saveHighestScore(highestScore); // Save the new highest score to the txt file
    }
  }

  // Display the countdown timer on the screen
  void displayCountdown() {
    fill(255, 0, 0); // Set the text color to red
    textSize(30);   // Set text size to 30
    textAlign(RIGHT); // Align the text to the right
    text("Time Left: " + gameTime, width - 10, 30); // Display the remaining time at the top-right corner
  }

  int getLives() {
    return playerLives;  // Returns the current number of lives the player has left
  }

  // Display the player's remaining lives on the screen
  void displayLives() {
    fill(0);  // Set text color to black
    textSize(20);  // Set text size to 20
    textAlign(LEFT);  // Align text to the left
    text("Total lifes : ", 20, 90); // Display the label for lives

    // Loop through the remaining lives and display the life images
    for (int i = 0; i < playerLives; i++) {
      imageMode(CENTER);
      image(lifeImg, 125 + i * lifeImgSpaceing, 85); // Adjust spacing between life images while display
    }
  }

  // Decrease the player's remaining lives by 1 and check for GAME OVER condition
  void decreaseLife() {
    playerLives = playerLives -1;  // Decrease lives by 1
    if (playerLives <= 0) {
      gameState = GameState.GAME_OVER; // Transition to "Game Over" state
    }
  }

  // Display the game start screen with instructions
  void startScreen() {
    background(200, 70, 200);
    fill(0);
    textSize(28);
    textAlign(CENTER, CENTER);
    text("Instructions:\n\n" +
      "• You have 4 lives and 25 seconds.\n" +
      "• If you hit obstacles (bomb, bullet),\nyou will lose a life.\n" +
      "• If you collect an orange,\nyour score will increase by 10.\n\n" +
      "Press Enter to start the game.",
      width / 2, height / 2);
  }


  // Method to restart the game
  void restartGame() {
    score = 0;  // Reset the score to 0
    playerLives = 4;  // Reset the lives to 3
    gameTime = 25;  // Reset the game time to 25 seconds

    // Reinitialize the character with the directional images
    playerCharacter = new Character(upMan, downMan, leftMan, rightMan);
    scoreAndObstacleObjects.clear(); // Clear the obstacles list

    // Add 6 bomb obstacles to the list
    for (int i = 0; i < 6; i++) {
      Obstacle bomb = new Obstacle(random(width), random(height), obstacleSize, random(-2, 2), random(-2, 2), "bomb");
      bomb.setObstacleImage();  // Set the appropriate image for the bomb
      scoreAndObstacleObjects.add(bomb);  // Add the bomb to the obstacle list
    }
    // Add 5 bullet obstacles to the list
    for (int i = 0; i < 5; i++) {
      Obstacle bullet = new Obstacle(random(width), random(height), obstacleSize, random(-2, 2), random(-2, 2), "bullet");
      bullet.setObstacleImage();  // Set the appropriate image for the bullet
      scoreAndObstacleObjects.add(bullet);  // Add the bullet to the obstacle list
    }
    for (int i = 0; i <2; i++) { // Add 2 collectScore object to the list
      scoreAndObstacleObjects.add(new collectScore(random(width), random(height), obstacleSize, random(-2, 0), random(-2, 1), scoreImg));
    }
    gameState = GameState.PLAYING; // Reset the game state to "START"
  }


  // Updates the scores by checking for collisions with between player and collectable object
  void updateAndDisplayScores(ArrayList<Obstacle> scoreAndObstacleObjects, Character playerCharacter) {
    ArrayList<collectScore> toRemove = new ArrayList<>();   // Temporary list to track collected items for removal

    for (Obstacle o : scoreAndObstacleObjects) { // Loop through each collectible item
      if (o instanceof collectScore && o.checkCollision(playerCharacter)) {  // Check if the collectable objects collides with the character
        toRemove.add((collectScore) o); // Add the collected item to the removal list
      }
    }

    //Remove collected object from the list and add new object at random positions
    for (collectScore removed : toRemove) {
      scoreAndObstacleObjects.remove(removed);  // Remove the collected item from the list
      scoreAndObstacleObjects.add(new collectScore( //add new collectable object
        random(width), random(height), 40, random(-2, 0), random(-2, 0), removed.collectImg
        ));
    }
    displayScores(); // Call function to display the updated scores
  }
  
}
