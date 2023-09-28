int numImages = 5;
int counter = 0;
int canvasSize = 48;
int pixelSize = 1;

int dark = 30;
int light = 60;
int white = 30;
int tetris = 47;

void setup() {
  size(48, 48);
  noStroke();
  loop() ;
}

ArrayList<PVector> drawnBlocks = new ArrayList<PVector>();

void draw() {

  background(218, 242, 218);
  fill(130, 144, 130);
  rect(14, 42, 20, 1);

  //for (int i = 0; i < white; i++) {
  //  int x = int(random(0, canvasSize));
  //  int y = int(random(0, canvasSize));
  //  fill(255, 255, 255, calculateOpacity(x, y));
  //  rect(x, y, pixelSize, pixelSize);
  //}

  //for (int i = 0; i < light; i++) {
  //  int x = round(random(0, canvasSize));
  //  int y = round(random(0, canvasSize));
  //  fill(229, 255, 229, calculateOpacity(x, y));
  //  rect(x, y, pixelSize, pixelSize);
  //}

  //for (int i = 0; i < dark; i++) {
  //  int x = round(random(0, canvasSize));
  //  int y = round(random(0, canvasSize));
  //  fill(195, 217, 195, calculateOpacity(x, y));
  //  rect(x, y, pixelSize, pixelSize);
  //}

  //for (int i = 0; i < tetris; i++) {
  //  int x = round(random(0, canvasSize));
  //  int y = round(random(0, canvasSize));
  //  fill(195, 217, 195, calculateOpacity(x, y));
  //  drawRandomTetromino(x, y);
  //}


  save("bg_tetris_4.png");
  counter++;

  if (counter < numImages) {
    loop();
  } else {
    noLoop();
  }
}

void drawSkull(int x, int y) {
  int[][] skull = {
    {0, 1, 0, 1, 0},
    {1, 0, 1, 0, 1},
    {1, 1, 1, 1, 1},
    {0, 1, 1, 1, 0},
    {0, 0, 1, 0, 0}
  };

  int skullWidth = skull[0].length;
  int skullHeight = skull.length;
  int pixelSize = 1;

  fill(0);  // Black color for the skull

  for (int i = 0; i < skullHeight; i++) {
    for (int j = 0; j < skullWidth; j++) {
      if (skull[i][j] == 1) {
        rect(x + j * pixelSize, y + i * pixelSize, pixelSize, pixelSize);
      }
    }
  }
}

void drawRandomTetromino(int x, int y) {
  int[][][] tetrominos = {
    { {1, 1, 1, 1}, {0, 0, 0, 0} }, // I
    { {1, 1, 1, 0}, {1, 0, 0, 0} }, // T
    { {1, 1}, {1, 1} }, // O
    { {1, 1, 0}, {0, 1, 1} }, // S
    { {0, 1, 1}, {1, 1, 0} }, // Z
    { {1, 1, 1}, {1, 0, 0} }, // L
    { {1, 1, 1}, {0, 0, 1} }  // J
  };

  int[][] chosenTetromino = tetrominos[int(random(tetrominos.length))];
  int r = int(random(4));
  int[][] rotatedTetromino = rotateTetromino(chosenTetromino, r);

  int maxX = 0;
  int maxY = 0;
  for (int i = 0; i < rotatedTetromino.length; i++) {
    maxX = max(maxX, rotatedTetromino[i].length);
    if (rotatedTetromino[i].length > 0) {
      maxY = i + 1;
    }
  }
  x = constrain(x, 1, canvasSize - maxX * pixelSize - 1); // 1 pixel from the edge
  y = constrain(y, 1, canvasSize - maxY * pixelSize - 1); // 1 pixel from the edge

  while (!isPositionValid(x, y, rotatedTetromino)) {
    x = constrain(round(random(0, canvasSize)), 1, canvasSize - maxX * pixelSize - 1);
    y = constrain(round(random(0, canvasSize)), 1, canvasSize - maxY * pixelSize - 1);
  }

  for (int i = 0; i < rotatedTetromino.length; i++) {
    for (int j = 0; j < rotatedTetromino[i].length; j++) {
      if (rotatedTetromino[i][j] == 1) {
        rect(x + j * pixelSize, y + i * pixelSize, pixelSize, pixelSize);
        drawnBlocks.add(new PVector(x + j * pixelSize, y + i * pixelSize));
      }
    }
  }
}

int[][] rotateTetromino(int[][] tetromino, int r) {
  for (int i = 0; i < r; i++) {
    tetromino = rotateRight(tetromino);
  }
  return tetromino;
}

int[][] rotateRight(int[][] matrix) {
  int rows = matrix.length;
  int cols = matrix[0].length;
  int[][] newMatrix = new int[cols][rows];

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (j < matrix[i].length) {
        newMatrix[j][rows - i - 1] = matrix[i][j];
      } else {
        newMatrix[j][rows - i - 1] = 0;
      }
    }
  }
  return newMatrix;
}

boolean isPositionValid(int x, int y, int[][] tetromino) {
  for (int i = 0; i < tetromino.length; i++) {
    for (int j = 0; j < tetromino[i].length; j++) {
      if (tetromino[i][j] == 1) {
        for (PVector block : drawnBlocks) {
          if (dist(block.x, block.y, x + j * pixelSize, y + i * pixelSize) < 3) {  // 3 pixels apart
            return false;
          }
        }
      }
    }
  }
  return true;
}

float getRandomRotationValue() {
  int randomIndex = int(random(12));
  float rotationValue = radians(30 * randomIndex);
  return rotationValue;
}

int calculateOpacity(float rectX, float rectY) {
  float distToCenter = dist(rectX, rectY, canvasSize/2, canvasSize/2);
  float maxDist = dist(0, 0, canvasSize/2, canvasSize/2);
  return int(map(distToCenter, 0, maxDist, 26, 255));
}
