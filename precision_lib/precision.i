%module precision
%{
	#include "precision.hpp"
%}

%typemap(in) std::uint64_t
{
	$1 = (std::uint64_t) NUM2ULL($input);
}

void timer(std::uint64_t delay_s, void (*callback)());

void timer_ms(std::uint64_t delay_ms, void (*callback)());

void timer_us(std::uint64_t delay_us, void (*callback)());

void timer_ns(std::uint64_t delay_ns, void (*callback)());