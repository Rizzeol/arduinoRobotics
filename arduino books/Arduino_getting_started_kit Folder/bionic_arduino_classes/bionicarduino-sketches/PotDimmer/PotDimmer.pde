/*
 * PotDimmer 
 * ---------
 * 
 * Use a potentiometer to adjust the brightness of an PWM'd LED
 * 
 */

int potPin = 2;    // select the input pin for the potentiometer
int ledPin = 9;   // select the pin for the LED
int val = 0;       // variable to store the value coming from the sensor

void setup() {
  pinMode(ledPin, OUTPUT);  // declare the ledPin as an OUTPUT
}

void loop() {
  val = analogRead(potPin);    // read the value from the sensor
  val = val/4;                 // convert from 0-1023 to 0-255
  analogWrite(ledPin, val);    // turn the ledPin on
}
