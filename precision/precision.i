%module precision
%{
	#include "precision.hpp"
%}

%typemap(in) std::uint64_t
{
	$1 = (std::uint64_t) NUM2ULL($input);
}

%typemap(in) std::function<void()>
{
	$1 = [argv]() { rb_funcall($input, rb_intern("call"), 0); };
}

void timer(std::uint64_t delay_s, std::function<void()> callback);

void timer_ms(std::uint64_t delay_ms, std::function<void()> callback);

void timer_us(std::uint64_t delay_us, std::function<void()> callback);

void timer_ns(std::uint64_t delay_ns, std::function<void()> callback);