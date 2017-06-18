class Particle {
  float posX,posY; // 位置
  float speedX, speedY; // スピード
  float diameter; // 直径  

  Particle(float _x, float _y, float _speedX, float _speedY, float _diameter) {
    posX = _x;
    posY = _y;
    speedX = _speedX;
    speedY = _speedY;
    diameter = _diameter;
  }

  void display() {
    noStroke();
    ellipse(posX, posY, diameter, diameter);
  }

  void update() {
    // 座標にスピードを足す
    posX += speedX;
    posY += speedY;

    // 壁の跳ね返り
    if(posX > width - diameter/2 || posX < 0 + diameter/2){
          speedX = -1 * speedX;
      }
    if(posY > height - diameter/2 || posY < 0 + diameter/2){
        speedY = -1 * speedY;
    }
  }
}