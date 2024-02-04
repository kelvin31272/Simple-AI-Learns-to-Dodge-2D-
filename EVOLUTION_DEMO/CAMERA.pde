/*CAMERA PARAMETERS*/
//BOUNDARY
float CAMERA_BORDER_X1 = -5000;
float CAMERA_BORDER_Y1 = -5000;
float CAMERA_BORDER_X2 = 5000;
float CAMERA_BORDER_Y2 = 5000;

//POSITION
float CAMERA_X = 0;
float CAMERA_Y = 0;
float DESIRED_CAMERA_X = 0;
float DESIRED_CAMERA_Y = 0;
float CAMERA_MOVEMENT_SENSITIVITY = 3;
float CAMERA_MOVEMENT_SPEED = 0.2;

//ZOOM
float CAMERA_ZOOM = 0.3;
float DESIRED_CAMERA_ZOOM = 0.295;  //make this different from CAMERA_ZOOM to create an initial zoom effect
float MIN_CAMERA_ZOOM = 0.05;
float MAX_CAMERA_ZOOM = 1;

float CAMERA_ZOOM_SENSITIVITY = 0.10;
float CAMERA_ZOOM_SPEED = 0.19;

//TOGGLEABLE
boolean SHOW_CAMERA_BOUNDARY = false;
boolean SHOW_CAMERA_LOCKED = false;
boolean SHOW_CAMERA_STATS = true;

/*GUI PARAMETERS*/
float GUI_OPACITY = 0;

/*INTRODUCTION (times are in milliseconds)*/
boolean SHOW_CAMERA_INTRODUCTION = true;
float[] CAMERA_EVENT_TIMINGS = {500, 900, 1200, 2550, 5500, 6500, 6800};

float CAMERA_INTRODUCTION_OPACITY = 0;
int CAMERA_CURRENT_EVENT = 0;

float TEXT_1_X = 300;
float TEXT_1_Y = 300;
float TEXT_1_DESIRED_X;
float TEXT_1_DESIRED_Y;
float TEXT_1_OPACITY = 0;

float TEXT_2_X = 300;
float TEXT_2_Y = 300;
float TEXT_2_DESIRED_X;
float TEXT_2_DESIRED_Y;
float TEXT_2_OPACITY = 0;

float TEXT_3_X = 200;
float TEXT_3_Y = 400;
float TEXT_3_DESIRED_X;
float TEXT_3_DESIRED_Y;
float TEXT_3_OPACITY = 0;

float TEXT_4_X = 200;
float TEXT_4_Y = 500;
float TEXT_4_DESIRED_X;
float TEXT_4_DESIRED_Y;
float TEXT_4_OPACITY = 0;

float BUTTON_SKIP;
float BUTTON_X;
float BUTTON_Y;
float BUTTON_DESIRED_X;
float BUTTON_DESIRED_Y;
float BUTTON_OPACITY = 0;

void setCameraVariables() {
  BUTTON_X = width/2;
  BUTTON_Y = -100;
}

void mouseWheel(MouseEvent event) {
  if (!SHOW_CAMERA_LOCKED && !SHOW_CAMERA_INTRODUCTION) {
    float direction = event.getCount();
    if (direction == 1) { //-1 scrolling out  1 scolling in
      DESIRED_CAMERA_ZOOM -= CAMERA_ZOOM * CAMERA_ZOOM_SENSITIVITY;   //scroll out by decreasing zoom
    } else {
      DESIRED_CAMERA_ZOOM += CAMERA_ZOOM * CAMERA_ZOOM_SENSITIVITY;   //scroll in by increasing zoom
    }
    if (!isWithin(DESIRED_CAMERA_ZOOM, MIN_CAMERA_ZOOM, MAX_CAMERA_ZOOM)) {
      float deltaZoom;
      // are we scrolling in or out?
      if (direction == 1) {
        deltaZoom = DESIRED_CAMERA_ZOOM - MIN_CAMERA_ZOOM;
      } else {
        deltaZoom = DESIRED_CAMERA_ZOOM - MAX_CAMERA_ZOOM;
      }
      updatePosition(deltaZoom * CAMERA_ZOOM_SPEED * CAMERA_MOVEMENT_SENSITIVITY);
    }
  }
  DESIRED_CAMERA_ZOOM = constrain(DESIRED_CAMERA_ZOOM, MIN_CAMERA_ZOOM, MAX_CAMERA_ZOOM);
}

