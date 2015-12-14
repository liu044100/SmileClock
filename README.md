# SmileClock

[![GitHub Issues](http://img.shields.io/github/issues/liu044100/SmileClock.svg?style=flat)](https://github.com/liu044100/SmileClock/issues)
[![Version](https://img.shields.io/cocoapods/v/SmileClock.svg?style=flat)](http://cocoadocs.org/docsets/SmileClock)
[![License](https://img.shields.io/cocoapods/l/SmileClock.svg?style=flat)](http://cocoadocs.org/docsets/SmileClock)
[![Platform](https://img.shields.io/cocoapods/p/SmileClock.svg?style=flat)](http://cocoadocs.org/docsets/SmileClock)

A library for make Clock UI simple.

<img src="SmileClock-Example/demo_gif/pro_banner.jpg" width="600">

#What can it do for you?


#### 1. Live rendering in Storyboard.

**Step1.** Drag a view in storyboard, and set the class to `SmileClockContainerView.h`.
<img src="SmileClock-Example/demo_gif/demo_1.png" width="500">

**Step2.** Click the attributes inspector, and set the color & clock style you prefer.
<img src="SmileClock-Example/demo_gif/demo.gif" width="500">

#### 2. Support customize Clock UI.
Slice your clock design source to five parts: background image, center circle image, hour hand image, minute hand image, second hand image.

<img src="SmileClock-Example/demo_gif/demo_2.jpg" width="500">
``` swift
let clockContainerView: SmileClockContainerView = ...
clockContainerView.bgImage = UIImage(named: "bg")
clockContainerView.centerImage = UIImage(named: "center")
clockContainerView.hourHandImage = UIImage(named: "hour_hand")
clockContainerView.minHandImage = UIImage(named: "min_hand")
clockContainerView.secHandImage = UIImage(named: "sec_hand")
``` 
<img src="SmileClock-Example/demo_gif/demo_3.jpg" width="500">
#### 3. Data model easy to use.
<img src="SmileClock-Example/demo_gif/demo_4.jpg" width="700">

# Contributions

* Warmly welcome to submit a pull request.

# Contact

* If you have some advice or find some issue, please contact me.
* Email [me](liu044100@gmail.com)


# License

SmileClock is available under the MIT license. See the LICENSE file for more info.
