///*MOUSE*/
//boolean mouseDown = false;

///*SIMULATION PARAMETERS*/
//float BOX_BORDER_X1 = -1200;
//float BOX_BORDER_X2 = 1200;
//float BOX_BORDER_Y1 = -1200;
//float BOX_BORDER_Y2 = 1200;

//int N_ORGANISMS = 400;
//int N_ENEMIES = 1;
//int SIMULATION_SPEED = 0;
//int SIMULATION_FRAMES_PER_LIFETIME = 4000;

//int nOrganismsAlive;
//int currentGeneration = 0;
//int simulationFrame = 0;

///*EVOLUTIONARY PARAMETERS*/
//int[] layerSizes = {6, 20, 8, 4};  //input layer, {hidden layers}, output layer
//float survivalProportion = 0.015;  //what proportion of the population carries on to reproduce
//float mutationIntensity = 0.24;
////float[][] spawnLocations = {{-300, -300}, {800, -300}, {1900, -300},
////  {-300, 800}, {1900, 800},
////  {-300, 1900}, {800, 1900}, {1900, 1900}};
//float[][] spawnLocations = {{-1800, -1800}};
//float[][] enemyTrack = {{-1200, -1200},{1200,600},{-1200,1200}};


///*GUI PARAMETERS*/
//float GUI_OPACITY = 0;

//ArrayList<Organism> organisms;
//ArrayList<Enemy> enemies;
//void setup() {
//  size(1200, 900);
//  frameRate(120);
//  setCameraVariables();

//  CreateOrganisms();
//  CreateEnemies();
//}

//void draw() {
//  background(0);

//  //RUN SIMULATION
//  for (int i = 0; i < SIMULATION_SPEED; i++) {
//    UpdateSimulation();
//    simulationFrame++;
//  }

//  //IF THE SIMULATION HAS ENDED
//  if (nOrganismsAlive == 0 || simulationFrame >= SIMULATION_FRAMES_PER_LIFETIME) {
//    //RUN TRAINING
//    UpdateGeneration();
//    ResetOrganisms();
//    CreateEnemies();

//    simulationFrame = 0;
//    currentGeneration++;
//  }

//  //DISPLAY EVERYTHING
//  pushMatrix();
//  translateCamera();

//  /*CAMERA GRAPHICS*/
//  if (!SHOW_CAMERA_LOCKED) {
//    updateCamera();
//    if (SHOW_CAMERA_BOUNDARY) {
//      showCameraBoundary();
//      if (!SHOW_CAMERA_LOCKED) {
//        showCameraMaxZoomBorder();
//      }
//    }
//  } else {
//    showCameraLocked();
//  }
//  //

//  /*actual simulation*/
//  drawBoxBorder();
//  for (Organism o : organisms) {
//    if (o.alive == true) {
//      o.Display();
//    }
//  }
//  for (Enemy e : enemies) {
//    e.Display();
//  }
//  popMatrix();
//  //

//  if (SHOW_CAMERA_INTRODUCTION && CAMERA_EVENT_TIMINGS[0] < millis() && millis() < CAMERA_EVENT_TIMINGS[CAMERA_EVENT_TIMINGS.length-1] ) {
//    showCameraIntroduction();
//    GUI_OPACITY -= 0.15;
//    GUI_OPACITY = constrain(GUI_OPACITY, 0, 1);
//  } else {
//    if (CAMERA_EVENT_TIMINGS[CAMERA_EVENT_TIMINGS.length-1]< millis() ) {
//      SHOW_CAMERA_INTRODUCTION = false;
//    }
//    GUI_OPACITY += 0.15;
//    GUI_OPACITY = constrain(GUI_OPACITY, 0, 1);
//  }

//  displayGUI();

//  //FPS
//  textSize(35);
//  fill(255, 255, 0, 255);
//  text(str(round(frameRate)), 2, 28);
//}


//void drawBoxBorder() {
//  stroke(255);
//  strokeWeight(3);
//  line(BOX_BORDER_X1, BOX_BORDER_Y1, BOX_BORDER_X2, BOX_BORDER_Y1);
//  line(BOX_BORDER_X2, BOX_BORDER_Y1, BOX_BORDER_X2, BOX_BORDER_Y2);
//  line(BOX_BORDER_X2, BOX_BORDER_Y2, BOX_BORDER_X1, BOX_BORDER_Y2);
//  line(BOX_BORDER_X1, BOX_BORDER_Y2, BOX_BORDER_X1, BOX_BORDER_Y1);
//}

//void mousePressed() {
//  mouseDown = true;
//}
//void mouseReleased() {
//  mouseDown = false;
//}

//void keyPressed() {
//  if (!SHOW_CAMERA_INTRODUCTION) {
//    if (key == 'a') {
//      SIMULATION_SPEED -= 1;
//    }
//    if (key == 'd') {
//      SIMULATION_SPEED += 1;
//    }
//    if (key == 'A') {
//      SIMULATION_SPEED -= 4;
//    }
//    if (key == 'D') {
//      SIMULATION_SPEED += 4;
//    }
//    if (key == 'w') {
//      SIMULATION_SPEED = SIMULATION_FRAMES_PER_LIFETIME;
//    }
//    if (key == 's') {
//      SIMULATION_SPEED = 0;
//    }
//    SIMULATION_SPEED = constrain(SIMULATION_SPEED, 0, SIMULATION_FRAMES_PER_LIFETIME);
//    if (key == 'q' || key == 'Q') {
//      mutationIntensity -= 0.02;
//    }
//    if (key == 'e' || key == 'E') {
//      mutationIntensity += 0.02;
//    }
//    mutationIntensity = constrain(mutationIntensity, 0, 0.4);
//    if (key == 'r') { //restart everything
//      ResetDemo();
//    }

