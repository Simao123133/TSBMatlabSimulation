#ifndef Cascaded_H
#define Cascaded_H

class CascadedController
{
    public:
        CascadedController(float min_sat, float max_sat, float min_slew_rate, float max_slew_rate,
                                       float initial_state, float Kp_outer, float Kp_inner, float Ki_inner);

        float update();
        float sat(float ang, float upper_lim, float lower_lim);

        void reset();

        volatile float x = 0.0;
        volatile float dx = 0.0;
        volatile float speed = 0.0;
        volatile float ref = 0.0;
        bool flag_first_loop = true;

        float Kp_outer;
        float Kp_inner;
        float Ki_inner;

        float max_sat;
        float min_sat;
        float max_slew_rate;
        float min_slew_rate;
        float initial_state;

    private:

        //globals for the com_mode controller
        float u = 0.0;
        float LAST_TIME = 0.0;
        float dx_error_prev = 0.0;

};


#endif