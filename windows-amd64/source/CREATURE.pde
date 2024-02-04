class Creature {
  Network Brain;

  float CreatureX, CreatureY;
  float CreatureRadius = 14;
  boolean alive;

  ////EVOLUTIONARY
  float sensorLength = 40;

  public Creature(float CreatureX, float CreatureY) {
    Brain = new Network(layerSizes);
    this.CreatureX = CreatureX;
    this.CreatureY = CreatureY;
    this.alive = true;
  }

  void Run() {
    Enemy e = enemies.get(0);
    float normalisedTimeElapsed = simulationFrame / SIMULATION_FRAMES_PER_LIFETIME;
    float normalisedCreatureX = (CreatureX - (BOX_BORDER_X1/2))/((BOX_BORDER_X2 - BOX_BORDER_X1)/2);
    float normalisedCreatureY = (CreatureY - (BOX_BORDER_Y1/2))/((BOX_BORDER_Y2 - BOX_BORDER_Y1)/2);
    float normalisedEnemyX = (e.enemyX - BOX_BORDER_X1)/(BOX_BORDER_X2 - BOX_BORDER_X1);
    float normalisedEnemyY = (e.enemyY - BOX_BORDER_Y1)/(BOX_BORDER_Y2 - BOX_BORDER_Y1);
    float normalisedEnemyVelX = e.vel.x/enemySpeed;
    float normalisedEnemyVelY = e.vel.y/enemySpeed;
    float[] inputsNormalised = {normalisedCreatureX, normalisedCreatureY, normalisedEnemyX, normalisedEnemyY, normalisedEnemyVelX, normalisedEnemyVelY};

    float[] proportionConfidences = Brain.Predict(inputsNormalised);
    for (int direction = 0; direction < 4; direction++) {
      float confidence = proportionConfidences[direction] * 100;
      if (random(100) <= confidence) {
        for (int i = 0; i < 15; i++) {
          Move(direction);
        }
      }
    }

    checkBoundary();
  }
  void Move(int direction) {
    switch(direction) {
    case 0:
      moveRight();
      break;
    case 1:
      moveDown();
      break;
    case 2:
      moveLeft();
      break;
    case 3:
      moveUp();
      break;
    }
  }

  void moveLeft() {
    CreatureX--;
  }
  void moveRight() {
    CreatureX++;
  }
  void moveUp() {
    CreatureY--;
  }
  void moveDown() {
    CreatureY++;
  }

  void checkBoundary() {
    CreatureX = constrain(CreatureX, BOX_BORDER_X1, BOX_BORDER_X2);
    CreatureY = constrain(CreatureY, BOX_BORDER_Y1, BOX_BORDER_Y2);
  }

  void Display() {
    noStroke();
    fill(255);
    circle(CreatureX, CreatureY, CreatureRadius * 2);
  }
}
