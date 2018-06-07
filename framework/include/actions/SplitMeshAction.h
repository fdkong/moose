//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef SPLITMESHACTION_H
#define SPLITMESHACTION_H

#include "Action.h"
#include "libmesh/default_coupling.h"

#include <string>

class SplitMeshAction;

template <>
InputParameters validParams<SplitMeshAction>();

class SplitMeshAction : public Action
{
public:
  SplitMeshAction(InputParameters params);

  virtual void act() override;

private:
  std::unique_ptr<DefaultCoupling> _default_coupling;
};

#endif // SPLITMESHACTION_H
