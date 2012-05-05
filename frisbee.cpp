#include <fstream> 
#include <iostream> 
#include <math.h>
#include <string>
#include <cstdlib>
using namespace std;

class Action
{
public:
  double x0;
  double y0;
  double vx0;
  double vy0;
  double g;
  double rho;
  double vx,vy,x,y;
  double m,area;
  double CLO,CLA,CDO,CDA;
  double alphaO;
  double alpha;
  double cl,cd,pi;
  double dt;
  ofstream out;
  void print();
  void iterate();
  Action(); //constructor
  ~Action();//Destructor
};

int main(void)
{
  Action A;
  
  A.print();
  while(A.y > 0)
    {
      A.iterate();
      A.print();
    };
    
}


Action::Action(){

  ifstream inF;
  inF.open("param.dat");
  if(inF.is_open())
    {
      inF >> alpha;
      inF >> x0;
      inF >> vx0;
      inF >> y0;
      inF >> vy0;
      inF >> dt;
    }
  else
    {cout << "Missing Input File. Exiting..." << endl; exit(1);}

  //Calculate other params
  g = -9.81;//gravity in m/s
  rho = 1.23;//air density in kg/m^3
  area = 0.0568;//area of average frisbee
  CLO = 0.1; // Lift Coefficient, alpha=0
  CLA = 1.4; // Lift Coefficient at Alpha
  CDO = 0.08; //Drag Coeff at alpha=0
  CDA = 2.72; //Drag Coeff at alpha
  alphaO = -4.;//characterizes angular dependence of 
               //drag due to frisbee shape
  m = .175;//average frisbee mass in kg
  pi = 3.1415926;

  vx = vx0;
  x = x0;
  y = y0;
  vy = vy0;

  //lift coefficient
  cl = CLO + CLA*alpha*(pi/180);

  //drag coefficient
  cd = CDO + CDA*pow((alpha-alphaO)*(pi/180),2);

  out.open("data.dat");
}

Action::~Action(){
  out.close();
}

void Action::print(){  
  out << x << " " << y << " " << vx << " " << vy << endl;
}

void Action::iterate(){
  double deltavx, deltavy;
  
  deltavx = -(rho*pow(vx,2)*area*cd*dt);
  deltavy = (((rho*pow(vx,2)*area*cl)/(2*m))+g)*dt;

  vx = vx + deltavx;
  vy = vy + deltavy;
  x = x + vx*dt;
  y = y + vy*dt;
}