//    /*CAMERA TOGGLEABLES*/
//    if (key == '#') {
//      SHOW_CAMERA_BOUNDARY = !SHOW_CAMERA_BOUNDARY;
//    }
//    if (keyCode == 222) {
//      SHOW_CAMERA_LOCKED = !SHOW_CAMERA_LOCKED;
//    }
//    if (key == ';') {
//      SHOW_CAMERA_STATS = !SHOW_CAMERA_STATS;
//    }
//  }
//}

//void CreateOrganisms() {  //Spawn the organisms
//  organisms = new ArrayList<Organism>();
//  for (int i = 0; i < N_ORGANISMS; i++) {
//    float organismX = random(BOX_BORDER_X1, BOX_BORDER_X2);
//    float organismY = random(BOX_BORDER_Y1, BOX_BORDER_Y2);
//    Organism Organism = new Organism(organismX, organismY);
//    organisms.add(Organism);
//  }
//  nOrganismsAlive = organisms.size();
//}

//void CreateEnemies() {
//  enemies = new ArrayList<Enemy>();
//  for (int i = 0; i < N_ENEMIES; i++) {
//    float xSpawn = spawnLocations[i][0];
//    float ySpawn = spawnLocations[i][1];
//    PVector vel = new PVector(random(0, 10), random(0, 10));
//    enemies.add(new Enemy(xSpawn, ySpawn, vel));
//  }
//}

//void ResetOrganisms() {
//  for (Organism o : organisms) {
//    float organismX = random(BOX_BORDER_X1, BOX_BORDER_X2);
//    float organismY = random(BOX_BORDER_Y1, BOX_BORDER_Y2);
//    o.organismX = organismX;
//    o.organismY = organismY;
//    o.alive = true;
//  }
//  //println(organisms.size());
//  nOrganismsAlive = organisms.size();
//}

//void ResetDemo() {
//  background(255, 0, 0);
//  simulationFrame = 0;
//  SIMULATION_SPEED = 1;
//  currentGeneration = 0 ;
//  CreateOrganisms();
//  CreateEnemies();
//}

//void UpdateSimulation() {
//  for (Enemy enemy : enemies) {
//    enemy.Run();
//  }
//  for (Organism Organism : organisms) {
//    if (Organism.alive == true) {
//      Organism.Run();
//      Organism.Brain.loss = 1  -  (float)simulationFrame / SIMULATION_FRAMES_PER_LIFETIME;
//    }
//  }
//  //collision detection
//  for (Enemy e : enemies) {
//    for (Organism o : organisms) {
//      if (o.alive == true) {
//        boolean isEnemyCollision = dist(e.enemyX, e.enemyY, o.organismX, o.organismY) < e.enemyRadius + o.organismRadius;
//        // boolean isWallCollision = c.organismX <= BOX_BORDER_X1 || c.organismX >= BOX_BORDER_X2 || c.organismY <= BOX_BORDER_Y1 || c.organismY >= BOX_BORDER_Y2;
//        if (isEnemyCollision) {
//          o.alive = false;
//          nOrganismsAlive--;
//        }
//      }
//    }
//  }
//}

//void UpdateGeneration() {
//  /* ONLY SELECT THOSE WHO DID WELL */
//  ArrayList<Organism> nextGenOrganisms = new ArrayList<Organism>();

//  float cullingBoundary = 0.005;
//  while (nextGenOrganisms.size() < N_ORGANISMS * survivalProportion) {
//    for (Organism organism : organisms) {
//      if (organism.Brain.loss < cullingBoundary && organism.Brain.loss > cullingBoundary - 0.005) {
//        nextGenOrganisms.add(organism);
//      }
//    }
//    cullingBoundary += 0.005;
//  }

//  //for (Organism organism : organisms) {
//  //  if (organism.alive == true) {
//  //    nextGenOrganisms.add(organism);
//  //  }
//  //}

//  //println("organisms survived: " + str(organisms.size() - nextGenOrganisms.size()));

//  while (nextGenOrganisms.size() < N_ORGANISMS && nextGenOrganisms.size() > 0) { //until we get a full generation,
//    // we breed two random organisms (the same Organism can also breed with itself? which is probably wrong)
//    Organism parent1 = nextGenOrganisms.get(round(random(-0.5, nextGenOrganisms.size()-0.5)));
//    Organism parent2 = nextGenOrganisms.get(round(random(-0.5, nextGenOrganisms.size()-0.5)));
//    Organism offspring = BreedOrganisms(parent1, parent2);
//    //mutationIntensity = 0.17 - 0.16 * min(currentGeneration,30)/30;
//    offspring.Brain.MutateAllWeightsBiases(mutationIntensity);
//    nextGenOrganisms.add(offspring);
//  }
//  organisms = nextGenOrganisms;
  
