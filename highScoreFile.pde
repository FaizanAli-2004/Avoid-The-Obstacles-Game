public class HighScoreFile {

  // Method to save the highest score to a text file
  public void saveHighestScore(int highestScore) {
    String[] lines = { str(highestScore) };  // Convert highest score to a string and put it in an array
    saveStrings("Data/highestScore.txt", lines);  // Save the string to the file
  }

  // Method to read the highest score from a file
  public int readHighestScore() {
    String[] lines = loadStrings("highestScore.txt");  // Load the contents of the file into an array of strings
    if (lines != null && lines.length > 0) {
      return int(lines[0]);  // Return the first line(which is highestscore) converted to an integer
    }
    return 0;  // Return 0 if the file doesn't exist or is empty
  }
}
