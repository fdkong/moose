/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#ifndef SOLUTIONNORM_H
#define SOLUTIONNORM_H

#include "GeneralPostprocessor.h"

// Forward Declarations
class SolutionNorm;


template <>
InputParameters validParams<SolutionNorm>();

class SolutionNorm : public GeneralPostprocessor
{
public:
  SolutionNorm(const InputParameters & parameters);

  virtual void initialize() override {}
  virtual void execute() override {}
  virtual Real getValue() override;
};

#endif // SOLUTIONNORM_H
