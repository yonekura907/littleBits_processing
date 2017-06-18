import processing.serial.*;
import processing.video.*;

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
int valueA0ModeDots, valueA1ModeDots, valueA0ModeLines, valueA1ModeLines, valueA0ModeZvideo, valueA1ModeZvideo;


// モード Lines ----------------------------------
float hueValueB; // 色相
float speedB = 3; // 円が進むスピード
int degB = 0; // 円の角度
float radiusB = 20; //円の半径
float targetRadiusB = 20;
float posBX,posBY,posBZ;
float targetPosBY = 0;
float easingB = 0.02; // イージング
PVector center;
float camX, camY, camZ;
float camera_radius = 1000;
float radB = 2;
float radSpeedB = 0.05;
ArrayList<PVector> points;
float h;



void setup() {
    size(1280, 960, P3D); // 画面サイズ
    background(0);
    colorMode(HSB,360,100,100,100); // カラーモードをHSB

    // Arduinoからのシリアル通信の受取
    println(Serial.list());
    myPort = new Serial(this, Serial.list()[3], 9600);
    myPort.bufferUntil('\n');

    // モード Lines --------------------------------
    points = new ArrayList<PVector>();
    camX = -200;
    camY = 0;
    camZ = 0;
    center = new PVector(width / 2, height / 2, height / 2);
    posBX = center.x;
    posBY = center.y;
    posBZ = center.z;
    hueValueB = random(0,360);
    speedB = 3;
    degB = 0;
}



void draw() {
    background(0);

    // シリアルイベントへ転送
    while (myPort.available () > 0) {
        serialEvent(myPort.read());
    }


    // モード　Lines --------------------------------------------

    // A0,A1のインプットを保存
    valueA0ModeLines = int(map(inputA0,0,255,10,250));
    valueA1ModeLines = int(map(inputA1,0,255,-200,200));


    // 座標をセーブ
    pushMatrix();
    //カメラの設定
    camera(center.x + camX, center.y + camY, center.z + camZ, center.x, center.y, center.z, 0, 1, 0);
    // 座標変換で円の基点を画面の中央に
    translate(center.x, center.y, center.z);
    // translate(width/2, height/2, -10);
    // A0を円周に
    targetRadiusB = valueA0ModeLines;
    // A1をY座標に
    targetPosBY = valueA1ModeLines;

    // 座標の差分を引いてイージングを
    float dr = targetRadiusB - radiusB;
    float dy = targetPosBY - posBY;

    if(abs(dr) > 1.0){
        radiusB = radiusB + dr * easingB;
    }
    if(abs(dy) > 1.0){
        posBY = posBY + dy * easingB;
    }

    // 弧を描く計算
    float posBX = radiusB * cos(radians(degB));
    float posBZ = radiusB * sin(radians(degB));

    // ArrayListに追加　座標をベクトル保存
    points.add(new PVector(posBX, posBY, posBZ));

    
    noFill(); // 塗りなし
    strokeWeight(2);// 線幅
    scale(3); // 3倍に拡大
    stroke(255); // 仮の色

    h = hueValueB; // 色相
    beginShape(); // シェイプの開始
    for (PVector v : points) {
        stroke(h,100,100,100); // 変化する線の色
        vertex(v.x, v.y, v.z); // シェイプの座標
        h += 0.1;
        // もし色相の値が360を超えたら
        if(h>360){
        // 色相の値を0に戻す
            h = 0;
        }
    }
    // point(posBX,posBY,posBZ);
    endShape(); // シェイプの終了

    // 角度にスピードを代入
    degB += speedB;
    //もし角度が360を超えたら角度を0に戻す
    if(degB>360){
        degB=0;
    }

    popMatrix(); // 座標のロード　呼び戻し

    // カメラのアニメーション
    // camX = camera_radius * cos(radB);
    camX = center.x;
    camY = camera_radius * sin(radB);
    camZ = camera_radius * cos(radB);
    radB += radSpeedB * 0.01;
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

    // println("buff1: "+buff1);
    // println("buff2: "+buff2);
    // println("buff3: "+buff3);


    // 値を0−255に変換して変数に保存
    inputA0 = int(map(int(buff_A0),0,1023,0,255));
    inputA1 = int(map(int(buff_A1),0,1023,0,255));
    inputD0 = int(buff_D0);

    // buffの値をクリア
    buff = "";
  }
}