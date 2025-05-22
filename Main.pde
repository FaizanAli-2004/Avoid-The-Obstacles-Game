// Declare game components: player, obstacles, scoring objects, and utilities
Character playerCharacter;
Utilities gameUtilities;
ArrayList<Obstacle> scoreAndObstacleObjects ;  // Array to hold both score and obstacle objects combined
HighScoreFile highScoreManager;

PImage backgroundImg, rightBomb, leftBomb, rightBullet, leftBullet, lifeImg; //Images for different types of obstacles and background
int playerLives = 4;  // Number of lives the player starts with
int canvasSize = 600;
int score = 0;   // Initialize the current score to 0
int highestScore = 0; // Initialize the highest score to 0
int obstacleSize = 40;  //obstacle size
int currentMillis = millis();  // Get the current time in milliseconds and store it in currentMillis
int gameTime = 25;      // Total countdown time in seconds
int previousMillis = millis();  // For tracking elapsed time

// Enum to manage game states (start, playing, game over, and game won)
enum GameState {
  START, // Game is in the start state
    PLAYING, // Game is currently being played
    GAME_OVER, // Game is over (player lost)
    GAME_WON  // Game is won (player succeeded)
}
// Declare a variable to store the current game mode
GameState gameState = GameState.START; //GameMode currentMode = GameMode.START;


void setup() {
  size(600, 600);  //set size of canvas
  backgroundImg = loadImage("Utility_Images/background.png");  // Load the background image
  backgroundImg.resize(canvasSize, canvasSize);  // Resize the background image to match the canvas size
  
  // Load character images for all possible directions
  PImage upMan = loadImage("Character_Images/man_up.png");
  PImage downMan = loadImage("Character_Images/man_down.png");
  PImage leftMan = loadImage("Character_Images/man_left.png");
  PImage rightMan = loadImage("Character_Images/man_right.png");
  PImage scoreImg = loadImage ( "Utility_Images/score.png"); //load image for the score object

  // Load images for obstacle types and directions
  rightBomb = loadImage("Obstacle_Images/right_bomb.png");
  leftBomb = loadImage("Obstacle_Images/left_bomb.png");
  rightBullet = loadImage("Obstacle_Images/right_bullet.png");
  leftBullet = loadImage("Obstacle_Images/left_bullet.png");
  lifeImg = loadImage("Utility_Images/life.png"); // Load the life image
  lifeImg.resize(30, 30); //resize the life image

 // Initialize the HighScoreManager 
  highScoreManager = new HighScoreFile();
  highestScore = highScoreManager.readHighestScore();  // Read the highest score from the file
  
  // setup the character with its directional images
  playerCharacter = new Character(upMan, downMan, leftMan, rightMan);

  // setup the utilities with character-related image
  gameUtilities = new Utilities(upMan, downMan, leftMan, rightMan, scoreImg, lifeImg);

  // Initialize the list to hold both score and obstacle objects
  scoreAndObstacleObjects = new ArrayList<Obstacle>();

  for (int i = 0; i <2; i++) { // Add 2 collectScore object to the list
    scoreAndObstacleObjects.add(new collectScore(random(width), random(height), obstacleSize, random(-2, 0), random(-2, 1), scoreImg));
  }

  for (int i = 0; i < 6; i++) {  // Add 6 bomb obstacles to the list
    Obstacle bomb = new Obstacle(random(width), random(height), obstacleSize, random(-2, 2), random(-2, 2), "bomb");
    bomb.setObstacleImage();  // Set the appropriate image for the bomb
    scoreAndObstacleObjects.add(bomb);  // Add the bomb to the list
  }
  for (int i = 0; i < 5; i++) {  // Add 5 bullet obstacles to the list
    Obstacle bullet = new Obstacle(random(width), random(height), obstacleSize, random(-2, 2), random(-2, 2), "bullet");
    bullet.setObstacleImage();  // Set the appropriate image for the bullet
    scoreAndObstacleObjects.add(bullet);  // Add the bullet to the  list
  }
}


