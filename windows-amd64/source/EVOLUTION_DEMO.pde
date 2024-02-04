import processing.pdf.*;

/*MOUSE*/
boolean mouseDown = false;

/*SIMULATION PARAMETERS*/
float BOX_BORDER_X1 = -1200;
float BOX_BORDER_X2 = 1200;
float BOX_BORDER_Y1 = -1200;
float BOX_BORDER_Y2 = 1200;

int N_CREATURES = 300;
int N_ENEMIES = 1;
int SIMULATION_SPEED = 0;
int SIMULATION_FRAMES_PER_LIFETIME = 4500;

int nCreaturesAlive;
int currentGeneration = 0;
int simulationFrame = 1;
float lastGenMeanFitness = 0;
float lastGenMedianFitness = 0;

/*EVOLUTIONARY PARAMETERS*/
int[] layerSizes = {6, 4, 4, 4};  //input layer, {hidden layers}, output layer
float survivalProportion = 0.02;  //what proportion of the population carries on to reproduce
float mutationIntensity = 0.4;
//float[][] spawnLocations = {{-300, -300}, {800, -300}, {1900, -300},
//  {-300, 800}, {1900, 800},
//  {-300, 1900}, {800, 1900}, {1900, 1900}};
float[][] spawnLocations = {{-1200, -1200}};
float[][] enemyTrack = {{-1200, -1200}, {1200, -1200}, {1200, 1200}, {-1200, 1200}, {-1200, -1200}, {1200, 1200}, {1200, -1200}, {-1200, 1200}, {1200, -1200}, {1200, 1200}};
float enemySpeed = 5;
float peaceTimeLength = 50;

ArrayList<Creature> creatures;
ArrayList<Enemy> enemies;
void setup() {
  size(1430, 900);
  frameRate(120);
  setCameraVariables();

  CreateCreatures();
  CreateEnemies();
}

void draw() {
  background(0);

  //RUN SIMULATION
  for (int i = 1; i <= SIMULATION_SPEED; i++) {
    if (simulationFrame < SIMULATION_FRAMES_PER_LIFETIME) {
      UpdateSimulation();
      simulationFrame++;
    }
  }

  //IF THE SIMULATION HAS ENDED
  if (nCreaturesAlive == 0 || simulationFrame >= SIMULATION_FRAMES_PER_LIFETIME) {
    //RUN TRAINING
    UpdateGeneration();
    ResetCreatures();
    CreateEnemies();

    simulationFrame = 0;
    currentGeneration++;
  }

  //DISPLAY EVERYTHING
  pushMatrix();
  translateCamera();

  /*CAMERA GRAPHICS*/
  if (!SHOW_CAMERA_LOCKED) {
    updateCamera();
    if (SHOW_CAMERA_BOUNDARY) {
      showCameraBoundary();
      if (!SHOW_CAMERA_LOCKED) {
        showCameraMaxZoomBorder();
      }
    }
  } else {
    showCameraLocked();
  }
  //

  /*actual simulation*/
  drawBoxBorder();
  for (Creature o : creatures) {
    if (o.alive == true) {
      o.Display();
    }
  }
  for (Enemy e : enemies) {
    e.Display();
  }
  popMatrix();
  //

  if (SHOW_CAMERA_INTRODUCTION && CAMERA_EVENT_TIMINGS[0] < millis() && millis() < CAMERA_EVENT_TIMINGS[CAMERA_EVENT_TIMINGS.length-1] ) {
    showCameraIntroduction();
    GUI_OPACITY -= 0.15;
    GUI_OPACITY = constrain(GUI_OPACITY, 0, 1);
  } else {
    if (CAMERA_EVENT_TIMINGS[CAMERA_EVENT_TIMINGS.length-1]< millis() ) {
      SHOW_CAMERA_INTRODUCTION = false;
    }
    GUI_OPACITY += 0.15;
    GUI_OPACITY = constrain(GUI_OPACITY, 0, 1);
  }

  displayGUI();

  //FPS
  textSize(35);
  fill(255, 255, 0, 255);
  text(str(round(frameRate)), 2, 28);
}