//  println(nextGenOrganisms.size());
//  println(organisms.size());
//}


//Organism BreedOrganisms(Organism parent1, Organism parent2) {
//  Organism offspring = new Organism(0, 0);
//  for (int ilayer = 0; ilayer < offspring.Brain.layers.length; ilayer++) {
//    Layer offspringLayer = offspring.Brain.layers[ilayer];
//    Layer parent1Layer = parent1.Brain.layers[ilayer];
//    Layer parent2Layer = parent2.Brain.layers[ilayer];
//    for (int inout = 0; inout < offspringLayer.nout; inout++) {
//      for (int inin = 0; inin < offspringLayer.nin; inin++) {
//        float averagedWeight = Average(parent1Layer.weights[inin][inout], parent2Layer.weights[inin][inout]);
//        offspringLayer.weights[inin][inout] = averagedWeight;
//      }
//      float averagedBias = Average(parent1Layer.biases[inout], parent2Layer.biases[inout]);
//      offspringLayer.biases[inout] = averagedBias;
//    }
//  }
//  return offspring;
//}

//float Average(float value1, float value2) {
//  return (value1 + value2)/2;
//}

///*CAMERA PARAMETERS*/
////BOUNDARY
//float CAMERA_BORDER_X1 = -5000;
//float CAMERA_BORDER_Y1 = -5000;
//float CAMERA_BORDER_X2 = 5000;
//float CAMERA_BORDER_Y2 = 5000;

////POSITION
//float CAMERA_X = 0;
//float CAMERA_Y = 0;
//float DESIRED_CAMERA_X = 0;
//float DESIRED_CAMERA_Y = 0;
//float CAMERA_MOVEMENT_SENSITIVITY = 3;
//float CAMERA_MOVEMENT_SPEED = 0.2;

////ZOOM
//float CAMERA_ZOOM = 0.3;
//float DESIRED_CAMERA_ZOOM = 0.295;  //make this different from CAMERA_ZOOM to create an initial zoom effect
//float MIN_CAMERA_ZOOM = 0.05;
//float MAX_CAMERA_ZOOM = 1;

//float CAMERA_ZOOM_SENSITIVITY = 0.10;
//float CAMERA_ZOOM_SPEED = 0.19;

////TOGGLEABLE
//boolean SHOW_CAMERA_BOUNDARY = false;
//boolean SHOW_CAMERA_LOCKED = false;
//boolean SHOW_CAMERA_STATS = true;


///*INTRODUCTION (times are in milliseconds)*/
//boolean SHOW_CAMERA_INTRODUCTION = true;
//float[] CAMERA_EVENT_TIMINGS = {500, 900, 1300, 2550, 5500, 6500, 6800};

//float CAMERA_INTRODUCTION_OPACITY = 0;
//int CAMERA_CURRENT_EVENT = 0;

//float TEXT_1_X = 300;
//float TEXT_1_Y = 300;
//float TEXT_1_DESIRED_X;
//float TEXT_1_DESIRED_Y;
//float TEXT_1_OPACITY = 0;

//float TEXT_2_X = 300;
//float TEXT_2_Y = 300;
//float TEXT_2_DESIRED_X;
//float TEXT_2_DESIRED_Y;
//float TEXT_2_OPACITY = 0;

//float TEXT_3_X = 200;
//float TEXT_3_Y = 400;
//float TEXT_3_DESIRED_X;
//float TEXT_3_DESIRED_Y;
//float TEXT_3_OPACITY = 0;

//float TEXT_4_X = 200;
//float TEXT_4_Y = 500;
//float TEXT_4_DESIRED_X;
//float TEXT_4_DESIRED_Y;
//float TEXT_4_OPACITY = 0;

//float BUTTON_SKIP;
//float BUTTON_X;
//float BUTTON_Y;
//float BUTTON_DESIRED_X;
//float BUTTON_DESIRED_Y;
//float BUTTON_OPACITY = 0;

//void setCameraVariables(){
//  BUTTON_X = width/2;
//  BUTTON_Y = -100;
//}

//void mouseWheel(MouseEvent event) {
//  if (!SHOW_CAMERA_LOCKED && !SHOW_CAMERA_INTRODUCTION) {
//    float mouse = event.getCount();
//    if (mouse == 1) { //-1 scrolling out  1 scolling in
//      DESIRED_CAMERA_ZOOM -= CAMERA_ZOOM * CAMERA_ZOOM_SENSITIVITY;   //scroll out by decreasing zoom
//    } else {
//      DESIRED_CAMERA_ZOOM += CAMERA_ZOOM * CAMERA_ZOOM_SENSITIVITY;   //scroll in by increasing zoom
//    }
//    if (!isWithin(DESIRED_CAMERA_ZOOM, MIN_CAMERA_ZOOM, MAX_CAMERA_ZOOM)) {
//      float deltaZoom = (DESIRED_CAMERA_ZOOM < MIN_CAMERA_ZOOM) ? DESIRED_CAMERA_ZOOM - MIN_CAMERA_ZOOM : DESIRED_CAMERA_ZOOM - MAX_CAMERA_ZOOM;
//      updatePosition(deltaZoom * CAMERA_ZOOM_SPEED * CAMERA_MOVEMENT_SENSITIVITY);
//    }
//  }
//  DESIRED_CAMERA_ZOOM = constrain(DESIRED_CAMERA_ZOOM, MIN_CAMERA_ZOOM, MAX_CAMERA_ZOOM);
//}

