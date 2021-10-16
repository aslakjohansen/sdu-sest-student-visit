const int power = 7;
const int apin  = A0;

void setup() {
    // setup serial port
    Serial.begin(9600);
    
    // turn on sensing circuitry
    pinMode(power, OUTPUT);
    digitalWrite(power, HIGH);
}

float analog2temperature () {
  float f = (analogRead(apin)*5/1024.0 - 0.5)/0.01;
  float c = (f-32)*5/9;
  return c;
}

void loop() {
    Serial.print("{\"temperature\": ");
    Serial.print(analog2temperature());
    Serial.println("}");
    delay(500);
}