void drawBoxBorder() {
  stroke(255);
  strokeWeight(3);
  line(BOX_BORDER_X1, BOX_BORDER_Y1, BOX_BORDER_X2, BOX_BORDER_Y1);
  line(BOX_BORDER_X2, BOX_BORDER_Y1, BOX_BORDER_X2, BOX_BORDER_Y2);
  line(BOX_BORDER_X2, BOX_BORDER_Y2, BOX_BORDER_X1, BOX_BORDER_Y2);
  line(BOX_BORDER_X1, BOX_BORDER_Y2, BOX_BORDER_X1, BOX_BORDER_Y1);
}

void mousePressed() {
  mouseDown = true;
}
void mouseReleased() {
  mouseDown = false;
}

void keyPressed() {
  if (!SHOW_CAMERA_INTRODUCTION) {
    if (key == 'a') {
      SIMULATION_SPEED -= 1;
    }
    if (key == 'd') {
      SIMULATION_SPEED += 1;
    }
    if (key == 'A') {
      SIMULATION_SPEED -= 4;
    }
    if (key == 'D') {
      SIMULATION_SPEED += 4;
    }
    if (key == 'w') {
      SIMULATION_SPEED = SIMULATION_FRAMES_PER_LIFETIME;
    }
    if (key == 's') {
      SIMULATION_SPEED = 0;
    }
    SIMULATION_SPEED = constrain(SIMULATION_SPEED, 0, SIMULATION_FRAMES_PER_LIFETIME);
    if (key == 'q' || key == 'Q') {
      mutationIntensity -= 0.02;
    }
    if (key == 'e' || key == 'E') {
      mutationIntensity += 0.02;
    }
    mutationIntensity = constrain(mutationIntensity, 0, 1);
    if (key == 'r') { //restart everything
      ResetDemo();
    }

    /*CAMERA TOGGLEABLES*/
    if (key == '#') {
      SHOW_CAMERA_BOUNDARY = !SHOW_CAMERA_BOUNDARY;
    }
    if (keyCode == 222) {
      SHOW_CAMERA_LOCKED = !SHOW_CAMERA_LOCKED;
    }
    if (key == ';') {
      SHOW_CAMERA_STATS = !SHOW_CAMERA_STATS;
    }
  }
}

void CreateCreatures() {  //Spawn the Creatures
  creatures = new ArrayList<Creature>();
  for (int i = 0; i < N_CREATURES; i++) {
    float CreatureX = random(BOX_BORDER_X1, BOX_BORDER_X2);
    float CreatureY = random(BOX_BORDER_Y1, BOX_BORDER_Y2);
    Creature creature = new Creature(CreatureX, CreatureY);
    creatures.add(creature);
  }
  nCreaturesAlive = creatures.size();
}

void CreateEnemies() {
  enemies = new ArrayList<Enemy>();
  for (int i = 0; i < N_ENEMIES; i++) {
    float xSpawn = spawnLocations[i][0];
    float ySpawn = spawnLocations[i][1];
    enemies.add(new Enemy(xSpawn, ySpawn));
  }
}

void ResetCreatures() {
  for (Creature o : creatures) {
    float CreatureX = random(BOX_BORDER_X1, BOX_BORDER_X2);
    float CreatureY = random(BOX_BORDER_Y1, BOX_BORDER_Y2);
    o.CreatureX = CreatureX;
    o.CreatureY = CreatureY;
    o.alive = true;
  }
  //println(Creatures.size());
  nCreaturesAlive = creatures.size();
}

void ResetDemo() {
  background(255, 0, 0);
  simulationFrame = 0;
  SIMULATION_SPEED = 1;
  currentGeneration = 0 ;
  lastGenMeanFitness = 0;
  lastGenMedianFitness = 0;
  CreateCreatures();
  CreateEnemies();
}

