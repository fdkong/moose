// This file is part of the MOOSE framework
// https://www.mooseframework.org
//
// All rights reserved, see COPYRIGHT for full restrictions
// https://github.com/idaholab/moose/blob/master/COPYRIGHT
//
// Licensed under LGPL 2.1, please see LICENSE for details
// https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef FUNCTIONALBASISINTERFACE_H
#define FUNCTIONALBASISINTERFACE_H

// MOOSE includes
#include "MooseEnum.h"
#include "MooseError.h"
#include "MooseTypes.h"

// Shortened typename
class FunctionalBasisInterface;
typedef FunctionalBasisInterface FBI;

// Passkey for ...SeriesBasisInterface
class SBIKey
{
  friend class SingleSeriesBasisInterface;
  friend class CompositeSeriesBasisInterface;
  SBIKey(){};               // Empty private constructor
  SBIKey(SBIKey const &){}; // Empty copy constructor
};

/// This class provides the basis for any custom functional basis
class FunctionalBasisInterface
{
public:
  FunctionalBasisInterface();

  FunctionalBasisInterface(const unsigned int number_of_terms);

  /// Returns the current evaluation at the given index
  Real operator[](std::size_t index) const;

  /// Returns an array reference containing the value of each orthonormalized term
  const std::vector<Real> & getAllOrthonormal();

  /// Returns an array reference containing the value of each standardized term
  const std::vector<Real> & getAllStandard();

  /// Returns the number of terms in the series
  std::size_t getNumberOfTerms() const;

  /// Gets the last term of the orthonormalized functional basis
  Real getOrthonormal();

  /// Gets the sum of all terms in the orthonormalized functional basis
  Real getOrthonormalSeriesSum();

  /// Gets the #_order-th term of the standardized functional basis
  Real getStandard();

  /// Evaluates the sum of all terms in the standardized functional basis up to #_order
  Real getStandardSeriesSum();

  /// Returns a vector of the lower and upper bounds of the standardized functional space
  virtual const std::vector<Real> & getStandardizedFunctionLimits() const = 0;

  /// Returns the volume within the standardized function local_limits
  virtual Real getStandardizedFunctionVolume() const = 0;

  /// Returns true if the current evaluation is orthonormalized
  bool isOrthonormal() const;

  /// Returns true if the current evaluation is standardized
  bool isStandard() const;

  /// Whether the cached values correspond to the current point
  virtual bool isCacheInvalid() const = 0;

  /// Determines if the point provided is in within the physical bounds
  virtual bool isInPhysicalBounds(const Point & point) const = 0;

  /// Set the location that will be used by the series to compute values
  virtual void setLocation(const Point & point) = 0;

  /// Set the order of the series
  virtual void setOrder(const std::vector<std::size_t> & orders) = 0;

  /// Sets the bounds of the series
  virtual void setPhysicalBounds(const std::vector<Real> & bounds) = 0;

  /// An enumeration of the domains available to each functional series
  static MooseEnum _domain_options;

protected:
  /*
   * This method should really be made private, since calling it innappropriately will wreak havoc.
   * Both SSBI and CSBI have valid use cases, so this method is provided here with a PassKey instead
   * that will cause future developers to consider if they are calling this method appropriately.
   */
  /// Set all entries of the basis evaluation to zero.
  virtual void clearBasisEvaluation(const unsigned int & number_of_terms, SBIKey);

  /// Evaluate the orthonormal form of the functional basis
  virtual void evaluateOrthonormal() = 0;

  /// Evaluate the standardized form of the functional basis
  virtual void evaluateStandard() = 0;

  /// Helper function to load a value from #_series
  Real load(std::size_t index) const;

  /// Helper function to store a value in #_series
  void save(std::size_t index, Real value);

  /// The number of terms in the series
  unsigned int _number_of_terms;

  /// indicates if the evaluated values correspond to the current location
  bool _is_cache_invalid;

private:
  /// Set all entries of the basis evaluation to zero.
  virtual void clearBasisEvaluation(const unsigned int & number_of_terms);

  /// Stores the values of the basis evaluation
  std::vector<Real> _basis_evaluation;

  /// Indicates whether the current evaluation is standardized or orthonormalized
  bool _is_orthonormal;
};

#endif // FUNCTIONALBASISINTERFACE_H
