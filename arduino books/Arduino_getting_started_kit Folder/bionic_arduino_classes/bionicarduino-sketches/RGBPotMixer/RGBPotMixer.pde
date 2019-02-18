/*
 * RGB Pot Mixer
 * -------------
 *
 * Code for making one potentiometer control 3 LEDs, red, grn and blu, 
 * or one tri-color LED.
 * The program cross-fades from red to grn, grn to blu, and blu to red.
 * 
 * Code assumes you have the LEDs connected in a common-anode configuration,
 * with the LED's anode connected to +5V via a resistor and the cathode connected
 * to Arduino pins 9,10,11. 
 *
 * Originally by Clay Shirky <clay.shirky@nyu.edu> 
 * Modified slightly by Tod E. Kurt <tod@todbot.com>
 *
 */

// INPUT: Potentiometer should be connected to 5V and GND
int potPin = 2;  // Potentiometer output
int potVal = 0;  // Variable to store the input from the potentiometer

// OUTPUT: Use digital pins 9-11, the Pulse-width Modulation (PWM) pins
int redPin = 9;   // Red LED,   connected to digital pin 9
int grnPin = 11;  // Green LED, connected to digital pin 10
int bluPin = 10;  // Blue LED,  connected to digital pin 11

// Program variables
int redVal = 0;   // Variables to store the values to send to the pins
int grnVal = 0;
int bluVal = 0;

int DEBUG = 0;          // Set to 1 to turn on debugging output

void setup()
{
  pinMode(redPin, OUTPUT);   // sets the pins as output
  pinMode(grnPin, OUTPUT);   
  pinMode(bluPin, OUTPUT); 

  if (DEBUG) {           // If we want to see the pin values for debugging...
    Serial.begin(19200);  // ...set up the serial ouput in 0004 format
  }
}

// Main program
void loop()
{
  potVal = analogRead(potPin);   // read the potentiometer value at the input pin
 
  if (potVal < 341)  { // Lowest third of the potentiometer's range (0-340)
    potVal = (potVal * 3) / 4; // Normalize to 0-255

    redVal = 255 - potVal;  // Red from full to off
    grnVal = potVal;        // Green from off to full
    bluVal = 1;             // Blue off
  }
  else if (potVal < 682) { // Middle third of potentiometer's range (341-681)
    potVal = ( (potVal-341) * 3) / 4; // Normalize to 0-255

    redVal = 1;            // Red off
    grnVal = 255 - potVal; // Green from full to off
    bluVal = potVal;       // Blue from off to full
  }
  else  { // Upper third of potentiometer"s range (682-1023)
    potVal = ( (potVal-683) * 3) / 4; // Normalize to 0-255

    redVal = potVal;       // Red from off to full
    grnVal = 1;            // Green off
    bluVal = 255 - potVal; // Blue from full to off
  }
  
  // "255-" is because we have common-anode LEDs, not common-cathode
  analogWrite(redPin, 255-redVal);   // Write values to LED pins
  analogWrite(grnPin, 255-grnVal); 
  analogWrite(bluPin, 255-bluVal);  

  if (DEBUG) { // If we want to read the output
    DEBUG += 1;      // Increment the DEBUG counter
    if (DEBUG > 100) { // Print every hundred loops
      DEBUG = 1;     // Reset the counter
      Serial.print("R:");    // Indicate that output is red value
      Serial.print(redVal);  // Print red value
      Serial.print("\t");    // Print a tab
      Serial.print("G:");    // Repeat for grn and blu...
      Serial.print(grnVal);
      Serial.print("\t");    
      Serial.print("B:");    
      Serial.println(bluVal); // println, to end with a carriage return
    }
  }
}
