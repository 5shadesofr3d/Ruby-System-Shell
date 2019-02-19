%module precision
%{
	#include "precision.hpp"
%}

void timer(const std::uint64_t delay, void (*callback)());