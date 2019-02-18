/*
 * Serial Read Basic
 * -----------------
 * Blink the pin 13 LED if an 'H' is received over the serial port
 *
 * 
 */

int ledPin = 13;   // select the pin for the LED
int val = 0;       // variable to store the data from the serial port

void setup() {
  pinMode(ledPin,OUTPUT);    // declare the LED's pin as output
  Serial.begin(19200);        // connect to the serial port
}

void loop () {
  // Serial.available() is a way to see if there's serial data
  // without pausing your code
  if( Serial.available() ) {
    val = Serial.read();      // read the serial port  
    if( val == 'H' ) {        // if it's an 'H', blink the light
      digitalWrite(ledPin, HIGH);
      delay(1000);
      digitalWrite(ledPin, LOW);
    } 
  }

}

