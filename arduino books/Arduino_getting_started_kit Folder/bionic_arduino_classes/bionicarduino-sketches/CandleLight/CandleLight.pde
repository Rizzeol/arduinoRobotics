/*
 * CandleLight
 * -----------
 * 
 * Use random numbers to emulate a flickering candle with a PWM'd LED
 *
 * 2007 Tod E. Kurt <tod@todbot.com>
 * http://todbot.com/
 * 
 */

int ledPin = 9;    // select the pin for the LED
int val = 0;       // variable that holds the current LED brightness
int delayval = 0;  // variable that holds the current delay time

void setup() {
  randomSeed(0);            // initialize the random number generator
  pinMode(ledPin, OUTPUT);  // declare the ledPin as an OUTPUT
}

void loop() {
  val = random(100,255);       // pick a random number between 100 and 255
  analogWrite(ledPin, val);    // set the LED brightness

  delayval = random(50,150);   // pick a random number between 30 and 100
  delay(delayval);             // delay that many milliseconds
}
