#include "ButterworthFilter.h"


Butter::Butter(double new_b[], double new_a[]) {

  for (int i = 0; i < 3; i++){
    b[i] = new_b[i];
    a[i] = new_a[i];
  }

}

double Butter::Update(double new_u){

    shift(u, new_u, 3);

    double yfilt = 0;

    for(int i = 0; i < 3; i++)
      yfilt = yfilt + b[i]*u[i];
    for(int i = 1; i < 3; i++)
      yfilt = yfilt - a[i]*y[i-1];

    yfilt = yfilt/a[0];        

    shift(y, yfilt, 2);

    return yfilt;

}

void Butter::shift(double *vec, double new_val, int size){

  double aux, aux2;

  aux = vec[0];

  for(int i = 0; i < size - 1; i++){

    aux2 = vec[i+1];
    vec[i + 1] = aux;
    aux = aux2;

  }

  vec[0] = new_val;

}


