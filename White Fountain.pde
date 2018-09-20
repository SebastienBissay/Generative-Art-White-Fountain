//Parameters :
int n = 700;
float startingRadius = 5.;
float force = 0.5;

class Point {
  PVector position, speed;
  float force;
  Point[] neighbours;

  Point(float x, float y, float vx, float vy, float f)
  {
    position = new PVector(x, y);
    speed = new PVector(vx, vy);
    force = f;
    neighbours = new Point[2];
  }

  void applyForce()
  {
    PVector acceleration = new PVector(0, 0);
    for (Point neighbour : neighbours)
    {
      acceleration.add((PVector.sub(neighbour.position, position).setMag(neighbour.force).div(position.dist(neighbour.position) + 1)));
    }

    speed.mult(0.9).add(acceleration);
    position.add(PVector.mult(speed, 0.1));
  }
  
  void drawLine()
  {
    Point p = neighbours[1];
    line(position.x, position.y, p.position.x, p.position.y);
  }
}

Point[] points = new Point[n];

void setup()
{
  size(1200, 1200);
  blendMode(ADD);
  background(10, 10, 20);
  noFill();
  stroke(255, 255, 255, 2.5);
  
  //Create points :
  float angle  = 0;
  float offset = 0;
  for (int i = 0; i < n; i++)
  {
    points[i] = new Point(startingRadius * cos(angle), startingRadius * sin(angle), 0, 0, force);
    if (i > 0)
    {
      points[i].neighbours[0] = points[i - 1];
      points[i - 1].neighbours[1] = points[i];
    }
    angle += TWO_PI / (n + offset);
    offset += 0.5;
  }
  points[0].neighbours[0] = points[n - 1];
  points[n - 1].neighbours[1] = points[0];
}

void draw()
{
  translate(width / 2, height / 2);
  for (Point p : points)
  {
    p.applyForce();
  }

  for (Point p : points)
  {
    p.drawLine();
    
    //Stop condition : something gets offscreen
    if ((abs(p.position.x) > width / 2) || (abs(p.position.y) > height / 2))
    {
      saveFrame();
      noLoop();
    }
  }
}
