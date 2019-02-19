#include "precision.hpp"

using Clock = std::chrono::high_resolution_clock;
using nanoseconds = std::chrono::nanoseconds;

void timer(std::uint64_t delay_s, std::function<void()> callback)
{
	timer_ns(delay_s * static_cast<std::uint64_t>(1000000000), callback);
}

void timer_ms(std::uint64_t delay_ms, std::function<void()> callback)
{
	timer_ns(delay_ms * static_cast<std::uint64_t>(1000000), callback);
}

void timer_us(std::uint64_t delay_us, std::function<void()> callback)
{
	timer_ns(delay_us * static_cast<std::uint64_t>(1000), callback);
}

void timer_ns(std::uint64_t delay_ns, std::function<void()> callback)
{
	auto final_time = Clock::now() + nanoseconds{delay_ns};
	
	while (Clock::now() < final_time)
		;

	if (callback)
		callback();
}