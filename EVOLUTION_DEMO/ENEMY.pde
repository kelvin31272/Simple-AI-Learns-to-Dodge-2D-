class Enemy {
  float enemyX, enemyY;
  PVector vel;
  float enemyRadius = 800;
  int currentTrack = 0;
  boolean alive;

  Enemy(float enemyX, float enemyY) {
    this.enemyX = enemyX;
    this.enemyY = enemyY;
    this.alive = false;
  }

  void Run() {
    //this is for following the mouse
    // float x = (mouseX - width/2 ) / CAMERA_ZOOM + CAMERA_X, y = (mouseY - height/2 ) / CAMERA_ZOOM  + CAMERA_Y;
    float x = enemyTrack[currentTrack][0];
    float y = enemyTrack[currentTrack][1];
    if (isWithinError(enemyX,enemyTrack[currentTrack][0],10) && isWithinError(enemyY,enemyTrack[currentTrack][1],10)) {
      currentTrack++;
      currentTrack = constrain(currentTrack,0,enemyTrack.length-1);
    }
    PVector dm = new PVector(x - enemyX, y -enemyY );
    vel = PVector.fromAngle(dm.heading());
    vel.setMag(enemySpeed);    
    enemyX += vel.x;
    enemyY += vel.y;
  }

  void Display() {
    noStroke();
    fill(255, 0, 0, 200);
    circle(enemyX, enemyY, enemyRadius * 2);
  }

  boolean isWithinError(float value, float target, float error) {
    return (value > target - error && value < target + error) ? true:false;
  }
}
