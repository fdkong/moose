//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

// MOOSE includes
#include "ConsoleUtils.h"

#include "AuxiliarySystem.h"
#include "Conversion.h"
#include "Executioner.h"
#include "FEProblem.h"
#include "MooseApp.h"
#include "MooseMesh.h"
#include "NonlinearSystem.h"
#include "OutputWarehouse.h"
#include "SystemInfo.h"

#include "libmesh/string_to_enum.h"

namespace ConsoleUtils
{

std::string
indent(unsigned int spaces)
{
  return std::string(spaces, ' ');
}

std::string
outputFrameworkInformation(MooseApp & app)
{
  std::stringstream oss;
  oss << std::left;

  if (app.getSystemInfo() != NULL)
    oss << app.getSystemInfo()->getInfo();

  oss << std::left << "Parallelism:\n"
      << std::setw(console_field_width)
      << "  Num Processors: " << static_cast<std::size_t>(app.n_processors()) << '\n'
      << std::setw(console_field_width)
      << "  Num Threads: " << static_cast<std::size_t>(libMesh::n_threads()) << '\n'
      << '\n';

  return oss.str();
}

std::string
outputMeshInformation(FEProblemBase & problem, bool verbose)
{
  std::stringstream oss;
  oss << std::left;
  dof_id_type min_local_nodes, max_local_nodes, min_local_elements, max_local_elements;
  Real node_ratio, element_ratio;


  MooseMesh & moose_mesh = problem.mesh();
  MeshBase & mesh = moose_mesh.getMesh();

  max_local_nodes = mesh.n_local_nodes();
  mesh.comm().max(max_local_nodes);

  min_local_nodes = mesh.n_local_nodes();
  mesh.comm().min(min_local_nodes);

  min_local_elements = mesh.n_active_local_elem();
  mesh.comm().min(min_local_elements);

  max_local_elements = mesh.n_active_local_elem();
  mesh.comm().max(max_local_elements);

  node_ratio = (Real)max_local_nodes/min_local_nodes;

  element_ratio = (Real)max_local_elements/min_local_elements;

  if (verbose)
  {
    oss << "Mesh: " << '\n'
        << std::setw(console_field_width)
        << "  Parallel Type: " << (moose_mesh.isDistributedMesh() ? "distributed" : "replicated")
        << (moose_mesh.isParallelTypeForced() ? " (forced) " : "") << '\n'
        << std::setw(console_field_width) << "  Mesh Dimension: " << mesh.mesh_dimension() << '\n'
        << std::setw(console_field_width) << "  Spatial Dimension: " << mesh.spatial_dimension()
        << '\n';
  }

  oss << std::setw(console_field_width) << "  Nodes:" << '\n'
      << std::setw(console_field_width) << "    Total:" << mesh.n_nodes() << '\n'
      << std::setw(console_field_width) << "    Local:" << mesh.n_local_nodes() << '\n'
      << std::setw(console_field_width) << "    Local Min:" << min_local_nodes << '\n'
      << std::setw(console_field_width) << "    Local Max:" << max_local_nodes << '\n'
      << std::setw(console_field_width) << "    Node Ratio:" << node_ratio << '\n'
      << std::setw(console_field_width) << "  Elems:" << '\n'
      << std::setw(console_field_width) << "    Total:" << mesh.n_active_elem() << '\n'
      << std::setw(console_field_width) << "    Local:" << mesh.n_active_local_elem() << '\n'
      << std::setw(console_field_width) << "    Local Min:" << min_local_elements << '\n'
      << std::setw(console_field_width) << "    Local Max:" << max_local_elements << '\n'
      << std::setw(console_field_width) << "    Element Ratio:" << element_ratio << '\n';

  if (verbose)
  {

    oss << std::setw(console_field_width)
        << "  Num Subdomains: " << static_cast<std::size_t>(mesh.n_subdomains()) << '\n'
        << std::setw(console_field_width)
        << "  Num Partitions: " << static_cast<std::size_t>(mesh.n_partitions()) << '\n';
    if (problem.n_processors() > 1)
      oss << std::setw(console_field_width) << "  Partitioner: " << moose_mesh.partitionerName()
          << (moose_mesh.isPartitionerForced() ? " (forced) " : "") << '\n';
  }

  oss << '\n';

  return oss.str();
}

std::string
outputAuxiliarySystemInformation(FEProblemBase & problem)
{
  return outputSystemInformationHelper(problem.getAuxiliarySystem().system());
}

std::string
outputNonlinearSystemInformation(FEProblemBase & problem)
{
  return outputSystemInformationHelper(problem.getNonlinearSystemBase().system());
}

std::string
outputSystemInformationHelper(const System & system)
{
  std::stringstream oss;
  oss << std::left;
  dof_id_type min_local_dofs, max_local_dofs;
  Real dof_ratio;
  min_local_dofs = system.n_local_dofs();
  max_local_dofs = system.n_local_dofs();

  system.comm().min(min_local_dofs);

  system.comm().max(max_local_dofs);

  dof_ratio = (Real)max_local_dofs/min_local_dofs;

  if (system.n_dofs())
  {
    oss << std::setw(console_field_width) << "  Num DOFs: " << system.n_dofs() << '\n'
        << std::setw(console_field_width) << "  Num Local DOFs: " << system.n_local_dofs() << '\n'
        << std::setw(console_field_width) << "  Local DOFs Min: " << min_local_dofs << '\n'
        << std::setw(console_field_width) << "  Local DOFs Max: " << max_local_dofs << '\n'
        << std::setw(console_field_width) << "  DOF Ratio: " << dof_ratio << '\n';


    std::streampos begin_string_pos = oss.tellp();
    std::streampos curr_string_pos = begin_string_pos;
    oss << std::setw(console_field_width) << "  Variables: ";
    for (unsigned int vg = 0; vg < system.n_variable_groups(); vg++)
    {
      const VariableGroup & vg_description(system.variable_group(vg));

      if (vg_description.n_variables() > 1)
        oss << "{ ";
      for (unsigned int vn = 0; vn < vg_description.n_variables(); vn++)
      {
        oss << "\"" << vg_description.name(vn) << "\" ";
        curr_string_pos = oss.tellp();
        insertNewline(oss, begin_string_pos, curr_string_pos);
      }

      if (vg_description.n_variables() > 1)
        oss << "} ";
    }
    oss << '\n';

    begin_string_pos = oss.tellp();
    curr_string_pos = begin_string_pos;
    oss << std::setw(console_field_width) << "  Finite Element Types: ";
#ifndef LIBMESH_ENABLE_INFINITE_ELEMENTS
    for (unsigned int vg = 0; vg < system.n_variable_groups(); vg++)
    {
      oss << "\"" << libMesh::Utility::enum_to_string<FEFamily>(
                         system.get_dof_map().variable_group(vg).type().family)
          << "\" ";
      curr_string_pos = oss.tellp();
      insertNewline(oss, begin_string_pos, curr_string_pos);
    }
    oss << '\n';
#else
    for (unsigned int vg = 0; vg < system.n_variable_groups(); vg++)
    {
      oss << "\"" << libMesh::Utility::enum_to_string<FEFamily>(
                         system.get_dof_map().variable_group(vg).type().family)
          << "\", \"" << libMesh::Utility::enum_to_string<FEFamily>(
                             system.get_dof_map().variable_group(vg).type().radial_family)
          << "\" ";
      curr_string_pos = oss.tellp();
      insertNewline(oss, begin_string_pos, curr_string_pos);
    }
    oss << '\n';

    begin_string_pos = oss.tellp();
    curr_string_pos = begin_string_pos;
    oss << std::setw(console_field_width) << "  Infinite Element Mapping: ";
    for (unsigned int vg = 0; vg < system.n_variable_groups(); vg++)
    {
      oss << "\"" << libMesh::Utility::enum_to_string<InfMapType>(
                         system.get_dof_map().variable_group(vg).type().inf_map)
          << "\" ";
      curr_string_pos = oss.tellp();
      insertNewline(oss, begin_string_pos, curr_string_pos);
    }
    oss << '\n';
#endif

    begin_string_pos = oss.tellp();
    curr_string_pos = begin_string_pos;
    oss << std::setw(console_field_width) << "  Approximation Orders: ";
    for (unsigned int vg = 0; vg < system.n_variable_groups(); vg++)
    {
#ifndef LIBMESH_ENABLE_INFINITE_ELEMENTS
      oss << "\""
          << Utility::enum_to_string<Order>(system.get_dof_map().variable_group(vg).type().order)
          << "\" ";
#else
      oss << "\""
          << Utility::enum_to_string<Order>(system.get_dof_map().variable_group(vg).type().order)
          << "\", \"" << Utility::enum_to_string<Order>(
                             system.get_dof_map().variable_group(vg).type().radial_order)
          << "\" ";
#endif
      curr_string_pos = oss.tellp();
      insertNewline(oss, begin_string_pos, curr_string_pos);
    }
    oss << "\n\n";
  }

  return oss.str();
}

std::string
outputRelationshipManagerInformation(MooseApp & app)
{
  std::stringstream oss;
  oss << std::left;

  auto info_strings = app.getRelationshipManagerInfo();
  if (info_strings.size())
  {
    for (const auto & info_pair : info_strings)
      oss << std::setw(console_field_width) << std::string("  ") + info_pair.first << ": "
          << info_pair.second << '\n';
    oss << '\n';
  }

  return oss.str();
}

std::string
outputExecutionInformation(MooseApp & app, FEProblemBase & problem)
{

  std::stringstream oss;
  oss << std::left;

  Executioner * exec = app.getExecutioner();

  oss << "Execution Information:\n"
      << std::setw(console_field_width) << "  Executioner: " << demangle(typeid(*exec).name())
      << '\n';

  std::string time_stepper = exec->getTimeStepperName();
  if (time_stepper != "")
    oss << std::setw(console_field_width) << "  TimeStepper: " << time_stepper << '\n';

  oss << std::setw(console_field_width)
      << "  Solver Mode: " << Moose::stringify(problem.solverParams()._type) << '\n';

  const std::string & pc_desc = problem.getPetscOptions().pc_description;
  if (!pc_desc.empty())
    oss << std::setw(console_field_width) << "  Preconditioner: " << pc_desc << '\n';
  oss << '\n';

  return oss.str();
}

std::string
outputOutputInformation(MooseApp & app)
{
  std::stringstream oss;
  oss << std::left;

  const std::vector<Output *> outputs = app.getOutputWarehouse().getOutputs<Output>();
  oss << "Outputs:\n";
  for (const auto & out : outputs)
  {
    // Display the "execute_on" settings
    const MultiMooseEnum & execute_on = out->executeOn();
    oss << "  " << std::setw(console_field_width - 2) << out->name() << "\"" << execute_on
        << "\"\n";

    // Display the advanced "execute_on" settings, only if they are different from "execute_on"
    if (out->isAdvanced())
    {
      const OutputOnWarehouse & adv_on = out->advancedExecuteOn();
      for (const auto & adv_it : adv_on)
        if (execute_on != adv_it.second)
          oss << "    " << std::setw(console_field_width - 4) << adv_it.first + ":"
              << "\"" << adv_it.second << "\"\n";
    }
  }

  return oss.str();
}

void
insertNewline(std::stringstream & oss, std::streampos & begin, std::streampos & curr)
{
  if (curr - begin > console_line_length)
  {
    oss << "\n";
    begin = oss.tellp();
    oss << std::setw(console_field_width + 2) << ""; // "{ "
  }
}

} // ConsoleUtils namespace
