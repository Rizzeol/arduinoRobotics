/*
 * Serial Read Blink
 * -----------------
 * Turns on and off a light emitting diode(LED) connected to digital  
 * pin 13. The LED will blink the number of times given by a 
 * single-digit ASCII number read from the serial port.
 *
 * Created 18 October 2006
 * copyleft 2006 Tod E. Kurt <tod@todbot.com>
 * http://todbot.com/
 * 
 * based on "serial_read_advanced" example
 */

int motorPin = 9;
int val = 0;       // variable to store the data from the serial port

void setup() {
  pinMode(motorPin,OUTPUT);    // declare the motor's pin as output
  Serial.begin(19200);        // connect to the serial port
  Serial.println("Welcome to SerialMotorSpeed!");
  Serial.println("Enter speed number 0-9:");
}

void loop () {
  val = Serial.read();      // read the serial port
  if (val >= '0' && val <= '9' ) {
    val = val - '0';       // convert from character to number
    val = 28 * val;        // convert from 0-9 to 0-255 (almost)
    Serial.print("Setting speed to ");
    Serial.println(val);
    analogWrite(motorPin,val);
    
    Serial.println("Enter speed number 0-9:");
  }
}