void updateCamera() {
  if (!SHOW_CAMERA_LOCKED) {
    float deltaZoom = DESIRED_CAMERA_ZOOM - CAMERA_ZOOM;
    updateZoom(deltaZoom * CAMERA_ZOOM_SPEED);
    updatePosition(deltaZoom * CAMERA_ZOOM_SPEED);
  } else {
    DESIRED_CAMERA_X = CAMERA_X;
    DESIRED_CAMERA_Y = CAMERA_Y;
    DESIRED_CAMERA_ZOOM = CAMERA_ZOOM;
  }
}

void updateZoom(float deltaZoom) {
  CAMERA_ZOOM += deltaZoom;
  CAMERA_ZOOM = constrain(CAMERA_ZOOM, MIN_CAMERA_ZOOM, MAX_CAMERA_ZOOM);
}

void updatePosition(float deltaZoom) {
  float realMouseX = (width/2 - mouseX) / CAMERA_ZOOM;
  float realMouseY = (height/2 - mouseY) / CAMERA_ZOOM;
  DESIRED_CAMERA_X -= (realMouseX * deltaZoom) / CAMERA_ZOOM;
  DESIRED_CAMERA_Y -= (realMouseY * deltaZoom) / CAMERA_ZOOM;
  DESIRED_CAMERA_X = constrain(DESIRED_CAMERA_X, CAMERA_BORDER_X1, CAMERA_BORDER_X2);
  DESIRED_CAMERA_Y = constrain(DESIRED_CAMERA_Y, CAMERA_BORDER_Y1, CAMERA_BORDER_Y2);
  float deltaX = DESIRED_CAMERA_X - CAMERA_X;
  float deltaY = DESIRED_CAMERA_Y - CAMERA_Y;
  CAMERA_X += deltaX * CAMERA_MOVEMENT_SPEED;
  CAMERA_Y += deltaY * CAMERA_MOVEMENT_SPEED;
}

void translateCamera() {
  translate(width/2, height/2);
  scale(CAMERA_ZOOM);
  translate(-CAMERA_X, -CAMERA_Y);
}


void showCameraBoundary() {
  //camera boundary
  stroke(140, 140, 140, 120);
  strokeWeight(40);
  line(CAMERA_BORDER_X1, CAMERA_BORDER_Y1, CAMERA_BORDER_X2, CAMERA_BORDER_Y1);
  line(CAMERA_BORDER_X2, CAMERA_BORDER_Y1, CAMERA_BORDER_X2, CAMERA_BORDER_Y2);
  line(CAMERA_BORDER_X2, CAMERA_BORDER_Y2, CAMERA_BORDER_X1, CAMERA_BORDER_Y2);
  line(CAMERA_BORDER_X1, CAMERA_BORDER_Y2, CAMERA_BORDER_X1, CAMERA_BORDER_Y1);

  //crosshairs
  stroke(140, 140, 140, 165);
  strokeWeight(max(20 - ((CAMERA_ZOOM/MAX_CAMERA_ZOOM) * 55), 0.5));
  line(CAMERA_X, CAMERA_BORDER_Y1, CAMERA_X, CAMERA_BORDER_Y2);
  line(CAMERA_BORDER_X1, CAMERA_Y, CAMERA_BORDER_X2, CAMERA_Y);
  stroke(140, 140, 140, 165);
  strokeWeight(max(20 - ((CAMERA_ZOOM/MAX_CAMERA_ZOOM) * 55), 0.5));
  line(CAMERA_X, CAMERA_Y, CAMERA_BORDER_X1, CAMERA_BORDER_Y1);
  line(CAMERA_X, CAMERA_Y, CAMERA_BORDER_X2, CAMERA_BORDER_Y1);
  line(CAMERA_X, CAMERA_Y, CAMERA_BORDER_X2, CAMERA_BORDER_Y2);
  line(CAMERA_X, CAMERA_Y, CAMERA_BORDER_X1, CAMERA_BORDER_Y2);
  //crosshair boundary
  stroke(140, 140, 140, 90);
  strokeWeight(30);
  point(CAMERA_X, CAMERA_BORDER_Y1);
  point(CAMERA_X, CAMERA_BORDER_Y2);
  point(CAMERA_BORDER_X1, CAMERA_Y);
  point(CAMERA_BORDER_X2, CAMERA_Y);
}

