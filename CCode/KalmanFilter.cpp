#include "KalmanFilter.h"

KalmanFilter::KalmanFilter(float new_A[2][2], float new_B[2], float new_C[2], float init_xn_prev[2], float new_K[2]){

    for(int i=0; i < 2; i++){
        B[i] = new_B[i];
        C[i] = new_C[i];
        xn_prev[i] = init_xn_prev[i];
        K[i] = new_K[i];
        for(int j=0; j < 2; j++)
            A[i][j] = new_A[i][j];
    }

}

float KalmanFilter::Update(float un, float yn){

    float xn[2];
    float xn_next[2];

    xn[0] = xn_prev[0] + K[0]*(yn - (C[0]*xn_prev[0] + C[1]*xn_prev[1]));
    xn[1] = xn_prev[1] + K[1]*(yn - (C[0]*xn_prev[0] + C[1]*xn_prev[1]));

    xn_next[0] = A[0][0]*xn[0] + A[0][1]*xn[1] + B[0]*un;  
    xn_next[1] = A[1][0]*xn[0] + A[1][1]*xn[1] + B[1]*un; 

    xn_prev[0] = xn_next[0];
    xn_prev[1] = xn_next[1];

    return xn_prev[0];

} 


/*
int main() {

    float A[2][2] = {{1.0, -0.02},{0.0, 1.0}};
    float B[2] = {0.02, 0.0};
    float C[2] = {1.0, 0.0};
    float K[2] = {0.0116, -0.0031};
    float init_states[2] = {-0.5072, 0.01};
    float yn[10] = {-0.5072, -0.5072, -0.5072, -0.5072, -0.5072, -0.5072, 
    -0.5061, -0.5061, -0.5061, -0.5061};
    float un[10] = {0.0313, 0.0469, 0.0313, 0.0469, 0.0469, 0.0469, 0.0625, 0.0625, 0.0625, 0.0625};
    float dPitchdt[10] = {-0.0326, -0.1679, -0.3918, -0.6101, -0.7900, -0.9381, -1.0185, -1.0174, -0.9905, -0.9514};
    float z[10];
    
    KalmanFilter KF = KalmanFilter(A, B, C, init_states, K);

    for(int i=0; i < 10; i++){
        z[i] = KF.Update(un[i] + dPitchdt[i]*(-3.14/180*3.125), yn[i]);
        std::cout << std::to_string(z[i]) << std::endl;
    }

}
*/