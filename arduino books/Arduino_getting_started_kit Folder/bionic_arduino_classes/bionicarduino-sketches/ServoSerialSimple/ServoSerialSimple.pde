/* 
 * Servo Serial Simple
 * -------------------
 * Drive an R/C servo to one of nine positions based on an ASCII
 * number from 1 to 9 received over the serial port.
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
int val;                     // variable used to store data from serial port

void servoPulse(int servoPin, int myAngle) {
  pulseWidth = (myAngle * 9) + 700;  // converts angle to microseconds
  digitalWrite(servoPin, HIGH);       // set servo high
  delayMicroseconds(pulseWidth);      // wait a very small amount 
  digitalWrite(servoPin, LOW);        // set servo low
  delay(20);                          // refresh cycle of typical servos (20 ms)
}

void setup() {
  pinMode(servoPin, OUTPUT);          // set servoPin pin as output
  Serial.begin(19200);                 // connect to the serial port
  Serial.println("Servo Serial Simple ready");
}

void loop() {
  val = Serial.read();      // read the serial port

  // if the stored value is a single-digit number, blink the LED that number
  if (val >= '0' && val <= '9' ) {
    val = val - '0';       // convert from character to number
    val = val * (180/9);   // convert from number to degrees
    Serial.print("moving servo to ");
    Serial.print(val,DEC);
    Serial.println();
    for( int i=0; i<50; i++ ) {
      servoPulse(servoPin, val);
    }
  }
} 
