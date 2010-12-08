#ifndef PLENUMPRESSUREBC_H
#define PLENUMPRESSUREBC_H

#include "BoundaryCondition.h"

//Forward Declarations
class PlenumPressureBC;

template<>
InputParameters validParams<PlenumPressureBC>();

class PlenumPressureBC : public BoundaryCondition
{
public:

  PlenumPressureBC(const std::string & name, MooseSystem & moose_system, InputParameters parameters);

  virtual ~PlenumPressureBC(){}

protected:

  virtual Real computeQpResidual();
  virtual void setup();

  bool _initialized;

  Real _n0; // The initial number of moles of gas.

  const int _component;

  const Real _initial_pressure;

  const Real & _material_input;

  const Real _R;

  const Real & _temperature;

  const Real & _volume;

};

#endif //PLENUMRESSUREBC_H
