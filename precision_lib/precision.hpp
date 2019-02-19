#include <iostream>
#include <functional>
#include <chrono>

void timer(std::uint64_t delay_s, std::function<void()> callback);

void timer_ms(std::uint64_t delay_ms, std::function<void()> callback);

void timer_us(std::uint64_t delay_us, std::function<void()> callback);

void timer_ns(std::uint64_t delay_ns, std::function<void()> callback);