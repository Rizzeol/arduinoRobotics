/*
 * RGB Pot Mixer2
 * --------------
 *
 * Code for making one potentiometer control 3 LEDs, red, grn and blu, 
 * or one tri-color LED.
 *
 * Uses a purportedly correct algorithm for converting a hue number into RGB values
 * 
 * Code assumes you have the LEDs connected in a common-anode configuration,
 * with the LED's anode connected to +5V via a resistor and the cathode connected
 * to Arduino pins 9,10,11. 
 *
 * Tod E. Kurt <tod@todbot.com>, serial debug by Clay Shirky
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
  potVal = potVal / 4;           // convert from 0-1023 to 0-255

  hue_to_rgb( potVal );          // treat potVal as hue and convert to rgb vals
 
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

/*
 * Given a variable hue 'h', that ranges from 0-252,
 * set RGB color value appropriately.
 * Assumes maximum Saturation & maximum Value (brightness)
 * Performs purely integer math, no floating point.
 */
void hue_to_rgb(byte hue) 
{
    if( hue > 252 ) hue = 252;
    byte hd = hue / 42;   // 42 == 252/6,  252 == H_MAX
    byte hi = hd % 6;   // gives 0-5
    byte f  = hue % 42; 
    byte fs = f * 6;
    switch( hi ) {
        case 0:
            redVal = 252;     grnVal = fs;      bluVal = 0;
           break;
        case 1:
            redVal = 252-fs;  grnVal = 252;     bluVal = 0;
            break;
        case 2:
            redVal = 0;       grnVal = 252;     bluVal = fs;
            break;
        case 3:
            redVal = 0;       grnVal = 252-fs;  bluVal = 252;
            break;
        case 4:
            redVal = fs;      grnVal = 0;       bluVal = 252;
            break;
        case 5:
            redVal = 252;     grnVal = 0;       bluVal = 252-fs;
            break;
    }
}
