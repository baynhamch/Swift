# Timer

A timer that fires after a certain time interval has elapsed, sending a specified message to a target object.  

**iOS 2.0+** | **iPadOS 2.0+** | **Mac Catalyst 13.0+** | **macOS 10.0+** |**tvOS 9.0+** | **visionOS 1.0+** | **watchOS 2.0+**  

```swift
class Timer : NSObject
```

## Overview

Timers work in conjunction with run loops. Run loops maintain strong references to their timers, so you don’t have to maintain your own strong reference to a timer after you have added it to a run loop.  

To use a timer effectively, you should be aware of how run loops operate. See *Threading Programming Guide* for more information.

A timer is not a real-time mechanism. If a timer’s firing time occurs during a long run loop callout or while the run loop is in a mode that isn't monitoring the timer, the timer doesn't fire until the next time the run loop checks the timer. Therefore, the actual time at which a timer fires can be significantly later. See also *Timer Tolerance*.

`Timer` is toll-free bridged with its Core Foundation counterpart, `CFRunLoopTimer`. See *Toll-Free Bridging* for more information.

## Comparing Repeating and Nonrepeating Timers

You specify whether a timer is repeating or nonrepeating at creation time. A nonrepeating timer fires once and then invalidates itself automatically, thereby preventing the timer from firing again.  

By contrast, a repeating timer fires and then reschedules itself on the same run loop. A repeating timer always schedules itself based on the scheduled firing time, as opposed to the actual firing time. If the firing time is delayed so far that it passes one or more of the scheduled firing times, the timer is fired only once for that time period; the timer is then rescheduled, after firing, for the next scheduled firing time in the future.

## Timer Tolerance

In iOS 7 and later and macOS 10.9 and later, you can specify a tolerance for a timer (`tolerance`). This flexibility in when a timer fires improves the system's ability to optimize for increased power savings and responsiveness. The timer may fire at any time between its scheduled fire date and the scheduled fire date plus the tolerance. The timer doesn't fire before the scheduled fire date.

For repeating timers, the next fire date is calculated from the original fire date regardless of tolerance applied at individual fire times, to avoid drift. The default value is zero, meaning no additional tolerance is applied.

A general rule: set the tolerance to at least **10% of the interval** for a repeating timer. Even a small amount of tolerance has a significant positive impact on power usage. The system may enforce a maximum value for the tolerance.

## Scheduling Timers in Run Loops

You can register a timer in only one run loop at a time, although it can be added to multiple run loop modes within that run loop. There are three ways to create a timer:

1. Use `scheduledTimer(timeInterval:invocation:repeats:)` or `scheduledTimer(timeInterval:target:selector:userInfo:repeats:)` to create the timer and schedule it on the current run loop.
2. Use `init(timeInterval:invocation:repeats:)` or `init(timeInterval:target:selector:userInfo:repeats:)` to create a timer without scheduling it. You must manually add it to a run loop.
3. Use `init(fireAt:interval:target:selector:userInfo:repeats:)` to create a timer and manually add it to a run loop.

Once scheduled, the timer fires at the specified interval until invalidated. A nonrepeating timer invalidates itself after firing. A repeating timer must be manually invalidated using `invalidate()`. Once invalidated, a timer **cannot be reused**.

## Subclassing Notes

Do not subclass `Timer`.

## Topics

### Creating a Timer

```swift
class func scheduledTimer(withTimeInterval: TimeInterval, repeats: Bool, block: (Timer) -> Void) -> Timer
```
Creates a timer and schedules it on the current run loop in the default mode.

```swift
class func scheduledTimer(timeInterval: TimeInterval, target: Any, selector: Selector, userInfo: Any?, repeats: Bool) -> Timer
```
Creates a timer and schedules it on the current run loop.

```swift
init(timeInterval: TimeInterval, repeats: Bool, block: (Timer) -> Void)
```
Initializes a timer object with the specified time interval and block.

### Firing a Timer

```swift
func fire()
```
Causes the timer's message to be sent to its target.

### Stopping a Timer

```swift
func invalidate()
```
Stops the timer from ever firing again and requests its removal from its run loop.

### Retrieving Timer Information

```swift
var isValid: Bool
```
A Boolean value that indicates whether the timer is currently valid.

```swift
var fireDate: Date
```
The date at which the timer will fire.

```swift
var timeInterval: TimeInterval
```
The timer’s time interval, in seconds.

```swift
var userInfo: Any?
```
The receiver's `userInfo` object.

### Configuring Firing Tolerance

```swift
var tolerance: TimeInterval
```
The amount of time after the scheduled fire date that the timer may fire.

### Firing Messages as a Combine Publisher

```swift
static func publish(every: TimeInterval, tolerance: TimeInterval?, on: RunLoop, in: RunLoop.Mode, options: RunLoop.SchedulerOptions?) -> Timer.TimerPublisher
```
Returns a publisher that repeatedly emits the current date on the given interval.

## Relationships

### Inherits From

- `NSObject`
"""

# Save the markdown content to a file
file_path = "/mnt/data/Timer.md"
with open(file_path, "w") as file:
    file.write(markdown_content)

# Provide the file to the user
file_path