void UpdateSimulation() {
  for (Enemy enemy : enemies) {
    enemy.Run();
    if(simulationFrame > peaceTimeLength){
      enemy.alive = true;
    }
  }
  for (Creature creature : creatures) {
    if (creature.alive == true) {
      creature.Run();
      creature.Brain.loss = 1  -  (float)simulationFrame / SIMULATION_FRAMES_PER_LIFETIME;
    }
  }
  //collision detection
  for (Enemy e : enemies) {
    for (Creature o : creatures) {
      if (o.alive == true && e.alive == true) {
        boolean isEnemyCollision = dist(e.enemyX, e.enemyY, o.CreatureX, o.CreatureY) < e.enemyRadius + o.CreatureRadius;
        // boolean isWallCollision = c.CreatureX <= BOX_BORDER_X1 || c.CreatureX >= BOX_BORDER_X2 || c.CreatureY <= BOX_BORDER_Y1 || c.CreatureY >= BOX_BORDER_Y2;
        if (isEnemyCollision) {
          o.alive = false;
          nCreaturesAlive--;
        }
      }
    }
  }
}

void UpdateGeneration() {
  //update mean fitness and median fitness
  float totalFitness = 0;
  float[] fitnesses = new float[creatures.size()];
  for (int i = 0; i < creatures.size(); i++) {
    Creature c = creatures.get(i);
    float creatureFitness = (1 - c.Brain.loss) * ((float)SIMULATION_FRAMES_PER_LIFETIME / 1000);
    totalFitness += creatureFitness;
    fitnesses[i] = creatureFitness;
  }

  fitnesses = sort(fitnesses);
  lastGenMedianFitness = fitnesses[(int)creatures.size()/2];
  lastGenMeanFitness = totalFitness / creatures.size();

  /* ONLY SELECT THOSE WHO DID WELL */
  ArrayList<Creature> nextGenCreatures = new ArrayList<Creature>();

  float cullingBoundary = 0.005;
  while (nextGenCreatures.size() < N_CREATURES * survivalProportion) {
    for (Creature creature : creatures) {
      if (creature.Brain.loss < cullingBoundary && creature.Brain.loss > cullingBoundary - 0.005) {
        nextGenCreatures.add(creature);
      }
    }
    cullingBoundary += 0.005;
  }

  //println("Creatures survived: " + str(Creatures.size() - nextGenCreatures.size()));

  while (nextGenCreatures.size() < N_CREATURES && nextGenCreatures.size() > 0) { //until we get a full generation,
    // we breed two random Creatures (the same Creature can also breed with itself? which is probably wrong)
    Creature parent1 = nextGenCreatures.get(round(random(-0.5, nextGenCreatures.size()-0.5)));
    Creature parent2 = nextGenCreatures.get(round(random(-0.5, nextGenCreatures.size()-0.5)));
    Creature offspring = BreedCreatures(parent1, parent2);
    //mutationIntensity = 0.17 - 0.16 * min(currentGeneration,30)/30;
    offspring.Brain.MutateAllWeightsBiases(mutationIntensity);
    nextGenCreatures.add(offspring);
  }
  creatures = nextGenCreatures;
}


Creature BreedCreatures(Creature parent1, Creature parent2) {
  Creature offspring = new Creature(0, 0);
  for (int ilayer = 0; ilayer < offspring.Brain.layers.length; ilayer++) {
    Layer offspringLayer = offspring.Brain.layers[ilayer];
    Layer parent1Layer = parent1.Brain.layers[ilayer];
    Layer parent2Layer = parent2.Brain.layers[ilayer];
    for (int inout = 0; inout < offspringLayer.nout; inout++) {
      for (int inin = 0; inin < offspringLayer.nin; inin++) {
        float averagedWeight = Average(parent1Layer.weights[inin][inout], parent2Layer.weights[inin][inout]);
        offspringLayer.weights[inin][inout] = averagedWeight;
      }
      float averagedBias = Average(parent1Layer.biases[inout], parent2Layer.biases[inout]);
      offspringLayer.biases[inout] = averagedBias;
    }
  }
  return offspring;
}

float Average(float value1, float value2) {
  return (value1 + value2)/2;
}
