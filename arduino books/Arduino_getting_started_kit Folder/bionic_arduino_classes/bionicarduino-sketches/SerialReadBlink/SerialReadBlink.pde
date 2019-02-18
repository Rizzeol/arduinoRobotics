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

int ledPin = 13;   // select the pin for the LED
int val = 0;       // variable to store the data from the serial port

void setup() {
  pinMode(ledPin,OUTPUT);    // declare the LED's pin as output
  Serial.begin(19200);        // connect to the serial port
  Serial.println("Welcome to SerialReadBlink!");
}

void loop () {
  val = Serial.read();      // read the serial port

  // if the stored value is a single-digit number, blink the LED that number
  if (val > '0' && val <= '9' ) {
    val = val - '0';       // convert from character to number
    for(int i=0; i<val; i++) {
      Serial.println("blink!");
      digitalWrite(ledPin,HIGH);
      delay(150);
      digitalWrite(ledPin, LOW);
      delay(150);
    }
  }
}

