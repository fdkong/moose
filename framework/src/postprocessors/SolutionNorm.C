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

#include "SolutionNorm.h"
#include "FEProblemBase.h"
#include "NonlinearSystem.h"

#include "libmesh/system.h"

template <>
InputParameters
validParams<SolutionNorm>()
{
  InputParameters params = validParams<GeneralPostprocessor>();
  return params;
}

SolutionNorm::SolutionNorm(const InputParameters & parameters)
  : GeneralPostprocessor(parameters)
{
}

Real
SolutionNorm::getValue()
{
  //_fe_problem.getNonlinearSystemBase().currentSolution()->print_global();
  return _fe_problem.getNonlinearSystemBase().currentSolution()->l2_norm();
}
