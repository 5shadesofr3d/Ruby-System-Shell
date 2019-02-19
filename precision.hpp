#include <iostream>
#include <chrono>

void timer(std::uint64_t delay_s, void (*callback)());

void timer_ms(std::uint64_t delay_ms, void (*callback)());

void timer_us(std::uint64_t delay_us, void (*callback)());

void timer_ns(std::uint64_t delay_ns, void (*callback)());