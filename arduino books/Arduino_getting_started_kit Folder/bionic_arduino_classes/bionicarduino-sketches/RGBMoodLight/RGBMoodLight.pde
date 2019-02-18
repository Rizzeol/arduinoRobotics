/*
 * Code for cross-fading 3 LEDs, red, green and blue, or one tri-color LED, using PWM
 * The program cross-fades slowly from red to green, green to blue, and blue to red
 * The debugging code assumes Arduino 0004, as it uses the new Serial.begin()-style functions
 * originally "dimmingLEDs" by Clay Shirky <clay.shirky@nyu.edu> 
 */

// Output
int redPin   = 9;   // Red LED,   connected to digital pin 9
int greenPin = 10;  // Green LED, connected to digital pin 10
int bluePin  = 11;  // Blue LED,  connected to digital pin 11

// Program variables
int redVal   = 255; // Variables to store the values to send to the pins
int greenVal = 1;   // Initial values are Red full, Green and Blue off
int blueVal  = 1;

int i = 0;     // Loop counter    
int wait = 15; // 50ms (.05 second) delay; shorten for faster fades
int DEBUG = 0; // DEBUG counter; if set to 1, will write values back via serial

void setup()
{
  pinMode(redPin,   OUTPUT);   // sets the pins as output
  pinMode(greenPin, OUTPUT);   
  pinMode(bluePin,  OUTPUT); 
  if (DEBUG) {           // If we want to see the pin values for debugging...
    Serial.begin(9600);  // ...set up the serial ouput on 0004 style
  }
}

// Main program
void loop()
{
  i += 1;      // Increment counter
  if (i < 255) // First phase of fades
  {
    redVal   -= 1; // Red down
    greenVal += 1; // Green up
    blueVal   = 1; // Blue low
  }
  else if (i < 509) // Second phase of fades
  {
    redVal    = 1; // Red low
    greenVal -= 1; // Green down
    blueVal  += 1; // Blue up
  } 
  else if (i < 763) // Third phase of fades
  {
    redVal  += 1; // Red up
    greenVal = 1; // Green lo2
    blueVal -= 1; // Blue down
  }
  else // Re-set the counter, and start the fades again
  {
    i = 1;
  }  

  // we do "255-redVal" instead of just "redVal" because the
  // LEDs are hooked up to +5V instead of Gnd
  analogWrite(redPin,   255 - redVal);   // Write current values to LED pins
  analogWrite(greenPin, 255 - greenVal); 
  analogWrite(bluePin,  255 - blueVal);  

  if (DEBUG) { // If we want to read the output
    DEBUG += 1;     // Increment the DEBUG counter
    if (DEBUG > 10) { // Print every 10 loops
      DEBUG = 1;     // Reset the counter
      Serial.print(i);       // Serial commands in 0004 style
      Serial.print("\t");    // Print a tab
      Serial.print("R:");    // Indicate that output is red value
      Serial.print(redVal);  // Print red value
      Serial.print("\t");    // Print a tab
      Serial.print("G:");    // Repeat for green and blue...
      Serial.print(greenVal);
      Serial.print("\t");    
      Serial.print("B:");    
      Serial.println(blueVal); // println, to end with a carriage return
    }
  }
  delay(wait); // Pause for 'wait' milliseconds before resuming the loop
}