//void updateCamera() {
//  if (!SHOW_CAMERA_LOCKED) {
//    float deltaZoom = DESIRED_CAMERA_ZOOM - CAMERA_ZOOM;
//    updateZoom(deltaZoom * CAMERA_ZOOM_SPEED);
//    updatePosition(deltaZoom * CAMERA_ZOOM_SPEED);
//  } else {
//    DESIRED_CAMERA_X = CAMERA_X;
//    DESIRED_CAMERA_Y = CAMERA_Y;
//    DESIRED_CAMERA_ZOOM = CAMERA_ZOOM;
//  }
//}

//void updateZoom(float deltaZoom) {
//  CAMERA_ZOOM += deltaZoom;
//  CAMERA_ZOOM = constrain(CAMERA_ZOOM, MIN_CAMERA_ZOOM, MAX_CAMERA_ZOOM);
//}

//void updatePosition(float deltaZoom) {
//  float realMouseX = (width/2 - mouseX) / CAMERA_ZOOM;
//  float realMouseY = (height/2 - mouseY) / CAMERA_ZOOM;
//  DESIRED_CAMERA_X -= (realMouseX * deltaZoom) / CAMERA_ZOOM;
//  DESIRED_CAMERA_Y -= (realMouseY * deltaZoom) / CAMERA_ZOOM;
//  DESIRED_CAMERA_X = constrain(DESIRED_CAMERA_X, CAMERA_BORDER_X1, CAMERA_BORDER_X2);
//  DESIRED_CAMERA_Y = constrain(DESIRED_CAMERA_Y, CAMERA_BORDER_Y1, CAMERA_BORDER_Y2);
//  float deltaX = DESIRED_CAMERA_X - CAMERA_X;
//  float deltaY = DESIRED_CAMERA_Y - CAMERA_Y;
//  CAMERA_X += deltaX * CAMERA_MOVEMENT_SPEED;
//  CAMERA_Y += deltaY * CAMERA_MOVEMENT_SPEED;
//}

//void translateCamera() {
//  translate(width/2, height/2);
//  scale(CAMERA_ZOOM);
//  translate(-CAMERA_X, -CAMERA_Y);
//}


//void showCameraBoundary() {
//  //camera boundary
//  stroke(140, 140, 140, 120);
//  strokeWeight(40);
//  line(CAMERA_BORDER_X1, CAMERA_BORDER_Y1, CAMERA_BORDER_X2, CAMERA_BORDER_Y1);
//  line(CAMERA_BORDER_X2, CAMERA_BORDER_Y1, CAMERA_BORDER_X2, CAMERA_BORDER_Y2);
//  line(CAMERA_BORDER_X2, CAMERA_BORDER_Y2, CAMERA_BORDER_X1, CAMERA_BORDER_Y2);
//  line(CAMERA_BORDER_X1, CAMERA_BORDER_Y2, CAMERA_BORDER_X1, CAMERA_BORDER_Y1);

//  //crosshairs
//  stroke(140, 140, 140, 165);
//  strokeWeight(max(20 - ((CAMERA_ZOOM/MAX_CAMERA_ZOOM) * 55), 0.5));
//  line(CAMERA_X, CAMERA_BORDER_Y1, CAMERA_X, CAMERA_BORDER_Y2);
//  line(CAMERA_BORDER_X1, CAMERA_Y, CAMERA_BORDER_X2, CAMERA_Y);
//  stroke(140, 140, 140, 165);
//  strokeWeight(max(20 - ((CAMERA_ZOOM/MAX_CAMERA_ZOOM) * 55), 0.5));
//  line(CAMERA_X, CAMERA_Y, CAMERA_BORDER_X1, CAMERA_BORDER_Y1);
//  line(CAMERA_X, CAMERA_Y, CAMERA_BORDER_X2, CAMERA_BORDER_Y1);
//  line(CAMERA_X, CAMERA_Y, CAMERA_BORDER_X2, CAMERA_BORDER_Y2);
//  line(CAMERA_X, CAMERA_Y, CAMERA_BORDER_X1, CAMERA_BORDER_Y2);
//  //crosshair boundary
//  stroke(140, 140, 140, 90);
//  strokeWeight(30);
//  point(CAMERA_X, CAMERA_BORDER_Y1);
//  point(CAMERA_X, CAMERA_BORDER_Y2);
//  point(CAMERA_BORDER_X1, CAMERA_Y);
//  point(CAMERA_BORDER_X2, CAMERA_Y);
//}

