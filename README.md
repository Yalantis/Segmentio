##Segmentio
[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://cocoapods.org/?q=segmentio) [![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/Yalantis/Segmentio/blob/master/LICENSE) ![Swift 2.2.x](https://img.shields.io/badge/Swift-2.2.x-orange.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Animated top/bottom segmented control written in Swift.

![Preview](https://github.com/Yalantis/Segmentio/blob/master/Assets/animation.gif)

Check this <a href="https://dribbble.com/shots/2820372-Segmentio-Component">project on dribbble</a>.

##Requirements

iOS 8.x, Swift 2.2.x

##Installation

####[CocoaPods](http://cocoapods.org)
```ruby
use_frameworks! 

pod 'Segmentio', '~> 1.0'
```

*(CocoaPods v1.0.1 or later required. See [this blog post](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/) for details.)*

####[Carthage](http://github.com/Carthage/Carthage)
```ruby
github "Yalantis/Segmentio" ~> 1.0
```

##Usage
####Import `Segmentio` module
```swift
import Segmentio
```

####Init
You can initialize a `Segmentio` instance from code:
```swift
var segmentioView: Segmentio!

let segmentioViewRect = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 125)
segmentioView = Segmentio(frame: segmentioViewRect)
view.addSubview(segmentioView)
```
or

add a `UIView` instance in your .storyboard or .xib, set `Segmentio` class and connect `IBOutlet`:
```swift
@IBOutlet weak var segmentioView: Segmentio!
```

####Setup `Segmentio`
```swift
segmentioView.setupContent(
	content: [SegmentioItem],
	style: SegmentioStyle,
	options: SegmentioOptions?
)
```

To start with default options you can just pass `nil` to the `options` parameter.

```swift
segmentioView.setupContent(
	content: [SegmentioItem],
	style: SegmentioStyle,
	options: nil
)
```


####Configuring items 
In order to set items you need to create an array of `SegmentioItem` instances:
```swift
var content = [SegmentioItem]()

let tornadoItem = SegmentioItem(
	title: "Tornado",
	image: UIImage(named: "tornado")
)
content.append(tornadoItem)
```

####Handling selection
You can specify selected item manually:
```swift
segmentioView.selectedSegmentIndex = 0
```

####Handling callback
```swift
segmentioView.valueDidChange = { segmentio, segmentIndex in
	print("Selected item: ", segmentIndex)
}
```

####Customization
`Segmentio` can be customized by passing an instance of `SegmentioOptions` struct:
```swift
SegmentioOptions(
	backgroundColor: UIColor.whiteColor(),
	maxVisibleItems: 3,
	scrollEnabled: true,
	indicatorOptions: SegmentioIndicatorOptions,
	horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions,
	verticalSeparatorOptions: SegmentioVerticalSeparatorOptions,
	imageContentMode: UIViewContentMode.Center,
	labelTextAlignment: NSTextAlignment.Center,
	segmentStates: SegmentioStates // tuple of SegmentioState (defaultState, selectState, highlightedState)
)
```

Selection indicator can be customized by passing an instance of `SegmentioIndicatorOptions`:
```swift
SegmentioIndicatorOptions(
	type: .Bottom,
	ratio: 1,
	height: 5,
	color: UIColor.orangeColor()
)
```

Horizontal borders can be customized by passing an instance of `SegmentioHorizontalSeparatorOptions`:
```swift
SegmentioHorizontalSeparatorOptions(
	type: SegmentioHorizontalSeparatorType.TopAndBottom, // Top, Bottom, TopAndBottom
	height: 1,
	color: UIColor.grayColor()
)
```

Separators between segments can be customized by passing an instance of  `SegmentioVerticalSeparatorOptions`:
```swift
SegmentioVerticalSeparatorOptions(
	ratio: 0.6 // from 0.1 to 1
	color: UIColor.grayColor()
)
```

In order to set `SegmentioStates` you need to create a tuple of `SegmentioState` instances:
```swift
SegmentioStates(
	defaultState: segmentioState(
		backgroundColor: UIColor.clearColor(),
		titleFont: UIFont.systemFontOfSize(UIFont.smallSystemFontSize()),
		titleTextColor: UIColor.blackColor()
	),
	selectState: segmentioState(
		backgroundColor: UIColor.orangeColor(),
		titleFont: UIFont.systemFontOfSize(UIFont.smallSystemFontSize()),
		titleTextColor: UIColor.whiteColor()
	),
	highlightedState: segmentioState(
		backgroundColor: UIColor.lightGrayColor().colorWithAlphaComponent(0.6),
		titleFont: UIFont.boldSystemFontOfSize(UIFont.smallSystemFontSize()),
		titleTextColor: UIColor.blackColor()
	)
)
```

####Let us know!
We’d be really happy if you sent us links to your projects where you use our component. Just send an email to github@yalantis.com And do let us know if you have any questions or suggestion regarding the animation.

P.S. We’re going to publish more awesomeness wrapped in code and a tutorial on how to make UI for iOS (Android) better than better. Stay tuned!

##License

The MIT License (MIT)

Copyright © 2016 Yalantis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.