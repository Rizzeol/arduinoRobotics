/*
 * FadeOrBlink
 *
 *
 */

int ledPin = 9;                // choose the pin for the LED
int inputPin = 2;               // choose the input pin (for a pushbutton)
int val = 0;                    // variable for reading the pin status
int fadeval = 0;

void setup() {
  pinMode(ledPin, OUTPUT);      // declare LED as output
  pinMode(inputPin, INPUT);     // declare pushbutton as input
}

void loop(){
  val = digitalRead(inputPin);  // read input value
  if (val == HIGH) {            // pushed button means do blinking  
    digitalWrite(ledPin, LOW);  // turn LED OFF
    delay(50);
    digitalWrite(ledPin, HIGH); // turn LED ON
    delay(50);
  }
  else {  // else button isn't pressed so do fading
    for(fadeval = 0 ; fadeval <= 255; fadeval+=5) { // fade in (from min to max) 
      analogWrite(ledPin, fadeval);           // sets the value (range from 0-255) 
      delay(10);                           
    } 
    for(fadeval = 255; fadeval >=0; fadeval-=5) { // fade out (from max to min) 
      analogWrite(ledPin, fadeval); 
      delay(10); 
    }
  }
}