//void showCameraMaxZoomBorder() {
//  //max zoom camera borders
//  stroke(140, 140, 140, min((((CAMERA_ZOOM/MAX_CAMERA_ZOOM) * 800) - 255), 150));
//  strokeWeight(2/CAMERA_ZOOM);
//  line(CAMERA_X - (width / MAX_CAMERA_ZOOM/2), CAMERA_Y - (height/ MAX_CAMERA_ZOOM/2),
//    CAMERA_X + (width / MAX_CAMERA_ZOOM/2), CAMERA_Y - (height/ MAX_CAMERA_ZOOM/2));
//  line(CAMERA_X + (width / MAX_CAMERA_ZOOM/2), CAMERA_Y - (height/ MAX_CAMERA_ZOOM/2),
//    CAMERA_X + (width / MAX_CAMERA_ZOOM/2), CAMERA_Y + (height/ MAX_CAMERA_ZOOM/2));
//  line(CAMERA_X + (width / MAX_CAMERA_ZOOM/2), CAMERA_Y + (height/ MAX_CAMERA_ZOOM/2),
//    CAMERA_X - (width / MAX_CAMERA_ZOOM/2), CAMERA_Y + (height/ MAX_CAMERA_ZOOM/2));
//  line(CAMERA_X - (width / MAX_CAMERA_ZOOM/2), CAMERA_Y + (height/ MAX_CAMERA_ZOOM/2),
//    CAMERA_X - (width / MAX_CAMERA_ZOOM/2), CAMERA_Y - (height/ MAX_CAMERA_ZOOM/2));
//}

//void showCameraLocked() {
//  stroke(255, 0, 0, 120);
//  strokeWeight(24/CAMERA_ZOOM);
//  line(CAMERA_X - (width / CAMERA_ZOOM/2), CAMERA_Y - (height/ CAMERA_ZOOM/2),
//    CAMERA_X + (width / CAMERA_ZOOM/2), CAMERA_Y - (height/ CAMERA_ZOOM/2));
//  line(CAMERA_X + (width / CAMERA_ZOOM/2), CAMERA_Y - (height/ CAMERA_ZOOM/2),
//    CAMERA_X + (width / CAMERA_ZOOM/2), CAMERA_Y + (height/ CAMERA_ZOOM/2));
//  line(CAMERA_X + (width / CAMERA_ZOOM/2), CAMERA_Y + (height/ CAMERA_ZOOM/2),
//    CAMERA_X - (width / CAMERA_ZOOM/2), CAMERA_Y + (height/ CAMERA_ZOOM/2));
//  line(CAMERA_X - (width / CAMERA_ZOOM/2), CAMERA_Y + (height/ CAMERA_ZOOM/2),
//    CAMERA_X - (width / CAMERA_ZOOM/2), CAMERA_Y - (height/ CAMERA_ZOOM/2));
//}

//void showCameraStats() {
//  textSize(15);
//  fill(255, 255, 255, 220 * GUI_OPACITY);
//  text("X: " + str(round(DESIRED_CAMERA_X)), width - 61, 20);
//  text("Y: " + str(round(DESIRED_CAMERA_Y)), width - 60.5, 35);
//  text("Zoom: " + str((float)round(DESIRED_CAMERA_ZOOM * 100)/100), width - 90, 50);
//}

//void showCameraIntroduction() {
//  //CHECK WHICH EVENT IS BEING PLAYED AT THE MOMENT
//  for (int IEVENT = 0; IEVENT < CAMERA_EVENT_TIMINGS.length; IEVENT++) {
//    if (CAMERA_EVENT_TIMINGS[IEVENT] < millis()) {
//      CAMERA_CURRENT_EVENT = IEVENT;
//    }
//  }

//  //CHECK IF THE INTRODUCTION HAS BEEN SKIPPED
//  if (mouseDown && mouseX > BUTTON_X - 145 && mouseX < BUTTON_X + 145 && mouseY > BUTTON_Y - 22.5 && mouseY < BUTTON_Y + 22.5) {  //290 width // 45 height
//    CAMERA_EVENT_TIMINGS[4] = 0;
//    CAMERA_EVENT_TIMINGS[5] = 0;
//    CAMERA_EVENT_TIMINGS[CAMERA_EVENT_TIMINGS.length-1] = millis() + 700;
//  }

//  //DIM THE SCREEN
//  rectMode(CORNER);
//  fill(0, 0, 0, 190 * CAMERA_INTRODUCTION_OPACITY);
//  rect(0, 0, width, height);
  
//  switch(CAMERA_CURRENT_EVENT) {
//    case(5):
//    CAMERA_INTRODUCTION_OPACITY -= 0.16;
//    case(4):
//    TEXT_1_OPACITY -= 0.15;
//    TEXT_2_OPACITY -= 0.15;
//    TEXT_3_OPACITY -= 0.17;
//    TEXT_4_OPACITY -= 0.17;
//    BUTTON_OPACITY -= 0.10;
//    case(3):
//    TEXT_4_OPACITY += 0.15;
//    TEXT_4_OPACITY = constrain(TEXT_4_OPACITY, 0, 1);
//    TEXT_4_DESIRED_X = 200;
//    TEXT_4_DESIRED_Y = 400;
//    TEXT_4_DESIRED_X += (width/2- mouseX) / 41;
//    TEXT_4_DESIRED_Y += (height/2 - mouseY) / 41;
//    TEXT_4_X += (TEXT_4_DESIRED_X - TEXT_4_X) / 11;
//    TEXT_4_Y += (TEXT_4_DESIRED_Y - TEXT_4_Y) / 11;
//    case(2):
//    BUTTON_OPACITY += 0.02;
//    BUTTON_OPACITY = constrain(BUTTON_OPACITY, 0, 1);
//    BUTTON_DESIRED_X = width/2;
//    BUTTON_DESIRED_Y = 40;
//    BUTTON_X += (BUTTON_DESIRED_X - BUTTON_X) / 14;
//    BUTTON_Y += (BUTTON_DESIRED_Y - BUTTON_Y) / 14;

