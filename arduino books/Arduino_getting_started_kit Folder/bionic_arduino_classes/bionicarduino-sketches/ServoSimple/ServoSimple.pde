/*
 * Servo Move Simple
 * -----------------
 * Move an R/C servo back and forth (0 to 180 degrees) using
 * delayMicroseconds() for pulse and delay() for time between pulses.
 *
 * Created 18 October 2006
 * copyleft 2006 Tod E. Kurt <tod@todbot.com>
 * http://todbot.com/
 *
 * Adapted from Daniel @
 * http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1160470155/0
 * Rotates servo through 180 degrees, using "servoPulse" function  
 * adapted from "Temporary Servo Function"  by Tom Igoe and Jeff Gray
 */
 
 
int servoPin = 7;            // R/C  Servo connected to digital pin
int myAngle;                 // angle of the servo (roughly in degrees) 0-180
int pulseWidth;              // function variable
 
void servoPulse(int servoPin, int myAngle) {
  pulseWidth = (myAngle * 9) + 700;  // converts angle to microseconds
  digitalWrite(servoPin, HIGH);       // set servo high
  delayMicroseconds(pulseWidth);      // wait a very small amount 
  digitalWrite(servoPin, LOW);        // set servo low
  Serial.print("pulseWidth: "); Serial.println(pulseWidth);
  delay(20);                          // refresh cycle of typical servos (20 ms)
}

void setup() {
  pinMode(servoPin, OUTPUT);          // set servoPin pin as output
  Serial.begin(19200);
}

void loop() {
  // cycle through every angle (rotate the servo 180 slowly)
  for (myAngle=0; myAngle<=180; myAngle++) {  
    servoPulse(servoPin, myAngle);
  }
  delay(1000);
} 
