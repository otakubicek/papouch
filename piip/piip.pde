/*
 * EEPROM Read
 *
 * Reads the value of each byte of the EEPROM and prints it 
 * to the computer.
 * This example code is in the public domain.
 */

#include <EEPROM.h>
#include <Tone.h>

Tone freq1;
Tone freq2;

const int DTMF_freq1[] = { 1336, 1209, 1336, 1477, 1209, 1336, 1477, 1209, 1336, 1477 };
const int DTMF_freq2[] = {  941,  697,  697,  697,  770,  770,  770,  852,  852,  852 };

void setup()
{
  Serial.begin(9600);
  freq1.begin(6);
  freq2.begin(7);
}

void playDTMF(uint8_t number, long duration)
{
  freq1.play(DTMF_freq1[number], duration);
  freq2.play(DTMF_freq2[number], duration);
}

void playHash(long duration)
{
  freq1.play(1477, duration);
  freq2.play(941, duration);
}

void playStar(long duration)
{
  freq1.play(1209, duration);
  freq2.play(941, duration);
}


// start reading from the first byte (address 0) of the EEPROM
int address = 0;
byte value;
int first = 0;
int second = 0;
int thirt = 0;
int nib1 = 0;
int nib2 = 0;

void loop()
{
  // read a byte from the current address of the EEPROM
  value = EEPROM.read(address);
  
  Serial.print(address);
  Serial.print("\t");
  Serial.println(value, HEX);
  // no need to download anything. lib will just work.

 
 
 
 
 // hash beep
 playHash(200);
 delay(400);
 
// address beep 

 thirt = address%10 ;
 second = ((address)%100 - thirt)/10;
 first = (address - thirt - second)/100; 
 
 playDTMF(first, 200);
    delay(400);
  playDTMF(second, 200);
    delay(400);  
   playDTMF(thirt, 200);
    delay(400); 
 // address beep end   
 
 
 
 
 
 // star beep
 playStar(200);
 delay(400);
 // number beep
 
 thirt = value%10 ;
 second = ((value)%100 - thirt)/10;
 first = (value - thirt - second)/100; 
 
 
 nib1 = value%16;
 Serial.println(nib1, HEX);
 nib2 = ((value)%255 - nib1)/16;
 Serial.println(nib2, HEX);
 
 
 
 
  playDTMF(first, 200);
    delay(400);
  playDTMF(second, 200);
    delay(400);  
   playDTMF(thirt, 200);
    delay(400); 
 // number beep end   
  // star beep
 playStar(200);
 delay(400);  
    
  // advance to the next address of the EEPROM
  address = address + 1;
  
  // there are only 512 bytes of EEPROM, from 0 to 511, so if we're
  // on address 512, wrap around to address 0
  if (address == 512)
    address = 0;
    
  delay(100);
}
