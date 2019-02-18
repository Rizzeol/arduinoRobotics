/* Sound Serial (aka Keyboard Serial)
 * ------------
 *
 * Program to play tones depending on the data coming from the serial port.
 *
 * The calculation of the tones is made following the mathematical
 * operation:
 *
 *       timeHigh = 1/(2 * toneFrequency) = period / 2
 *
 * where the different tones are described as in the table:
 *
 * note 	frequency 	period 	PW (timeHigh)	
 * c 	        261 Hz 	        3830 	1915 	
 * d 	        294 Hz 	        3400 	1700 	
 * e 	        329 Hz 	        3038 	1519 	
 * f 	        349 Hz 	        2864 	1432 	
 * g 	        392 Hz 	        2550 	1275 	
 * a 	        440 Hz 	        2272 	1136 	
 * b 	        493 Hz 	        2028	1014	
 * C	        523 Hz	        1912 	956
 *
 * (cleft) 2005 D. Cuartielles for K3
 *
 * Updated by Tod E. Kurt <tod@todbot.com> to use new Serial. commands
 * and have a longer cycle time.
 *
 */

int ledPin = 13;
int speakerPin = 7;

// note names and their corresponding half-periods  
byte names[] ={ 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C'};  
int tones[] = { 1915, 1700, 1519, 1432, 1275, 1136, 1014, 956};
  
int serByte = -1;
int ledState = LOW;
int count = 0;

void setup() {
  pinMode(ledPin, OUTPUT); 
  pinMode(speakerPin, OUTPUT); 
  beginSerial(19200);
  Serial.println("ready");
}

void loop() {
  digitalWrite(speakerPin, LOW);
  serByte = Serial.read();
  if (serByte != -1) {
    Serial.print(serByte,BYTE);
    ledState = !ledState;           // flip the LED state
    digitalWrite(ledPin, ledState); // write to LED
  }
  for (count=0;count<=8;count++) {  // look for the note
    if (names[count] == serByte) {  // ahh, found it
      for( int i=0; i<50; i++ ) {   // play it for 50 cycles
        digitalWrite(speakerPin, HIGH);
        delayMicroseconds(tones[count]);
        digitalWrite(speakerPin, LOW);
        delayMicroseconds(tones[count]);
      }
    }
  }
}
