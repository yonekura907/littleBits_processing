import processing.serial.*;

// 共通 ------------------------------------

// シリアルポート
Serial myPort;
String buff = "";
String buff_A0 = "";
String buff_ADMix = "";
String buff_A1 = "";
String buff_D0 = "";
int index = 0;
int index2 = 0;
int NEWLINE = 10;

// シリアルポートから受け取った値
int inputA0, inputA1, inputD0;
// int valueA0ModeDots, valueA1ModeDots;



// モード Dots ----------------------------------
int NUMA = 255; //ドットの数
color[] colA = new color[NUMA]; // カラー用配列
int littleBitsHue = 283; // littleBitsの色相
Particle[] particlesA = new Particle[NUMA]; // クラス用配列
PImage logo; // ロゴ画像


void setup() {
    size(1024, 768, P3D); // 画面サイズ
    colorMode(HSB,360,100,100,100); // カラーモードをHSB

    // Arduinoからのシリアル通信の受取
    println(Serial.list());
    myPort = new Serial(this, Serial.list()[3], 9600);
    myPort.bufferUntil('\n');


    // モード Dots --------------------------------
    // ロゴ配置
    logo = loadImage("littebits_logo.png");
    for(int i = 0; i < NUMA; i++){
        noFill();
        particlesA[i] = new Particle(random(80,width-80),random(80, height-80),random(-4,4),random(-4,4),random(8,80));
    }
}


void draw() {
    background(0);

    // シリアルイベントへ転送
    while (myPort.available () > 0) {
        serialEvent(myPort.read());
    }

    // モード　Dots --------------------------------------------
    
    // インプット
    int valueA0ModeDots = int(map(inputA0,0,255,4,80));

    println("valueA0ModeDots: "+valueA0ModeDots);
    int valueA1ModeDots = int(map(inputA1,0,255,238,360));
            
    // 背景
    fill(color(0,0,100,100));
    noStroke();
    rect(0, 0, width, height);

    // ロゴの配置
    imageMode(CENTER);
    image(logo, width/2, height/2, 500, 500);

    num = random(360); //90

    hue = num;

    hue =  val - num;

    if(hue + val > 360){
        
    }

    col[i] = color(hue,100,100,100);

    // 色を2色に分岐　A1の値から色を変化
    for(int i = 0; i < valueA0ModeDots; i++){
        // colA[i] = color(58, 98, 49, 90);
        // if (i%2 == 0) {
            colA[i] = color(58 + valueA1ModeDots, 98, 49, 90);
        // } else {
        //     colA[i] = color(valueA1ModeDots-180, 98, 70, 90);
        // }
        fill(colA[i]);
        particlesA[i].display();
        particlesA[i].update();
    }
}

// シリアルイベントの処理
void serialEvent(int serial){
  if (serial != NEWLINE) {
    // シリアルで届いた値を文字列にしてbuffeに加える
    buff += char(serial);
  }
  else {
    // D0,A0,A1 の　3つの値を文字列で連結
    buff = buff.substring(0, buff.length()-1);
    index = buff.indexOf(",");
    buff_A0 = buff.substring(0, index);
    buff_ADMix = buff.substring(index+1, buff.length());
    index2 = buff_ADMix.indexOf(",");
    buff_A1 = buff_ADMix.substring(0, index2);
    buff_D0 = buff_ADMix.substring(index2+1, buff_ADMix.length());

    // 値を0−255に変換して変数に保存
    inputA0 = int(map(int(buff_A0),0,1023,0,255));
    inputA1 = int(map(int(buff_A1),0,1023,0,255));
    inputD0 = int(buff_D0);

    // buffの値をクリア
    buff = "";
  }
}