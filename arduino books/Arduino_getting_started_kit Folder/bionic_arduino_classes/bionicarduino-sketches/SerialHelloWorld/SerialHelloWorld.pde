/* Serial Hello World
 * ------------------- 
 * Simple Hello world for serial ports.
 * Print out "Hello world!" and blink pin 13 LED every second.
 *
 * Created 18 October 2006
 * copyleft 2006 Tod E. Kurt <tod@todbot.com>`
 * http://todbot.com/
 */


int ledPin = 13;   // select the pin for the LED
int i=0;           // simple counter to show we're doing something

void setup() {
  pinMode(ledPin,OUTPUT);   // declare the LED's pin as output
  Serial.begin(19200);        // connect to the serial port
}

void loop () {
  Serial.print(i++);
  Serial.println(" Hello world!");  // print out a hello
  digitalWrite(ledPin, HIGH);
  delay(500);
  digitalWrite(ledPin, LOW);
  delay(500);
}
