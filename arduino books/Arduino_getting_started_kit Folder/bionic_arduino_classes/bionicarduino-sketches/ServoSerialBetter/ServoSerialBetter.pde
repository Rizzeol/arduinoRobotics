/*
 * Servo Serial Better
 * -------------------
 *
 *
 * Created 18 October 2006
 * copyleft 2006 Tod E. Kurt <tod@todbot.com>
 * http://todbot.com/
 *
 * adapted from "http://itp.nyu.edu/physcomp/Labs/Servo"
 */

int servoPin = 7;     // Control pin for servo motor

int pulseWidth = 0;    // Amount to pulse the servo
long lastPulse = 0;    // the time in millisecs of the last pulse
int refreshTime = 20;  // the time in millisecs needed in between pulses
int val;               // variable used to store data from serial port

int minPulse = 700;   // minimum pulse width

void setup() {
  pinMode(servoPin, OUTPUT);  // Set servo pin as an output pin
  pulseWidth = minPulse;      // Set the motor position to the minimum
  Serial.begin(19200);         // connect to the serial port
  Serial.println("Servo Serial Better ready");
}

void loop() {
  val = Serial.read();      // read the serial port

  // if the stored value is a single-digit number, blink the LED that number
  if (val >= '0' && val <= '9' ) {
    val = val - '0';       // convert from character to number
    val = val * (180/9);   // convert from number to degrees
    pulseWidth = (val * 9) + minPulse;  // convert angle to microseconds
    Serial.print("moving servo to ");
    Serial.print(pulseWidth,DEC);
    Serial.println();
  }
  updateServo();   // update servo position
}

// called every loop(). 
// uses global variables servoPin, pulsewidth, lastPulse, & refreshTime
void updateServo() {
  // pulse the servo again if rhe refresh time (20 ms) have passed:
  if (millis() - lastPulse >= refreshTime) {
    digitalWrite(servoPin, HIGH);   // Turn the motor on
    delayMicroseconds(pulseWidth);  // Length of the pulse sets the motor position
    digitalWrite(servoPin, LOW);    // Turn the motor off
    lastPulse = millis();           // save the time of the last pulse
  }
}

