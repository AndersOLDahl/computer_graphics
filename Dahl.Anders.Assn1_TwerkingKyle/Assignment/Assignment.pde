import processing.sound.*;
SoundFile file;

float x;
float y;
float easing = .070;

PShape kyle;
PShape left_hat;
PShape right_hat;
PShape left_eyeball;
PShape right_eyeball;
PShape left_thumb;
PShape right_thumb;
PShape feet;
PShape sword;

PImage gust_img;

int w = 640;
int h = 480;

int startTime = 0;
int count = 0;
int body_count = 0;
int feet_count = 0;
int eyeball_count = 0;
int thumb_count = 0;

int[] gust = { 640, 480, 240, 560, 120, 280 };
int [] line_count = { 0 , 0 };

// The statements in the setup() function execute once
// the program begins
void setup()
{
  // Set the size of the screen
  size(640, 480);

  // Maxiumun anti-aliasing
  smooth(8);

  // Higher frame rate
  frameRate(128);

  // Stroke weight for lines
  strokeWeight(60);

  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "MortalKombatThunder.mp3");
  file.play();

  kyle = loadShape( "Kyle.svg" );
  sword = loadShape( "Sword.svg" );
  left_hat = kyle.getChild( "left_hat" );
  right_hat = kyle.getChild( "right_hat" );
  left_eyeball = kyle.getChild( "left_eyeball" );
  right_eyeball = kyle.getChild( "right_eyeball" );
  left_thumb = kyle.getChild( "left_thumb" );
  right_thumb = kyle.getChild( "right_thumb" );
  feet = kyle.getChild( "feet" );

  gust_img = loadImage("Gust.png");
}

// The statements in draw() are executed until the
// program is stopped. Each statement is executed in
// sequence and after the last line is read, the first
// line is executed again.
void draw()
{
  // Draw a black background
  background(224, 224, 224);
  wind();
  strobelight();
  easing();
  sword();
}

// Make the animated object chase the mouse
void easing()
{
  float targetX = mouseX;
  float dx = targetX - x;
  x += dx * easing;

  float targetY = mouseY;
  float dy = targetY - y;
  y += dy * easing;

  drawCharacter();
}

// Draw the character
void drawCharacter()
{
  shape( kyle, x + 80, y + 80);

  rotateShape( kyle, right_hat, "pivot_right_hat", .025 );
  rotateShape( kyle, left_hat, "pivot_left_hat", .020 );

  if (millis() > startTime + 100) {
    startTime = millis();

    if (count % 3 == 0) {
      if (body_count % 2 == 0) {
        kyle.translate(0, 20);
        kyle.scale(1.05);
      } else {
        kyle.translate(0, -20);
        kyle.scale(1 / 1.05);
      }
      body_count++;
    }

    if (count % 10 == 0) {
      if (feet_count % 4 == 0) {
        feet.translate(-10, 0);
        left_thumb.translate(-8, 0);
        right_thumb.translate(-8, 0);
      } else if (feet_count % 4 == 1) {
        feet.translate(10, 0);
        left_thumb.translate(8, 0);
        right_thumb.translate(8, 0);
      } else if (feet_count % 4 == 2) {
        feet.translate(10, 0);
        left_thumb.translate(8, 0);
        right_thumb.translate(8, 0);
      } else {
        feet.translate(-10, 0);
        left_thumb.translate(-8, 0);
        right_thumb.translate(-8, 0);
      }
      feet_count++;
    }

    if (count % 20 == 0) {
      if (eyeball_count % 2 == 0) {
        left_eyeball.translate(-8, -8);
        right_eyeball.translate(-8, -8);
      } else {
        left_eyeball.translate(8, 8);
        right_eyeball.translate(8, 8);
      }
      eyeball_count++;
    }

    count++;
  }
}

// Make an object rotate in circles around a pivot point
void rotateShape( PShape main_shape, PShape s, String pivot, float a ) {
  float[] p = main_shape.getChild(pivot).getParams();
  float px = p[0];
  float py = p[1];
  s.translate( px, py );
  s.rotate( a );
  s.translate( -px, -py );
}

// Wind in the background
void wind() {
  for (int i = 0; i < gust.length; i++) {
    if (gust[i] < 0) {
      gust[i] = w;
    }

    image(gust_img, gust[i], 20 + i * 80, width/10, height/10);
    gust[i]--;
  }
}

// Strobelight in the background
void strobelight() {
  line(line_count[0] % w, 0, w, h);
  line_count[0] += 4;
  stroke(line_count[0] % 255, line_count[0] % 255, 128);

  line(w - (line_count[1] % w), 0, 0, h);
  line_count[1] += 3;
  stroke(line_count[1] % 255, 128, line_count[1] % 255);
}

// Rotate the sword around the mouse
void sword() {
  shape( sword, x, y, sword.getWidth()/2, sword.getHeight()/2);
  sword.rotate( .025 );
}
