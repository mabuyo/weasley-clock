// This #include statement was automatically added by the Particle IDE.
#include "neopixel/neopixel.h"

 

//#include <SPI.h>
//#include "Adafruit_GFX.h"
//#include "Adafruit_RA8875.h"

// Define PINS  ****************//
#define NEOPIXEL D0
#define MOSIDISPLAY D2
#define MISODISPLAY D3
#define SCKDISPLAY D4
#define SSDISPLAY D5 // Might not need
#define RANGEFINDER A0
#define AMBIENTLIGHT A2
#define LEDDRIVER DAC1

// Define Cool Variables and constants **//
#define NUMPIXELS 48
int ambientLight = 0;
bool movement = false;
int neopixelBrightness = 0;
int presence = 0;
int waiting = 0;


Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, NEOPIXEL);


// Define Cool Functions *********//
int MeasureAmbientLight(); 
bool CheckForMovement();
void SetBrightness();
int setCurrentUser(String);
int updateLocation(String);
void UpdateLED();


struct Location {
    String name;
    int clock_position;
};

struct User {
    String name;
    String location;
};

int testLED = D7;

User user1; //test
User users[4];
User user2;


User current_user;


//********************** SETUP ********************************//
//*************************************************************//
void setup() {
    // Setup PIN Modes
    pinMode(A2, INPUT);
    pinMode(RANGEFINDER, INPUT);
    pinMode(LEDDRIVER, OUTPUT);
    pinMode(MISODISPLAY, OUTPUT);
    pinMode(MOSIDISPLAY, OUTPUT);
    pinMode(SCKDISPLAY, OUTPUT);
    pinMode(SSDISPLAY, OUTPUT);
    pinMode(NEOPIXEL, OUTPUT);
    pinMode(LEDDRIVER, OUTPUT);

    Serial.begin(9600);
    pixels.begin();
    
    //Cool setup light show
    analogWrite(LEDDRIVER,800);  
    delay(300);
    analogWrite(LEDDRIVER,900);  
    delay(300);
    analogWrite(LEDDRIVER,950);  
    delay(300);
    analogWrite(LEDDRIVER,1000);  
    delay(300);
    analogWrite(LEDDRIVER,1100);  
    delay(300);
 

         for(int i = 0; i<NUMPIXELS; i++){
        pixels.setPixelColor(i, pixels.Color(0,0,0)); 
         pixels.show(); 
     }
    
    
    user1 = {"Michelle", "Bug"};
    users[0] = user1;
    
    user2 = {"Brad" , "Bug"};
    users[1] = user2;
    
    
    
    
    
    // this is what the iosApp can access
    Spark.function("setUser", setCurrentUser);
    Spark.function("update", updateLocation);
    Spark.variable("userLoc", current_user.location);
    //DisplayNames(); //TODO
    
    
    
    //HARD CODED JUNK
    pixels.setPixelColor(0, pixels.Color(0,0,100));
    pixels.show();
    pixels.setPixelColor(1, pixels.Color(100,0,0));
    pixels.show();
    pixels.setPixelColor(14, pixels.Color(0,100,0));
    pixels.show();
    pixels.setPixelColor(3, pixels.Color(50,50,50));
    pixels.show();
}

//********************** LOOP *********************************//
//*************************************************************//




void loop() {
    ambientLight = MeasureAmbientLight(); 
    movement = CheckForMovement(); 
    SetBrightness();  
    delay(300);


}





int MeasureAmbientLight() {
    return analogRead(A2);
}

bool CheckForMovement() {
    int range =  analogRead(RANGEFINDER);
    Serial.print("RANGE IS:");
    Serial.println(range);
    if (range < 200) {
        presence = 1; 
        waiting = 10;
    } else {
        presence = 0;
    }
    if (waiting > 0) {
        presence = 1;
        waiting--;
    }
    return true;
}

 void SetBrightness() {
    if (ambientLight >= 0 && ambientLight <=1000) {  
         analogWrite(LEDDRIVER,200*presence + 900);
         neopixelBrightness = 50;
    } else if (ambientLight > 1000 && ambientLight <=1500) {
        analogWrite(LEDDRIVER,100*presence + 900);
        neopixelBrightness = 50;
    } else if (ambientLight > 1500 && ambientLight <=2000) {
        analogWrite(DAC1,100*presence +  500);  
        neopixelBrightness = 50;
    } else {
        analogWrite(LEDDRIVER,50*presence + 800); 
        neopixelBrightness = 25;

    }
 }










int setCurrentUser(String username) {
    User user;
    for (int i = 0; i < 4; i++) {
        if (username == users[i].name) {  // found the user
            user = users[i];
            digitalWrite(testLED, HIGH);
            current_user = user;
            return 1;
        }
    }
    return -1;
}

// call this after setCurrentUser
int updateLocation(String location) {
    current_user.location = location;
        UpdateLED();
    Particle.publish("update all");
    return 1;

}


void UpdateLED() {
    int user_no;
    int red = 0;
    int green = 0;
    int blue = 0;
    for (int i = 0; i < 4; i++) {
        if (current_user.name == users[i].name) {  // found the user
            user_no = i;
        }    
    }
    
    if (user_no == 0) {
        red = 0;
        green = 0;
        blue = 2; 
    } else if (user_no == 1) {
        red = 2;
        green = 0;
        blue = 0;
    } else if (user_no == 2) {
        red = 0;
        green = 2;
        blue = 0; 
    } else {
        red = 1;
        green = 1;
        blue = 1; 
    }
    
    int clock_no;
    if (current_user.location == "Truck") {
        clock_no = 2;
    } else if (current_user.location == "Lab") {
        clock_no = 3;
    } else if (current_user.location == "Coffee") {
        clock_no = 4;
    } else if (current_user.location == "Plane") {
        clock_no = 5;
    } else if (current_user.location == "Work") {
        clock_no = 6;
    } else if (current_user.location == "Book") {
        clock_no = 7;
    } else if (current_user.location == "Dinner") {
        clock_no = 8;
    } else if (current_user.location == "Concert") {
        clock_no = 9;
    } else if (current_user.location == "Building") {
        clock_no = 10;
    } else if (current_user.location == "Bug") {
        clock_no = 11;
    } else if (current_user.location == "Drinks") {
        clock_no = 12;
    } else if (current_user.location == "Home") {
        clock_no = 1;
    }
    
    // turn off old LED location
    for(int i = user_no; i<NUMPIXELS; i = i + 4){
        pixels.setPixelColor(i, pixels.Color(0,0,0)); 
        pixels.show(); 
    }
    
    // write the new value
    // TO DO Figure out color
    int pixelLocation = 4*(clock_no-1) + (user_no);
    pixels.setPixelColor(pixelLocation, pixels.Color(red*neopixelBrightness,green*neopixelBrightness,blue*neopixelBrightness));
    pixels.show();
   
    
}
