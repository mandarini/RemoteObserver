//Here are the gesture events

void onDoubleTap(float x, float y)
{
  doubleX= x;
  doubleY= y;
}

void onTap(float x, float y)
{
  tapX = x;
  tapY= y;
}

void onLongPress(float x, float y)
{
  longX= x;
  longY=y;
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
void onFlick( float x, float y, float px, float py, float v)
{
  flickX=x;
  flickY=y;
  flickEX=px;
  flickEY=py;
  flickV=v;
}

void onPinch(float x, float y, float d)
{
  Size = constrain(Size+d, 10, 2000);
}

void onRotate(float x, float y, float ang)
{
  Angle += ang;
}