//    TEXT_3_OPACITY += 0.15;
//    TEXT_3_OPACITY = constrain(TEXT_3_OPACITY, 0, 1);
//    TEXT_3_DESIRED_X = 200;
//    TEXT_3_DESIRED_Y = 320;
//    TEXT_3_DESIRED_X += (width/2- mouseX) / 41;
//    TEXT_3_DESIRED_Y += (height/2 - mouseY) / 41;
//    TEXT_3_X += (TEXT_3_DESIRED_X - TEXT_3_X) / 11;
//    TEXT_3_Y += (TEXT_3_DESIRED_Y - TEXT_3_Y) / 11;
//    case(1):
//    TEXT_2_OPACITY += 0.12;
//    TEXT_2_OPACITY = constrain(TEXT_2_OPACITY, 0, 1);
//    TEXT_2_DESIRED_X = width/2 - 280;
//    TEXT_2_DESIRED_Y = height/2 - 175;
//    TEXT_2_DESIRED_X += (width/2- mouseX) / 41;
//    TEXT_2_DESIRED_Y += (height/2 - mouseY) / 41;
//    TEXT_2_X += (TEXT_2_DESIRED_X - TEXT_2_X) / 11;
//    TEXT_2_Y += (TEXT_2_DESIRED_Y - TEXT_2_Y) / 11;
//    case(0):
//    CAMERA_INTRODUCTION_OPACITY += 0.13;
//    CAMERA_INTRODUCTION_OPACITY = constrain(CAMERA_INTRODUCTION_OPACITY, 0, 1);
//    TEXT_1_OPACITY += 0.12;
//    TEXT_1_OPACITY = constrain(TEXT_1_OPACITY, 0, 1);
//    TEXT_1_DESIRED_X = width/2 - 334;
//    TEXT_1_DESIRED_Y = height/2 - 200;
//    TEXT_1_DESIRED_X += (width/2- mouseX) / 30;
//    TEXT_1_DESIRED_Y += (height/2 - mouseY) / 30;
//    TEXT_1_X += (TEXT_1_DESIRED_X - TEXT_1_X) / 10;
//    TEXT_1_Y += (TEXT_1_DESIRED_Y - TEXT_1_Y) / 10;
//    break;
//  }

//  textSize(80);
//  fill(255, 255, 255, 255 * TEXT_1_OPACITY);
//  text("Evolution Simulator", TEXT_1_X, TEXT_1_Y);
//  textSize(25);
//  fill(255, 255, 255, 255 * TEXT_2_OPACITY);
//  text("by Kelvin Zhang", TEXT_2_X, TEXT_2_Y);

//  fill(255, 255, 255, 255 * TEXT_3_OPACITY);
//  textSize(18);
//  text("insert text here", TEXT_3_X, TEXT_3_Y);
//  text("", TEXT_3_X, TEXT_3_Y + 20);
//  text("", TEXT_3_X, TEXT_3_Y + 40);
//  text("", TEXT_3_X, TEXT_3_Y + 60);


//  fill(255, 255, 255, 255 * TEXT_4_OPACITY);
//  text("Controls", TEXT_3_X - 15, TEXT_4_Y);
//  strokeWeight(1.2);
//  stroke(255, 255, 255, 255 * TEXT_4_OPACITY);
//  line(TEXT_4_X - 15, TEXT_4_Y + 4, TEXT_4_X + 80, TEXT_4_Y + 4);
//  textSize(24);
//  text("A and D", TEXT_4_X, TEXT_4_Y + 30);
//  textSize(18);
//  text("→ Change simulation speed", TEXT_4_X + 80, TEXT_4_Y + 30);
//  textSize(15);
//  text("with SHIFT, x4", TEXT_4_X + 110, TEXT_4_Y + 46);
//  textSize(24);
//  text("W and S", TEXT_4_X, TEXT_4_Y + 70);
//  textSize(18);
//  text("→ Set max/min simulation speed", TEXT_4_X + 80, TEXT_4_Y + 70);
//  textSize(24);
//  text("Q and E", TEXT_4_X, TEXT_4_Y + 110);
//  textSize(18);
//  text("→ Change mutation intensity", TEXT_4_X + 80, TEXT_4_Y + 110);
  

//  rectMode(CENTER);
//  fill(120,120,120,120 * BUTTON_OPACITY);
//  noStroke();
//  rect(BUTTON_X, BUTTON_Y, 290, 45, 14);
//  textSize(25);
//  textAlign(CENTER);
//  fill(255,255,255,150 * BUTTON_OPACITY);
//  text("Skip", BUTTON_X, BUTTON_Y + 8);
//  textAlign(LEFT);
//}

//void displayGUI() {
//  noStroke();
  
