/** Developed by Katerina Skroumpelou
 github.com/mandarini
 
 It uses the oscP5 library, website at http://www.sojamo.de/oscP5
 
 Some comments from the oscP5broadcastClient example by andreas schlegel
 are left intact, because they explain the usage of oscP5 and OSC messages.
 
 It also uses the Ketai Library for Android in Processing, website at http://ketai.org/
/**
 This is the processing sketch that should be ran in android mode
 an create an application (.apk) and install it on your phone.
 Once it is installed on your phone, you can use it anytime (obviously).
 
 This application reads a number of sensors from your phone and sends
 them over to the "ObservedItem" application that runs on your computer.
 It gives you the ability to change the size, angle and rotation of a box
 on your screen, so that you can observe it from every possible angle.
 
 Before you run the two applications, you should enter
 your computer's IP to the Android app running
 on your phone.
 
 Your computer's private IP address will show up in the console
 once you run the "ObservedItem" application. It will say something like:
 you (xxx.xxx.xxx.xxx)
 This is you.
 
 Another way to find your private IP address in Windows is 
 by running the ipconfig command in a Command Prompt window. 
 You’ll see your IP address in the IPv4 Address row beneath the name of your connection.
  
 */


import oscP5.*;
import netP5.*;

import android.view.MotionEvent;
import ketai.ui.*;
import ketai.sensors.*;

KetaiSensor sensor;
PVector gyroscope, accelerometer;
float light, proximity, rotX, rotY, rotZ, doubleX, doubleY, tapX, tapY, longX, longY, flickX, flickY, flickEX, flickEY, flickV;
float Size = 10;
float Angle = 0;


KetaiGesture gesture;

boolean check=false;

OscP5 oscP5;
NetAddress myRemoteLocation;

String pcIP="";

void setup() {

  sensor = new KetaiSensor(this);
  gesture = new KetaiGesture(this);
  sensor.start();
  sensor.list();
  accelerometer = new PVector();
  gyroscope = new PVector();
  orientation(LANDSCAPE);
  textSize(32);
  textAlign(CENTER);
  frameRate(25);

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. 
   
   Here goes the IP address of your computer. Leave the port as is.
   */
  myRemoteLocation = new NetAddress("null", 32000);
  
  KetaiAlertDialog.popup(this, "No IP", "Please enter the IP of the target PC");

 }


void draw() {
  background(0);  

  if (check==false)
  {
    text("Type IP", width/5, height/5);   
    text(pcIP, width/5, height/5+50);
  } 
  else
  { 

    //just for checking that everything works
    text("Accelerometer :" + "\n" 
      + "x: " + nfp(accelerometer.x, 1, 2) + "\n" 
      + "y: " + nfp(accelerometer.y, 1, 2) + "\n" 
      + "z: " + nfp(accelerometer.z, 1, 2) + "\n"
      + "Gyroscope :" + "\n" 
      + "x: " + nfp(gyroscope.x, 1, 2) + "\n"
      + "y: " + nfp(gyroscope.y, 1, 2) + "\n" 
      + "z: " + nfp(gyroscope.z, 1, 2) + "\n"
      + "Light Sensor : " + light + "\n" 
      + "Proximity Sensor : " + proximity + "\n"
      + "Rotation : "
      + "x: " + nfp(rotX, 1, 2) + " " 
      + "y: " + nfp(rotY, 1, 2) + " " 
      + "z: " + nfp(rotZ, 1, 2) + " "
      , 20, 0, width, height);

    //here we load the osc message with the readings that we want
    OscMessage myOtherMessage = new OscMessage("/sensors");
    myOtherMessage.add(light);
    myOtherMessage.add(rotX);
    myOtherMessage.add(rotY);
    myOtherMessage.add(rotZ);
    myOtherMessage.add(accelerometer.x);
    myOtherMessage.add(accelerometer.y);
    myOtherMessage.add(accelerometer.z);
    myOtherMessage.add(gyroscope.x);
    myOtherMessage.add(gyroscope.y);
    myOtherMessage.add(gyroscope.z);
    myOtherMessage.add(proximity);
    myOtherMessage.add(Size);
    myOtherMessage.add(Angle);

    //here we send our message to our computer (we defined the address in the setup)
    oscP5.send(myOtherMessage, myRemoteLocation);
    
    println(myOtherMessage.get(0).floatValue(), myRemoteLocation);
  }
}

//these are needed for the sensor and gesture events to be updated
void mousePressed() {
 
  if (check==false){
  KetaiKeyboard.toggle(this);
  }
}

void mouseDragged()
{
}

void keyPressed()
{
  pcIP+=key;
  if (key==RETURN || key==ENTER)
  {
    myRemoteLocation = new NetAddress(pcIP, 32000);
    println(pcIP);
    check=true;
  }
}

public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}