void showCameraMaxZoomBorder() {
  //max zoom camera borders
  stroke(140, 140, 140, min((((CAMERA_ZOOM/MAX_CAMERA_ZOOM) * 800) - 255), 150));
  strokeWeight(2/CAMERA_ZOOM);
  line(CAMERA_X - (width / MAX_CAMERA_ZOOM/2), CAMERA_Y - (height/ MAX_CAMERA_ZOOM/2),
    CAMERA_X + (width / MAX_CAMERA_ZOOM/2), CAMERA_Y - (height/ MAX_CAMERA_ZOOM/2));
  line(CAMERA_X + (width / MAX_CAMERA_ZOOM/2), CAMERA_Y - (height/ MAX_CAMERA_ZOOM/2),
    CAMERA_X + (width / MAX_CAMERA_ZOOM/2), CAMERA_Y + (height/ MAX_CAMERA_ZOOM/2));
  line(CAMERA_X + (width / MAX_CAMERA_ZOOM/2), CAMERA_Y + (height/ MAX_CAMERA_ZOOM/2),
    CAMERA_X - (width / MAX_CAMERA_ZOOM/2), CAMERA_Y + (height/ MAX_CAMERA_ZOOM/2));
  line(CAMERA_X - (width / MAX_CAMERA_ZOOM/2), CAMERA_Y + (height/ MAX_CAMERA_ZOOM/2),
    CAMERA_X - (width / MAX_CAMERA_ZOOM/2), CAMERA_Y - (height/ MAX_CAMERA_ZOOM/2));
}

void showCameraLocked() {
  stroke(255, 0, 0, 120);
  strokeWeight(24/CAMERA_ZOOM);
  line(CAMERA_X - (width / CAMERA_ZOOM/2), CAMERA_Y - (height/ CAMERA_ZOOM/2),
    CAMERA_X + (width / CAMERA_ZOOM/2), CAMERA_Y - (height/ CAMERA_ZOOM/2));
  line(CAMERA_X + (width / CAMERA_ZOOM/2), CAMERA_Y - (height/ CAMERA_ZOOM/2),
    CAMERA_X + (width / CAMERA_ZOOM/2), CAMERA_Y + (height/ CAMERA_ZOOM/2));
  line(CAMERA_X + (width / CAMERA_ZOOM/2), CAMERA_Y + (height/ CAMERA_ZOOM/2),
    CAMERA_X - (width / CAMERA_ZOOM/2), CAMERA_Y + (height/ CAMERA_ZOOM/2));
  line(CAMERA_X - (width / CAMERA_ZOOM/2), CAMERA_Y + (height/ CAMERA_ZOOM/2),
    CAMERA_X - (width / CAMERA_ZOOM/2), CAMERA_Y - (height/ CAMERA_ZOOM/2));
}

