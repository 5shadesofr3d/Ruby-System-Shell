#include <iostream>
#include <chrono>

using Clock = std::chrono::high_resolution_clock;
using nanoseconds = std::chrono::nanoseconds;

void timer(const std::uint64_t delay)
{
	auto final_time = Clock::now() + nanoseconds{delay};
	
	while (Clock::now() < final_time)
		;
}

int main()
{
	std::uint64_t d = 1 * 1000000000ul;
	timer(d); // 10 sec delay
	std::cout << "10 seconds elapsed" << std::endl;
	return 0;
}