//  /*CAMERA TOGGLEABLES*/
//  pushMatrix();
//  translate((CAMERA_X - DESIRED_CAMERA_X) * 0.003, (CAMERA_Y - DESIRED_CAMERA_Y)* 0.001);
//  if (SHOW_CAMERA_STATS) {
//    showCameraStats();
//  }
//  popMatrix();
//  //

//  pushMatrix();
//  translate((CAMERA_X - DESIRED_CAMERA_X) * 0.003, (CAMERA_Y - DESIRED_CAMERA_Y)* 0.001);

//  fill(255, 255, 255, 255* GUI_OPACITY);
//  textSize(30);
//  text("Generation: " + str(currentGeneration), width/2 - 70, 42);
//  textSize(25);
//  text("Evolution Parameters", 5, 70);
//  textSize(20);
//  popMatrix();

//  pushMatrix();
//  translate((CAMERA_X - DESIRED_CAMERA_X) * 0.008, (CAMERA_Y - DESIRED_CAMERA_Y)* 0.002);

//  //TIME ELAPSED
//  rectMode(CORNER);
//  float frameDiff = SIMULATION_FRAMES_PER_LIFETIME / 10;
//  for (float frame = frameDiff; frame < SIMULATION_FRAMES_PER_LIFETIME - simulationFrame; frame += frameDiff) {
//    fill(255 * ( 1 - (float)frame / SIMULATION_FRAMES_PER_LIFETIME), 255 * (float)frame / SIMULATION_FRAMES_PER_LIFETIME, 0, 130* GUI_OPACITY);
//    square(width/2 - 201 + (frame/(frameDiff/20)), 47, 20);
//  }
//  fill(255, 255 * (1- (float)simulationFrame/SIMULATION_FRAMES_PER_LIFETIME), 255 * (1-  (float)simulationFrame/SIMULATION_FRAMES_PER_LIFETIME), 230* GUI_OPACITY);
//  text("time elapsed: " + str((float)simulationFrame/1000), width/2 - 165, 64);
//  //CREATURES LEFT
//  for (int x = 0; x < nOrganismsAlive; x+= 45) {
//    fill(255 * ( 1 - (float)x / N_ORGANISMS), 255 * (float)x / N_ORGANISMS, 0, 130* GUI_OPACITY);
//    square(width/2 + (x/2.25) + 30, 47, 20);
//  }
//  fill(255, 255, 255, 230* GUI_OPACITY);
//  text("creatures left: " + str(nOrganismsAlive), width/2 + 45, 63);

//  fill(255, 255, 255, 200* GUI_OPACITY);
//  text("Mutation Intensity: " + str(mutationIntensity), 14, 90);
//  textSize(17);
//  popMatrix();
//  text("simulation speed: " +  str(SIMULATION_SPEED) + "x", width/2 - 60, 82);
//}



//PVector getTranslatedXY() {
//  float translatedMouseX = (mouseX - width/2) / CAMERA_ZOOM + CAMERA_X;
//  float translatedMouseY = (mouseY - height/2) / CAMERA_ZOOM + CAMERA_Y;
//  return new PVector(translatedMouseX, translatedMouseY);
//}

//boolean isWithin(float n, float lowerBound, float upperBound) {
//  return n >= min(lowerBound, upperBound) && n <= max(lowerBound, upperBound)  ? true : false;
//}

//class Enemy {
//  float enemyX, enemyY;
//  PVector vel;
//  float enemyRadius = 800;
//  int currentTrack = 0;

//  Enemy(float enemyX, float enemyY, PVector vel) {
//    this.enemyX = enemyX;
//    this.enemyY = enemyY;
//    //  this.vel = vel;
//  }

//  void Run() {
//    // float x = (mouseX - width/2 ) / CAMERA_ZOOM + CAMERA_X, y = (mouseY - height/2 ) / CAMERA_ZOOM  + CAMERA_Y;
//    float x = enemyTrack[currentTrack][0];
//    float y = enemyTrack[currentTrack][1];
//    if (isWithinError(enemyX,enemyTrack[currentTrack][0],5) && isWithinError(enemyY,enemyTrack[currentTrack][1],5)) {
//      currentTrack++;
//      currentTrack = constrain(currentTrack,0,enemyTrack.length-1);
//    }
//    PVector dm = new PVector(x - enemyX, y -enemyY );
//    vel = PVector.fromAngle(dm.heading());
//    vel.setMag(3);    //this is for following the mouse
//    enemyX += vel.x;
//    enemyY += vel.y;
//    //if (enemyX < BOX_BORDER_X1 ||enemyX > BOX_BORDER_X2) {
//    //  vel.x = -vel.x;
//    //}
//    //if (enemyY < BOX_BORDER_Y1 ||enemyY > BOX_BORDER_Y2) {
//    //  vel.y = -vel.y;
//    //}
//  }

//  void Display() {
//    noStroke();
//    fill(255, 0, 0, 200);
//    circle(enemyX, enemyY, enemyRadius * 2);
//  }

//  boolean isWithinError(float value, float target, float error) {
//    return (value > target - error && value < target + error) ? true:false;
//  }
//}

//class Layer {
//  int nin, nout;
//  float[][] weights;
//  float[] biases;
//  float[] inputs;   //raw inputs from the last layer's nodes
//  float[] activations; //the output of each node after being sent through the activation function