void showCameraStats() {
  textSize(15);
  fill(255, 255, 255, 220 * GUI_OPACITY);
  text("X: " + str(round(DESIRED_CAMERA_X)), width - 61, 20);
  text("Y: " + str(round(DESIRED_CAMERA_Y)), width - 60.5, 35);
  text("Zoom: " + str((float)round(DESIRED_CAMERA_ZOOM * 100)/100), width - 90, 50);
}

void showCameraIntroduction() {
  //CHECK WHICH EVENT IS BEING PLAYED AT THE MOMENT
  for (int IEVENT = 0; IEVENT < CAMERA_EVENT_TIMINGS.length; IEVENT++) {
    if (CAMERA_EVENT_TIMINGS[IEVENT] < millis()) {
      CAMERA_CURRENT_EVENT = IEVENT;
    }
  }

  //CHECK IF THE INTRODUCTION HAS BEEN SKIPPED
  if (mouseDown && mouseX > BUTTON_X - 145 && mouseX < BUTTON_X + 145 && mouseY > BUTTON_Y - 22.5 && mouseY < BUTTON_Y + 22.5) {  //290 width // 45 height
    CAMERA_EVENT_TIMINGS[4] = 0;
    CAMERA_EVENT_TIMINGS[5] = 0;
    CAMERA_EVENT_TIMINGS[CAMERA_EVENT_TIMINGS.length-1] = millis() + 700;
  }

  //DIM THE SCREEN
  rectMode(CORNER);
  fill(0, 0, 0, 190 * CAMERA_INTRODUCTION_OPACITY);
  rect(0, 0, width, height);

  switch(CAMERA_CURRENT_EVENT) {
    case(5):
    CAMERA_INTRODUCTION_OPACITY -= 0.16;
    case(4):
    TEXT_1_OPACITY -= 0.15;
    TEXT_2_OPACITY -= 0.15;
    TEXT_3_OPACITY -= 0.17;
    TEXT_4_OPACITY -= 0.17;
    BUTTON_OPACITY -= 0.10;
    case(3):
    TEXT_4_OPACITY += 0.15;
    TEXT_4_OPACITY = constrain(TEXT_4_OPACITY, 0, 1);
    TEXT_4_DESIRED_X = 200;
    TEXT_4_DESIRED_Y = 400;
    TEXT_4_DESIRED_X += (width/2- mouseX) / 41;
    TEXT_4_DESIRED_Y += (height/2 - mouseY) / 41;
    TEXT_4_X += (TEXT_4_DESIRED_X - TEXT_4_X) / 11;
    TEXT_4_Y += (TEXT_4_DESIRED_Y - TEXT_4_Y) / 11;
    case(2):
    BUTTON_OPACITY += 0.02;
    BUTTON_OPACITY = constrain(BUTTON_OPACITY, 0, 1);
    BUTTON_DESIRED_X = width/2;
    BUTTON_DESIRED_Y = 40;
    BUTTON_X += (BUTTON_DESIRED_X - BUTTON_X) / 14;
    BUTTON_Y += (BUTTON_DESIRED_Y - BUTTON_Y) / 14;

    TEXT_3_OPACITY += 0.15;
    TEXT_3_OPACITY = constrain(TEXT_3_OPACITY, 0, 1);
    TEXT_3_DESIRED_X = 250;
    TEXT_3_DESIRED_Y = 320;
    TEXT_3_DESIRED_X += (width/2- mouseX) / 41;
    TEXT_3_DESIRED_Y += (height/2 - mouseY) / 41;
    TEXT_3_X += (TEXT_3_DESIRED_X - TEXT_3_X) / 11;
    TEXT_3_Y += (TEXT_3_DESIRED_Y - TEXT_3_Y) / 11;
    case(1):
    TEXT_2_OPACITY += 0.12;
    TEXT_2_OPACITY = constrain(TEXT_2_OPACITY, 0, 1);
    TEXT_2_DESIRED_X = width/2 - 280;
    TEXT_2_DESIRED_Y = height/2 - 175;
    TEXT_2_DESIRED_X += (width/2- mouseX) / 41;
    TEXT_2_DESIRED_Y += (height/2 - mouseY) / 41;
    TEXT_2_X += (TEXT_2_DESIRED_X - TEXT_2_X) / 11;
    TEXT_2_Y += (TEXT_2_DESIRED_Y - TEXT_2_Y) / 11;
    case(0):
    CAMERA_INTRODUCTION_OPACITY += 0.13;
    CAMERA_INTRODUCTION_OPACITY = constrain(CAMERA_INTRODUCTION_OPACITY, 0, 1);
    TEXT_1_OPACITY += 0.12;
    TEXT_1_OPACITY = constrain(TEXT_1_OPACITY, 0, 1);
    TEXT_1_DESIRED_X = width/2 - 334;
    TEXT_1_DESIRED_Y = height/2 - 200;
    TEXT_1_DESIRED_X += (width/2- mouseX) / 30;
    TEXT_1_DESIRED_Y += (height/2 - mouseY) / 30;
    TEXT_1_X += (TEXT_1_DESIRED_X - TEXT_1_X) / 10;
    TEXT_1_Y += (TEXT_1_DESIRED_Y - TEXT_1_Y) / 10;
    break;
  }

  textSize(80);
  fill(255, 255, 255, 255 * TEXT_1_OPACITY);
  text("Evolution Simulator", TEXT_1_X, TEXT_1_Y);
  textSize(25);
  fill(255, 255, 255, 255 * TEXT_2_OPACITY);
  text("by Kelvin Zhang", TEXT_2_X, TEXT_2_Y);

  fill(255, 255, 255, 255 * TEXT_3_OPACITY);
  textSize(18);
  text("Watch the tiny creatures evolve to dodge a red ball!", TEXT_3_X, TEXT_3_Y);
  text("", TEXT_3_X, TEXT_3_Y + 20);
  text("", TEXT_3_X, TEXT_3_Y + 40);
  text("", TEXT_3_X, TEXT_3_Y + 60);

  textSize(24);
  fill(255, 255, 255, 255 * TEXT_4_OPACITY);
  text("Controls", TEXT_4_X - 12, TEXT_4_Y);
  strokeWeight(1.2);
  stroke(255, 255, 255, 255 * TEXT_4_OPACITY);
  line(TEXT_4_X - 15, TEXT_4_Y + 4, TEXT_4_X + 80, TEXT_4_Y + 4);
  textSize(24);
  text("A and D", TEXT_4_X + 2, TEXT_4_Y + 30);
  textSize(18);
  text("→ Change simulation speed", TEXT_4_X + 83, TEXT_4_Y + 30);
  textSize(15);
  text("with SHIFT, x4", TEXT_4_X + 110, TEXT_4_Y + 46);
  textSize(24);
  text("W and S", TEXT_4_X - 1, TEXT_4_Y + 70);
  textSize(18);
  text("→ Set max/min simulation speed", TEXT_4_X + 83, TEXT_4_Y + 70);
  textSize(24);
  text("Q and E", TEXT_4_X, TEXT_4_Y + 110);
  textSize(18);
  text("→ Change mutation intensity", TEXT_4_X + 83, TEXT_4_Y + 110);


  rectMode(CENTER);
  fill(120, 120, 120, 120 * BUTTON_OPACITY);
  noStroke();
  rect(BUTTON_X, BUTTON_Y, 290, 45, 14);
  textSize(25);
  textAlign(CENTER);
  fill(255, 255, 255, 150 * BUTTON_OPACITY);
  text("Skip", BUTTON_X, BUTTON_Y + 8);
  textAlign(LEFT);
}

