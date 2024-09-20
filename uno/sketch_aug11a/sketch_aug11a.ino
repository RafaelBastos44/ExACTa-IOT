#define DELAY0 500
#define DELAY1 10
#define TH0 507
#define TH1 517
#define TH2 520

#define THENV 35

#define TH0m2 507
#define TH1m2 515
#define TH2m2 520

int led = 9;
int gate = A2;
int env = A0;
int audio = A1;

int valGate = 0;
int valEnv = 0;
int valAudio = 0;

int countTH0 = 0;
int countTH1 = 0;
int countTH2 = 0;


int countTH0m2 = 0;
int countTH1m2 = 0;
int countTH2m2 = 0;

unsigned int tempo = 0;
unsigned int now = 0;
unsigned int tempoAux1 = 0;

void setup() {
  pinMode(led, OUTPUT);
  pinMode(gate, INPUT);
  pinMode(env, INPUT);
  pinMode(audio,INPUT);
  Serial.begin(9600);
  digitalWrite(led, HIGH);

  tempoAux1 = tempo = millis();
}

void loop() {
  now = millis();
  if (now - tempo >= DELAY1){
    valAudio = analogRead(audio);
    valEnv = analogRead(env);
    
//    if (valAudio > TH0){
//      countTH0++;
//    }
//    
//    if (valAudio > TH1 || valAudio < TH0-(TH1 - TH0) ){
//      countTH1++;
//    }
//    if (valAudio > TH2 || valAudio < TH0-(TH2 - TH0) ){
//      countTH2++;
//    }

    if (valEnv > THENV) countTH1++;

    tempo += DELAY1;
  }


  
  if (now - tempoAux1 >= DELAY0){
      valEnv = analogRead(env);
//      Serial.print(countTH0);
//      Serial.print("   ");
      Serial.print("R");
      Serial.print(countTH1);
      Serial.print("   ");
      //Serial.println(20*log10(valEnv/20));
      //Serial.print(" ");
      Serial.print(valEnv);
//    Serial.print(countTH2);
    Serial.println("B");

    if(countTH1 >= (DELAY0/DELAY1)/2)
    {
      digitalWrite(led,HIGH);
    }
    else
    {
      digitalWrite(led,LOW);
    }
    
    countTH0 = 0;
    countTH1 = 0;
    countTH2 = 0;
    tempoAux1 += DELAY0;
  }
  
}
