#include "Cascaded.h"
#include <iostream>
#include <iomanip>

CascadedController::CascadedController(float min_sat, float max_sat, float min_slew_rate, float max_slew_rate,
                                       float initial_state, float Kp_outer, float Kp_inner, float Ki_inner){

	this->u = initial_state; 
    this->initial_state = initial_state;
    this->min_sat = min_sat;
    this->max_sat = min_sat;
    this->min_slew_rate = min_slew_rate;
    this->max_slew_rate = max_slew_rate;
    this->Kp_outer = Kp_outer;
    this->Kp_inner = Kp_inner;
    this->Ki_inner = Ki_inner;

};

float CascadedController::update() {

    float x_error = ref - x;
    float u_outer = x_error*Kp_outer;
    float dx_error = u_outer - dx;
    float delta_t = 0.02;
    
    float dx_error_deriv = (dx_error - dx_error_prev)/delta_t;
    

    if(flag_first_loop){
        dx_error_deriv = 0.0;
        flag_first_loop = false;
    }

    dx_error_prev = dx_error;

    float dx_error_p = dx_error_deriv*Kp_inner;

    float u_dot = dx_error_p + dx_error*Ki_inner;

    //Gain scheduling
    if(speed > 7) 
		u_dot = u_dot*7*7/(speed*speed);

    u_dot = sat(u_dot, max_slew_rate, min_slew_rate);
    u = u + u_dot*delta_t; 
    u = sat(u, max_sat, min_sat);

	return u;

}

float CascadedController::sat(float ang, float upper_lim, float lower_lim){

    float saturation = ang;

    if (ang > upper_lim)
        saturation = upper_lim;
    else if (ang < lower_lim)
        saturation = lower_lim;

    return saturation;

}

void CascadedController::reset(){

    u = initial_state; 
    flag_first_loop = true;

}
        