void displayGUI() {
  noStroke();

  /*CAMERA TOGGLEABLES*/
  pushMatrix();
  translate((CAMERA_X - DESIRED_CAMERA_X) * 0.003, (CAMERA_Y - DESIRED_CAMERA_Y)* 0.005);
  if (SHOW_CAMERA_STATS) {
    showCameraStats();
  }
  popMatrix();
  //

  pushMatrix();
  translate((CAMERA_X - DESIRED_CAMERA_X) * 0.005, (CAMERA_Y - DESIRED_CAMERA_Y)* 0.002);

  fill(255, 255, 255, 255* GUI_OPACITY);
  textSize(30);
  text("Generation: " + str(currentGeneration), width/2 - 70, 40);
  textSize(20);
  popMatrix();

  pushMatrix();
  translate((CAMERA_X - DESIRED_CAMERA_X) * 0.002, (CAMERA_Y - DESIRED_CAMERA_Y)* 0.0015);

  //TIME ELAPSED
  rectMode(CORNER);
  float frameDiff = SIMULATION_FRAMES_PER_LIFETIME / 10;
  for (float frame = frameDiff; frame < SIMULATION_FRAMES_PER_LIFETIME - simulationFrame; frame += frameDiff) {
    fill(255 * ( 1 - (float)frame / SIMULATION_FRAMES_PER_LIFETIME), 255 * (float)frame / SIMULATION_FRAMES_PER_LIFETIME, 0, 130* GUI_OPACITY);
    square(width/2 - 200 + (frame/(frameDiff/20)), 47, 20.1);
  }
  fill(255, 255 * (1- (float)simulationFrame/SIMULATION_FRAMES_PER_LIFETIME), 255 * (1-  (float)simulationFrame/SIMULATION_FRAMES_PER_LIFETIME), 230* GUI_OPACITY);
  text("time elapsed: " + str((float)simulationFrame/1000), width/2 - 165, 64);
  //CREATURES LEFT
  float creatureDiff = N_CREATURES / 8;
  for (int x = 1; x < nCreaturesAlive; x += creatureDiff) {
    fill(255 * ( 1 - (float)x / N_CREATURES), 255 * (float)x / N_CREATURES, 0, 130* GUI_OPACITY);
    square(width/2 + 30 + (x/(creatureDiff/20)), 47, 20.1);
  }

  fill(255, 255, 255, 230* GUI_OPACITY);
  textSize(20);
  text("creatures left: " + str(nCreaturesAlive), width/2 + 45, 63);
  fill(255, 255, 255, 200* GUI_OPACITY);
  text("Mutation Intensity: " + str(mutationIntensity), width/2 - 430, 18);
  fill(255, 255, 255, 255* GUI_OPACITY);
  textAlign(CENTER);
  textSize(23);
  text("Previous Generation", width/2 +  362, 23);
  strokeWeight(1.8);
  stroke(255, 255, 255, 220 * GUI_OPACITY);
  line(width/2 +  362 - 100, 25.5, width/2 +  362 + 100, 25.5);
  textSize(16);
  text("Mean time survived", width/2 + 362, 47);
  textSize(19);
  text(str((float)round(lastGenMeanFitness * 1000)/ 1000), width/2 + 362, 64);
  textSize(16);
  text("Median time survived", width/2 + 362, 83);
  textSize(19);
  text(str((float)round(lastGenMedianFitness * 1000) / 1000), width/2 + 362, 100);
  textAlign(LEFT);
  textSize(17);
  text("simulation speed: " +  str(SIMULATION_SPEED) + "x", width/2 - 60, 83);
  popMatrix();
}


PVector getTranslatedXY() {
  float translatedMouseX = (mouseX - width/2) / CAMERA_ZOOM + CAMERA_X;
  float translatedMouseY = (mouseY - height/2) / CAMERA_ZOOM + CAMERA_Y;
  return new PVector(translatedMouseX, translatedMouseY);
}

boolean isWithin(float n, float lowerBound, float upperBound) {
  return n >= min(lowerBound, upperBound) && n <= max(lowerBound, upperBound)  ? true : false;
}