void draw() {
  currentMillis = millis(); // Update the current time
  
  // Use a switch-case to handle different game states
  switch (gameState) {
  case START:
    gameUtilities.startScreen(); // Display the start screen
    return;

  case PLAYING:
    background(backgroundImg); // Display the background
    playerCharacter.display(); // Display the character

    // Check if one second has passed to update the countdown timer
    if (currentMillis - previousMillis >= 1000) {
      previousMillis = currentMillis; // Reset previousMillis
      gameUtilities.gameTime--; // Decrease the game time

      if (gameUtilities.gameTime <= 0) { // Time runs out
        gameState = GameState.GAME_WON; // Jump to "Game Won"
      }
    }
    gameUtilities.displayCountdown(); // Display the countdown timer

    // Handle obstacles
    ArrayList<Obstacle> obstaclesToReplace = new ArrayList<>();   // Create a list to hold obstacles that need to be replaced
    for (Obstacle o : scoreAndObstacleObjects) {   // Loop through each obstacle in the scoreAndObstacleObjects array
      o.display(); // Display obstacle
      o.updatePosition(); // Update position
      if (o.reportCollision(playerCharacter)) {  //check obstacles,scoreObject collision with player
        if (o instanceof collectScore) {
          score += 10; // Add score for collectible
        } else {
          gameUtilities.decreaseLife(); // Subtract life for obstacle collision
          obstaclesToReplace.add(o); //remove obstacles that collide
        }
      }
      if (o.isOffScreen()) {
        obstaclesToReplace.add(o); // Add off-screen obstacle for replacement
      }
    }


    // Remove off-screen obstacles and replace them with new ones
    for (Obstacle o : obstaclesToReplace) {
      o.replaceObstacle(scoreAndObstacleObjects);  // Replace the obstacle with a new one of same type
    }

    gameUtilities.updateAndDisplayScores(scoreAndObstacleObjects, playerCharacter); // Update and display scores
    gameUtilities.displayLives(); // Display remaining lives

    // Check for game over
    if (gameUtilities.getLives() <= 0) { // Ensure getLives() method exists and returns lives
      gameState = GameState.GAME_OVER; // Transition to "Game Over"
    }
    break;

  case GAME_OVER:
    gameUtilities.displayGameOver(); // Display "Game Over" screen
    gameUtilities.updateAndSaveHighScore(); //update and save the highest score in file
    break;

  case GAME_WON:
    gameUtilities.displayGameWon(); // Display "Game Won" screen
    gameUtilities.updateAndSaveHighScore(); //update and save the highest score in file
    break;
  }
}


void keyPressed() {
  // Check if the game is in the PLAYING state
  if (gameState == GameState.PLAYING) {
    if (keyCode == UP) {
      playerCharacter.facedirection('U');  // Set the character's facing direction to UP
      for (Obstacle o : scoreAndObstacleObjects) {
        o.move('D');  // Move each obstacle and scoreObejct downward
      }
    } else if (keyCode == DOWN) {
      playerCharacter.facedirection('D'); // Set the character's facing direction to DOWN
      for (Obstacle o : scoreAndObstacleObjects) {
        o.move('U');      // Move each obstacle and scoreObejct upward
      }
    } else if (keyCode == LEFT) {
      playerCharacter.facedirection('L'); // Set the character's facing direction to LEFT
      for (Obstacle o : scoreAndObstacleObjects) {
        o.move('R');    // Move each obstacle and scoreObejct right
      }
    } else if (keyCode == RIGHT) {
      playerCharacter.facedirection('R'); // Set the character's facing direction to RIGHT
      for (Obstacle o : scoreAndObstacleObjects) {
        o.move('L');  // Move each obstacle and scoreObejct left
      }
    }
  }


  // If the ENTER key is pressed and the game is in the START state, start the game
  if (key == ENTER && gameState == GameState.START) {
    gameState = GameState.PLAYING; // Change game state to PLAYING
  }

  // If the SPACE key is pressed while the game is over or won, restart the game
  if (key == ' ' && (gameState == GameState.GAME_OVER || gameState == GameState.GAME_WON)) {
    gameUtilities.restartGame();  // Call the utility method to restart the game
    gameState = GameState.PLAYING; // Change game state to PLAYING
  }
}
