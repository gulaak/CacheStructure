float accessTime = 0;
void setup() {
  // put your setup code here, to run once:
  pinMode(43,OUTPUT);
  pinMode(44,OUTPUT);
  pinMode(45,OUTPUT);
  pinMode(46,OUTPUT);
  pinMode(48,OUTPUT);
  pinMode(49,OUTPUT);
  pinMode(42,INPUT);


  for(int i=0; i< 9; i+=2){

      addressOut(i);  // stride address space of Cache by 2
      cacheWrite();
      
      
  }

  for(int i=0; i<9; i+=2){
      timingfromCache(i);
      Serial.println(accessTime/2000);
      waitforUser();
    
  }
  for(int i=1; i<10; ++i){
      timingfromCache(i);
      Serial.println(accessTime/200);
      waitforUser();
  }


}

void loop() {
  // put your main code here, to run repeatedly:

}

uint32_t requestfromCache(uint16_t addr) {
  addressOut(addr);
  digitalWrite(48, HIGH);
  while (!digitalRead(42)) {


  }




}
float timingfromCache(uint16_t addr) {
  float tempTime = micros();
  requestfromCache(addr);
  accessTime = micros() - tempTime;
}

void waitforUser() {
  String x = Serial.readString();


}
void cacheWrite(){
  Serial.println("Specify Data for Write");
  Serial.readString();
  digitalWrite(49,HIGH);
  delay(1000);
  digitalWrite(49,LOW);

  
}

void addressOut(uint8_t addrValue) {

  switch (addrValue) {
    case 0:
      digitalWrite(43, LOW);
      digitalWrite(44, LOW);
      digitalWrite(45, LOW);
      digitalWrite(46, LOW);
      break;
    case 1:
      digitalWrite(43, HIGH);
      digitalWrite(44, LOW);
      digitalWrite(45, LOW);
      digitalWrite(46, LOW);
      break;
    case 2:
      digitalWrite(43, LOW);
      digitalWrite(44, HIGH);
      digitalWrite(45, LOW);
      digitalWrite(46, LOW);
      break;
    case 3:
      digitalWrite(43, HIGH);
      digitalWrite(44, HIGH);
      digitalWrite(45, LOW);
      digitalWrite(46, LOW);
      break;
    case 4:
      digitalWrite(43, LOW);
      digitalWrite(44, LOW);
      digitalWrite(45, HIGH);
      digitalWrite(46, LOW);
      break;
    case 5:
      digitalWrite(43, HIGH);
      digitalWrite(44, LOW);
      digitalWrite(45, HIGH);
      digitalWrite(46, LOW);
      break;
    case 6:
      digitalWrite(43, LOW);
      digitalWrite(44, HIGH);
      digitalWrite(45, HIGH);
      digitalWrite(46, LOW);
      break;
    case 7:
      digitalWrite(43, HIGH);
      digitalWrite(44, HIGH);
      digitalWrite(45, HIGH);
      digitalWrite(46, LOW);
      break;
    case 8:
      digitalWrite(43, LOW);
      digitalWrite(44, LOW);
      digitalWrite(45, LOW);
      digitalWrite(46, HIGH);
      break;
    case 9:
      digitalWrite(43, HIGH);
      digitalWrite(44, LOW);
      digitalWrite(45, LOW);
      digitalWrite(46, HIGH);
      break;
    case 10:
      digitalWrite(43, LOW);
      digitalWrite(44, HIGH);
      digitalWrite(45, LOW);
      digitalWrite(46, HIGH);
      break;
    case 11:
      digitalWrite(43, HIGH);
      digitalWrite(44, HIGH);
      digitalWrite(45, LOW);
      digitalWrite(46, HIGH);
      break;
    case 12:
      digitalWrite(43, LOW);
      digitalWrite(44, LOW);
      digitalWrite(45, HIGH);
      digitalWrite(46, HIGH);
      break;
    case 13:
      digitalWrite(43, HIGH);
      digitalWrite(44, LOW);
      digitalWrite(45, HIGH);
      digitalWrite(46, HIGH);
      break;
    case 14:
      digitalWrite(43, LOW);
      digitalWrite(44, HIGH);
      digitalWrite(45, HIGH);
      digitalWrite(46, HIGH);
      break;

    case 15:
      digitalWrite(43, HIGH);
      digitalWrite(44, HIGH);
      digitalWrite(45, HIGH);
      digitalWrite(46, HIGH);
      break;

  }

}
