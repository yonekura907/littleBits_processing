// アナログボタン
int a0;
int a1;

// デジタルボタン
int buttonPushCounter = 0; //ボタンカウンター
int buttonState = 0; // ボタンの状態
int lastButtonState = 0; // 前回のボタン¥の状態

void setup() {
  Serial.begin(9600);
  while(!Serial);
}

void loop() {
  a0 = analogRead(A0);
  a1 = analogRead(A1);

  // ボタンを読取
  buttonState = digitalRead(0);
  
  // 前回の状態と比較
  if( buttonState != lastButtonState){
    
    // 状態が変化していたらカウンタを1増やす
    if (buttonState == 1) {
      // 現在の状態がなら1
      
      buttonPushCounter++; // インクリメント
//      Serial.println("on");
//      Serial.print("number of button pushes:  ");
//      Serial.println(buttonPushCounter);
    } else {
//      Serial.println("off");
    }
    // 次回のために現在の状態を最後の状態と差し替えるs
    lastButtonState = buttonState;

    if(buttonPushCounter > 2){
      buttonPushCounter = 0;
    }
  }

  Serial.print(a0);
  Serial.print(",");
  Serial.print(a1);
  Serial.print(",");
  Serial.println(buttonPushCounter);
  
  // 遅延
  delay(10);

}





