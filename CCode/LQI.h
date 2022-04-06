#ifndef LQI_H
#define LQI_H

#define INITIAL_AOA_HEAVE 1.6107
#define INITIAL_AOA_REAR 1.9060
#define MAX_FRONT_FOILANGLE 14
#define MIN_FRONT_FOILANGLE -3
#define MAX_REAR_FOILANGLE 10
#define MIN_REAR_FOILANGLE -3

class LQIController
{
    public:
        LQIController();

        float* full_mode(int mode);
        float sat(float ang, float upper_lim, float lower_lim);

        void reset();
        void reset_heave();

        float rads_to_degs(float rads);

        volatile float x[7] = {0.0};
        volatile float error[3] = {0.0};
        bool flag_first_loop;

        float K[3][10] = {{1.7269,   -1.1952,    0.1266,    1.5020,  -21.1311,    0.2561,    1.1349,  -12.9685,    0.6011,    0.4986},
                         {1.7270,   -1.1952,    0.1266,    1.5020,  -21.1322,   -0.2561,   -1.1348,  -12.9694,   -0.6010,   0.4986},
                         {1.2647,   -0.5375,   -0.0621,   -0.5843,   -7.6951,    0.0000,    0.0000,   -2.2299,    0.0000,   -1.1600}};

    private:

        //globals for the com_mode controller
        float ALFA[3];
        float LAST_TIME;
        float x_prev[7];

};




#endif
