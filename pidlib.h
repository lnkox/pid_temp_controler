/*This file has been prepared for Doxygen automatic documentation generation.*/
/*! \file *********************************************************************
 *
 * \brief Header file for pid.c.
 *
 * - File:               pid.h
 * - Compiler:           IAR EWAAVR 4.11A
 * - Supported devices:  All AVR devices can be used.
 * - AppNote:            AVR221 - Discrete PID controller
 *
 * \author               Atmel Corporation: http://www.atmel.com \n
 *                       Support email: avr@atmel.com
 *
 * $Name$
 * $Revision: 456 $
 * $RCSfile$
 * $Date: 2006-02-16 12:46:13 +0100 (to, 16 feb 2006) $
 *****************************************************************************/




#define SCALING_FACTOR  128


/*! \brief PID Status
 *
 * Setpoints and data used by the PID control algorithm
 */
typedef struct PID_DATA{
  //! Last process value, used to find derivative of process value.
  signed int lastProcessValue;
  //! Summation of errors, used for integrate calculations
  signed long sumError;
  //! The Proportional tuning constant, multiplied with SCALING_FACTOR
  signed int P_Factor;
  //! The Integral tuning constant, multiplied with SCALING_FACTOR
  signed int I_Factor;
  //! The Derivative tuning constant, multiplied with SCALING_FACTOR
  signed int D_Factor;
  //! Maximum allowed error, avoid overflow
  signed int maxError;
  //! Maximum allowed sumerror, avoid overflow
  signed long maxSumError;
} pidData_t;

/*! \brief Maximum values
 *
 * Needed to avoid sign/overflow problems
 */
// Maximum value of variables
#define MAX_INT         32767
#define MAX_LONG        2147483647
#define MAX_I_TERM      1073741823

// Boolean values
#define FALSE           0
#define TRUE            1

#include "pidlib.c"

void pid_Init(signed int p_factor, signed int i_factor, signed int d_factor, struct PID_DATA *pid);
signed int pid_Controller(signed int setPoint, signed int processValue, struct PID_DATA *pid_st);
void pid_Reset_Integrator(pidData_t *pid_st);

