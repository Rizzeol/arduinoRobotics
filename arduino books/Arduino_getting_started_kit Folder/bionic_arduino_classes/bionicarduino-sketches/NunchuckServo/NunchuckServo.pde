/*
 * NunchuckServo
 *
 * 2007 Tod E. Kurt, http://todbot.com/blog/
 *
 * The Wii Nunchuck reading code is taken from Windmeadow Labs
 *   http://www.windmeadow.com/node/42
 */

#include <Wire.h>

int ledPin = 13;
int servoPin = 7;      // Control pin for servo motor

int pulseWidth = 0;    // Amount to pulse the servo
int refreshTime = 20;  // the time in millisecs needed in between pulses
long lastPulse;
int minPulse = 700;   // minimum pulse width
int loop_cnt=0;

void setup()
{
  Serial.begin(19200);
  pinMode(servoPin, OUTPUT);  // Set servo pin as an output pin
  pulseWidth = minPulse;      // Set the motor position to the minimum

  nunchuck_init(); // send the initilization handshake
  Serial.print("NunchuckServo ready\n");
}

void loop()
{
  checkNunchuck();
  updateServo();   // update servo position

  if( nunchuck_zbutton() )      // light the LED if z button is pressed
    digitalWrite(ledPin, HIGH);
  else 
    digitalWrite(ledPin,LOW);

  delay(1);        // this is hear to give a known time per loop
}


void checkNunchuck()
{
  if( loop_cnt > 100 ) {  // loop()s is every 1msec, this is every 100msec
    
    nunchuck_get_data();
    nunchuck_print_data();

    float tilt = nunchuck_accelx();    // x-axis, in this case ranges from ~70 - ~185
    tilt = (tilt - 70) * 1.5;        // convert to angle in degrees, roughly  
    pulseWidth = (tilt * 9) + minPulse; // convert angle to microseconds
    
    loop_cnt = 0;  // reset for 
  }
  loop_cnt++; 
  
}

// called every loop().
// uses global variables servoPin, pulsewidth, lastPulse, & refreshTime
void updateServo()
{
  // pulse the servo again if rhe refresh time (20 ms) have passed:
  if (millis() - lastPulse >= refreshTime) {
    digitalWrite(servoPin, HIGH);   // Turn the motor on
    delayMicroseconds(pulseWidth);  // Length of the pulse sets the motor position
    digitalWrite(servoPin, LOW);    // Turn the motor off
    lastPulse = millis();           // save the time of the last pulse
  }
}


//
// Nunchuck functions
//

static uint8_t nunchuck_buf[6];   // array to store nunchuck data,

// initialize the I2C system, join the I2C bus,
// and tell the nunchuck we're talking to it
void nunchuck_init()
{ 
  Wire.begin();	                // join i2c bus as master
  Wire.beginTransmission(0x52);	// transmit to device 0x52
  Wire.send(0x40);		// sends memory address
  Wire.send(0x00);		// sends sent a zero.  
  Wire.endTransmission();	// stop transmitting
}

// Send a request for data to the nunchuck
// was "send_zero()"
void nunchuck_send_request()
{
  Wire.beginTransmission(0x52);	// transmit to device 0x52
  Wire.send(0x00);		// sends one byte
  Wire.endTransmission();	// stop transmitting
}

// Receive data back from the nunchuck, 
// returns 1 on successful read. returns 0 on failure
int nunchuck_get_data()
{
  int cnt=0;
  Wire.requestFrom (0x52, 6);	// request data from nunchuck
  while (Wire.available ()) {
    // receive byte as an integer
    nunchuck_buf[cnt] = nunchuk_decode_byte(Wire.receive());
    cnt++;
  }
  nunchuck_send_request();  // send request for next data payload
  // If we recieved the 6 bytes, then go print them
  if (cnt >= 5) {
    return 1;   // success
  }
  return 0; //failure
}

// Print the input data we have recieved
// accel data is 10 bits long
// so we read 8 bits, then we have to add
// on the last 2 bits.  That is why I
// multiply them by 2 * 2
void nunchuck_print_data()
{ 
  static int i=0;
  int joy_x_axis = nunchuck_buf[0];
  int joy_y_axis = nunchuck_buf[1];
  int accel_x_axis = nunchuck_buf[2]; // * 2 * 2; 
  int accel_y_axis = nunchuck_buf[3]; // * 2 * 2;
  int accel_z_axis = nunchuck_buf[4]; // * 2 * 2;

  int z_button = 0;
  int c_button = 0;

  // byte nunchuck_buf[5] contains bits for z and c buttons
  // it also contains the least significant bits for the accelerometer data
  // so we have to check each bit of byte outbuf[5]
  if ((nunchuck_buf[5] >> 0) & 1) 
    z_button = 1;
  if ((nunchuck_buf[5] >> 1) & 1)
    c_button = 1;

  if ((nunchuck_buf[5] >> 2) & 1) 
    accel_x_axis += 2;
  if ((nunchuck_buf[5] >> 3) & 1)
    accel_x_axis += 1;

  if ((nunchuck_buf[5] >> 4) & 1)
    accel_y_axis += 2;
  if ((nunchuck_buf[5] >> 5) & 1)
    accel_y_axis += 1;

  if ((nunchuck_buf[5] >> 6) & 1)
    accel_z_axis += 2;
  if ((nunchuck_buf[5] >> 7) & 1)
    accel_z_axis += 1;

  Serial.print(i,DEC);
  Serial.print("\t");

  Serial.print("joy:");
  Serial.print(joy_x_axis,DEC);
  Serial.print(",");
  Serial.print(joy_y_axis, DEC);
  Serial.print("  \t");

  Serial.print("acc:");
  Serial.print(accel_x_axis, DEC);
  Serial.print(",");
  Serial.print(accel_y_axis, DEC);
  Serial.print(",");
  Serial.print(accel_z_axis, DEC);
  Serial.print("\t");

  Serial.print("but:");
  Serial.print(z_button, DEC);
  Serial.print(",");
  Serial.print(c_button, DEC);

  Serial.print("\r\n");  // newline
  i++;
}

// Encode data to format that most wiimote drivers except
// only needed if you use one of the regular wiimote drivers
char nunchuk_decode_byte (char x)
{
  x = (x ^ 0x17) + 0x17;
  return x;
}

// returns zbutton state: 1=pressed, 0=notpressed
int nunchuck_zbutton()
{
   return ((nunchuck_buf[5] >> 0) & 1) ? 0 : 1;  // voodoo
}

// returns zbutton state: 1=pressed, 0=notpressed
int nunchuck_cbutton()
{
   return ((nunchuck_buf[5] >> 1) & 1) ? 0 : 1;  // voodoo
}

// returns value of x-axis joystick
int nunchuck_joyx()
{
  return nunchuck_buf[0]; 
}

// returns value of y-axis joystick
int nunchuck_joyy()
{
  return nunchuck_buf[1];
}

// returns value of x-axis accelerometer
int nunchuck_accelx()
{
  return nunchuck_buf[2];   // FIXME: this leaves out 2-bits of the data
}

// returns value of y-axis accelerometer
int nunchuck_accely()
{
  return nunchuck_buf[3];   // FIXME: this leaves out 2-bits of the data
}

// returns value of z-axis accelerometer
int nunchuck_accelz()
{
  return nunchuck_buf[4];   // FIXME: this leaves out 2-bits of the data
}

