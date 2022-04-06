#ifndef KalmanFilter_H
#define KalmanFilter_H

class KalmanFilter{

    public:

        float A[2][2];
        float B[2];
        float C[2];
        float xn_prev[2];
        float K[2];

        KalmanFilter(float new_A[2][2], float new_B[2], float new_C[2], float init_xn_prev[2], float new_K[2]);

        float Update(float un, float yn);

};


#endif