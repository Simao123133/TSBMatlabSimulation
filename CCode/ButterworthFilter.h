#ifndef ButterworthFilter_H
#define ButterworthFilter_H

class Butter {    

  public:

    double b[3];
    double a[3];
    double y[2] = {0.0}; 
    double u[3] = {0.0};

    Butter(double new_b[], double new_a[]);

    double Update(double new_u);

    void shift(double *vec, double new_val, int size);

};

#endif