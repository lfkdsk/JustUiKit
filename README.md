# JustUiKit
iOS UI Kit With Android-Style Tools

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/lfkdsk/JustUiKit/master/LICENSE)
[![](https://img.shields.io/badge/JustUiKit-v0.1.4-green.svg)](https://github.com/lfkdsk/JustUiKit)
[![](https://img.shields.io/badge/support-iOS8%2B-green.svg)](https://github.com/lfkdsk/JustUiKit)
[![CocoaPods](https://img.shields.io/cocoapods/v/JustUiKit.svg?style=flat-square)](https://cocoapods.org/pods/JustUiKit)

## How To Install?

* Copy to your project

​       Copy JustUiKit folder from the demo project to your project

* Installation with CocoaPods

  CocoaPods is a dependency manager for Objective-C/Swift, which automates and simplifies the process of using 3rd-party libraries like TangramKit in your projects. You can install it with the following command:

`$ sudo gem install cocoapods`

To integrate TangramKit into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
platform :ios, '8.0'
pod 'JustUiKit', '~> 0.1.4'
```

Then, run the following command:

`$ pod install`

## Quick Start

### JustLinearLayout
A Layout that arranges its children in a single column or a single row. The direction of the row can be set by `orientation`. You can also specify gravity, which specifies the alignment of all the child elements by set `gravity` or specify that specific children grow to fill up any remaining space in the layout by setting the weight member of `LinearLayoutParams`. The default orientation is horizontal.

#### Gravity & Margin & Orientation
  ![Vertical](art/vertical_layout.png)

You can set `Gravity` to make Views be layouted at a specify space of parentView. Also set `Margin` will remain spaces in the four directions of the View. In default, LinearLayout layout children in `Horizontal` direction, and you can change it to `Veritcal`.

``` swift
let parentView = JustLinearLayout(frame: UIScreen.main.bounds, orientation: .Vertical)
let params = LinearLayoutParams(
                width: LayoutParams.WRAP_CONTENT,
                height: LayoutParams.WRAP_CONTENT)
let centerParams = LinearLayoutParams(params)
centerParams.layoutGravity = Gravity.Horizontal.getValue()

let marginParams = LinearLayoutParams(params)
marginParams.topMargin = 10

parentView.addView(createView(), centerParams)
parentView.addView(createView(), marginParams)
```

#### Padding & weight
  ![Horizontal](art/horizontal_layout.png)

With the `Padding` in four directions, you can remain inner space of the view. And `Weight` describes how the child views are positioned. Defaults to Gravity.TOP | Gravity.LEFT. If this layout has a VERTICAL orientation, this controls where all the child views are placed if there is extra vertical space. If this layout has a HORIZONTAL orientation, this controls the alignment of the children.

### JustFrameLayout

FrameLayout is designed to block out an area on the screen to display a single item.
Generally, FrameLayout should be used to hold a single child view, because it can be difficult to organize child views in a way that's scalable to different screen sizes without the children overlapping each other.
You can, however, add multiple children to a FrameLayout and control their position within the FrameLayout by assigning gravity to each child, using the layoutGravity.

#### Overlap on left
![Frame1](art/framelayout1.png)

if don't use any `Margin` or `Padding` to change view's position. All the Views will be add like stack and overlap on the `left|top` of the screen. 

Example:

``` swift
let parentView: JustFrameLayout = JustFrameLayout(width:MATCH_PARENT, height:MATCH_PARENT)
let params: FrameLayoutParams = JustFrameLayoutParams(width: WRAP_CONTENT, height: WRAP_CONTENT)
parentView.addView(createView(rgb:0xE4E1D8), params)
parentView.addView(createView(rgb:0x89A49D), params)
parentView.addView(createView(rgb:0x877B6B), params)
```

#### Layout With Gravity
![Frame2](art/framelayout2.png)

You can use horizontal and vertical gravity. Also You can use like `left|bottom`, `center_horizontal|center_vertical` to use them at the same time.

Example:

``` swift
let parentView: FrameLayout = FrameLayout(width:MATCH_PARENT, height:MATCH_PARENT)
let params: FrameLayoutParams = FrameLayoutParams(width: WRAP_CONTENT, height: WRAP_CONTENT)

let b_l = FrameLayoutParams(params)
b_l.layoutGravity = Gravity.BOTTOM | Gravity.TOP
let c_r = FrameLayoutParams(params)
c_r.layoutGravity = Gravity.CENTER_HORIZONTAL | Gravity.RIGHT
parentView.addView(createView(rgb:0xE4E1D8), b_l)
parentView.addView(createView(rgb:0x89A49D), c_r)
parentView.addView(createView(rgb:0x877B6B), params)
```




## Feedback
Please send your feedback as long as there occurs any inconvenience or problem. You can contact me with:
* Email: lfk_dsk@hotmail.com
* Weibo: [@亦狂亦侠_亦温文](http://www.weibo.com/u/2443510260)
* Blog:  [刘丰恺](https://lfkdsk.github.io)

## License

```

    MIT License

    Copyright (c) 2017 JustWe

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

```