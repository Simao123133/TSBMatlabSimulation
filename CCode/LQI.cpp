#include "LQI.h"

LQIController::LQIController(){

	//globals for the controller
	ALFA[0] = INITIAL_AOA_HEAVE; // initial condition of integrator
    ALFA[1] = INITIAL_AOA_HEAVE; // initial condition of integrator
    ALFA[2] = INITIAL_AOA_REAR; // initial condition of integrator
	LAST_TIME = 0.0;

	flag_first_loop = false;

}

float* LQIController::full_mode(int mode) {
    float states[10] = {0.0};
    float u_dot[3] = {0.0};

	float delta_t = 0.02;

    for(int i=0; i < 7; i++){
        if(flag_first_loop)
            states[i] = -(x[i] - x_prev[i])/delta_t;
        x_prev[i] = x[i];
    }

    states[7] = error[0];
    states[8] = error[1];
    states[9] = error[2];

    for(int i=0; i < 3; i++){

        u_dot[i] = 0;

        //Calculate input derivatives, mode == 1 means full mode
        if(mode == 1){
            for(int j=0; j < 10; j++)
                u_dot[i] = u_dot[i] + K[i][j]*states[j];
        }
        else
            u_dot[i] = u_dot[i] + K[i][5]*states[5] + K[i][6]*states[6] + K[i][8]*states[8];

        //Gain scheduling
        if(x[0] > 7) 
		    u_dot[i] = u_dot[i]*7*7/(x[0]*x[0]);

        //Slew rate, integration and max input saturation

        //std::cout << std::to_string(u_dot[i]) + ' ';

        if (i < 2){
            u_dot[i] = sat(u_dot[i], 10, -10);
            ALFA[i] = ALFA[i] + u_dot[i]*delta_t; 
            ALFA[i] = sat(ALFA[i], MAX_FRONT_FOILANGLE, MIN_FRONT_FOILANGLE);
        }
        else{
            u_dot[i] = sat(u_dot[i], 1, -1);
            ALFA[i] = ALFA[i] + u_dot[i]*delta_t; 
            ALFA[i] = sat(ALFA[i], MAX_REAR_FOILANGLE, MIN_REAR_FOILANGLE);
        }    

    }   

	return ALFA;

}

float LQIController::sat(float ang, float upper_lim, float lower_lim){

    float saturation = ang;

    if (ang > upper_lim)
        saturation = upper_lim;
    else if (ang < lower_lim)
        saturation = lower_lim;

    return saturation;

}

void LQIController::reset(){

    ALFA[0] = INITIAL_AOA_HEAVE; // initial condition of integrator
    ALFA[1] = INITIAL_AOA_HEAVE; // initial condition of integrator
    ALFA[2] = INITIAL_AOA_REAR; // initial condition of integrator
    flag_first_loop = false;

}
        
void LQIController::reset_heave(){

    float dif_angle = (ALFA[0] - ALFA[1])/(2.0);
    ALFA[0] = INITIAL_AOA_HEAVE + dif_angle;
    ALFA[1] = INITIAL_AOA_HEAVE - dif_angle;
    ALFA[2] = INITIAL_AOA_REAR;

}