//  public Layer(int nin, int nout) {
//    this.nin = nin;
//    this.nout = nout;
//    this.weights = new float[nin][nout];
//    this.biases = new float[nout];
//    this.activations = new float[nout];
//    this.inputs = new float[nin];
//    this.GenerateWeightsBiases();
//  }

//  //This code ensures that when we create the networks, their brains are all random
//  void GenerateWeightsBiases() {
//    for (int inout = 0; inout < nout; inout++) {
//      this.biases[inout] = random(-1, 1);
//      for (int inin = 0; inin < nin; inin++) {
//        this.weights[inin][inout] = random(-1, 1);
//      }
//    }
//  }

//  //This code
//  public float[] calculateOutputs(float[] inputs) {
//    for (int inout = 0; inout < nout; inout++) {
//      float weightedInput = biases[inout];
//      for (int inin = 0; inin < nin; inin++) {
//        this.inputs[inin] = inputs[inin];
//        weightedInput += inputs[inin] * weights[inin][inout];
//      }
//      activations[inout] = ActivationFunction(weightedInput);
//    }
//    return activations;
//  }

//  float ActivationFunction(float weightedInput) {
//    return (float)Math.tanh(weightedInput);
//  }


//  void MutateWeightsBiases(float mutationRate) {
//    for (int inout = 0; inout < nout; inout++) {
//      for (int inin = 0; inin < nin; inin++) {
//        weights[inin][inout] += random(-mutationRate, mutationRate);
//      }
//      biases[inout] += random(-mutationRate, mutationRate);
//    }
//  }
//}
//class Network {
//  Layer[] layers;
//  int[] layerSizes;

//  float loss;

//  public Network(int[] layerSizes) {
//    this.layers = new Layer[layerSizes.length-1];
//    for (int i = 0; i < this.layers.length; i++) {
//      this.layers[i] = new Layer(layerSizes[i], layerSizes[i+1]);
//    }
//    this.layerSizes = layerSizes;
//    this.loss = 1000;
//  }

//  float[] CalculateOutputs(float[] inputsNormalised) {
//    for (Layer layer : layers) {
//      inputsNormalised = layer.calculateOutputs(inputsNormalised);
//    }
//    return inputsNormalised;
//  }

//  float[] Predict(float[] inputsNormalised) {
//    return CalculateOutputs(inputsNormalised);
//  }

//  void MutateAllWeightsBiases(float mutationRate) {
//    for (Layer l : layers) {
//      l.MutateWeightsBiases(mutationRate);
//    }
//  }
//}
//class Organism {
//  Network Brain;

//  float organismX, organismY;
//  float organismRadius = 14;
//  boolean alive;

//  ////EVOLUTIONARY
//  float sensorLength = 40;

//  public Organism(float organismX, float organismY) {
//    Brain = new Network(layerSizes);
//    this.organismX = organismX;
//    this.organismY = organismY;
//    this.alive = true;
//  }

//  void Run() {
//    Enemy e = enemies.get(0);
//    float normalisedTimeElapsed = simulationFrame / SIMULATION_FRAMES_PER_LIFETIME;
//    float normalisedorganismX = (organismX - (BOX_BORDER_X1/2))/((BOX_BORDER_X2 - BOX_BORDER_X1)/2);
//    float normalisedorganismY = (organismY - (BOX_BORDER_Y1/2))/((BOX_BORDER_Y2 - BOX_BORDER_Y1)/2);
//    float normalisedEnemyX = (e.enemyX - BOX_BORDER_X1)/(BOX_BORDER_X2 - BOX_BORDER_X1);
//    float normalisedEnemyY = (e.enemyY - BOX_BORDER_Y1)/(BOX_BORDER_Y2 - BOX_BORDER_Y1);
//    float normalisedEnemyVelX = e.vel.x/3;
//    float normalisedEnemyVelY = e.vel.y/3;
//    float[] inputsNormalised = {normalisedorganismX, normalisedorganismY, normalisedEnemyX, normalisedEnemyY, normalisedEnemyVelX, normalisedEnemyVelY};

//    float[] proportionConfidences = Brain.Predict(inputsNormalised);
//    for (int direction = 0; direction < 4; direction++) {
//      float confidence = proportionConfidences[direction] * 100;
//      if (random(100) <= confidence) {
//        for (int i = 0; i < 15; i++) {
//          Move(direction);
//        }
//      }
//    }

//    checkBoundary();
//  }
//  void Move(int direction) {
//    switch(direction) {
//    case 0:
//      moveRight();
//      break;
//    case 1:
//      moveDown();
//      break;
//    case 2:
//      moveLeft();
//      break;
//    case 3:
//      moveUp();
//      break;
//    }
//  }

//  void moveLeft() {
//    organismX--;
//  }
//  void moveRight() {
//    organismX++;
//  }
//  void moveUp() {
//    organismY--;
//  }
//  void moveDown() {
//    organismY++;
//  }

//  void checkBoundary() {
//    organismX = constrain(organismX, BOX_BORDER_X1, BOX_BORDER_X2);
//    organismY = constrain(organismY, BOX_BORDER_Y1, BOX_BORDER_Y2);
//  }

//  void Display() {
//    noStroke();
//    fill(255);
//    circle(organismX, organismY, organismRadius * 2);
//  }
//}
