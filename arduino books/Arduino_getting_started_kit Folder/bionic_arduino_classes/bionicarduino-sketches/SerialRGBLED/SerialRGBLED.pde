/* 
 * Serial RGB LED
 * ---------------
 * Serial commands control the brightness of R,G,B LEDs 
 *
 * Command structure is "<colorCode><colorVal>", where "colorCode" is
 * one of "r","g",or "b" and "colorVal" is a number 0 to 255.
 * E.g. "r0"   turns the red LED off.  
 *      "g127" turns the green LED to half brightness
 *      "b64"  turns the blue LED to 1/4 brightness
 *
 * Created 18 October 2006
 * copyleft 2006 Tod E. Kurt <tod@todbot.com
 * http://todbot.com/
 */

char serInString[30];  // array that will hold the different bytes of the string. 30=30characters;
                        // -> you must state how long the array will be else it won't work properly
char colorCode;
int colorVal;

int redPin   = 9;   // Red LED,   connected to digital pin 9
int greenPin = 11;  // Green LED, connected to digital pin 10
int bluePin  = 10;  // Blue LED,  connected to digital pin 11

void setup() {
  pinMode(redPin,   OUTPUT);   // sets the pins as output
  pinMode(greenPin, OUTPUT);   
  pinMode(bluePin,  OUTPUT);
  Serial.begin(19200);
  analogWrite(redPin,   127);   // set them all to mid brightness
  analogWrite(greenPin, 127);   // set them all to mid brightness
  analogWrite(bluePin,  127);   // set them all to mid brightness
  Serial.println("enter color command (e.g. 'r43') :");  
}

void loop () {
  //read the serial port and create a string out of what you read
  readSerialString(serInString);
    
  colorCode = serInString[0];
  if( colorCode == 'r' || colorCode == 'g' || colorCode == 'b' ) {
    colorVal = atoi(serInString+1);
    Serial.print("setting color ");
    Serial.print(colorCode);
    Serial.print(" to ");
    Serial.print(colorVal);
    Serial.println();
    serInString[0] = 0;                   // indicates we've used this string
    if(colorCode == 'r') 
      analogWrite(redPin, 255-colorVal);
    else if(colorCode == 'g')
      analogWrite(greenPin, 255-colorVal);
    else if(colorCode == 'b')
      analogWrite(bluePin, 255-colorVal);
  }
  
  delay(100);  // wait a bit, for serial data
}

//read a string from the serial and store it in an array
//you must supply the array variable
void readSerialString (char *strArray) {
  int i = 0;
  if(!Serial.available()) {
    return;
  }
  while (Serial.available()) {
    strArray[i] = Serial.read();
    i++;
  }
  strArray[i] = 0;  // indicate end of read string
}

