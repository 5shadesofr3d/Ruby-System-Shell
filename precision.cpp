#include "precision.hpp"

using Clock = std::chrono::high_resolution_clock;
using nanoseconds = std::chrono::nanoseconds;

void timer(const std::uint64_t delay, void (*callback)() = nullptr)
{
	auto final_time = Clock::now() + nanoseconds{delay};
	
	while (Clock::now() < final_time)
		;

	if (callback)
		callback();
}

// void print_time()
// {
// 	std::cout << "10 seconds elapsed" << std::endl;
// }

// int main()
// {
// 	std::uint64_t d = 1 * 1000000000ul;
// 	timer(d, &print_time); // 10 sec delay
// 	return 0;
// }
