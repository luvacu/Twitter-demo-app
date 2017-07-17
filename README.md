# Twitter demo app
Twitter demo app for iPhone (iOS 10+).

![screenshot_1](https://raw.githubusercontent.com/luvacu/Twitter-demo-app/master/screenshots/Screenshot-1.png)
![screenshot_2](https://raw.githubusercontent.com/luvacu/Twitter-demo-app/master/screenshots/Screenshot-2.png)
![screenshot_2](https://raw.githubusercontent.com/luvacu/Twitter-demo-app/master/screenshots/Screenshot-3.png)

## Usage
- Clone the repo.
- Paste your own Twitter application key and secret in `AppDelegate` to initialise the `TwitterService`:
```
twitterService = TwitterService(withConsumerKey: "YourConsumerKey", consumerSecret: "YourConsumerSecret")
```
- Paste your own Twitter application key in the `Info.plist` file, under `URL types > URL Schemes`:
```
twitterkit-YourConsumerKey
```
- Open the workspace file `Twitter Demo.xcworkspace` and run the app.

## Tools/Libraries/SDKs used
- [TwitterKit](https://dev.twitter.com/twitterkit/overview)
- [RxSwift + RxCocoa](https://github.com/ReactiveX/RxSwift)
- [R.swift](https://github.com/mac-cain13/R.swift)
- [Kingfisher](https://github.com/onevcat/Kingfisher)

## Author
Luis Valdés Cuesta

[luis (DOT) valdes (DOT) cuesta (AT) gmail.com]()

## License
(The MIT License)

Copyright (c) 2017 Luis Valdés Cuesta

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.