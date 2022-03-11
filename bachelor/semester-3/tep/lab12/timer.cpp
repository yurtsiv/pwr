#include "timer.h"

Timer::Timer()
{

}

void Timer::start()
{
    endTime = startTime = std::chrono::high_resolution_clock::now();
}

void Timer::stop()
{
    endTime = std::chrono::high_resolution_clock::now();
}

double Timer::getSecondsElapsed()
{
    std::chrono::duration<double> diff = endTime - startTime;
    return diff.count();
}
