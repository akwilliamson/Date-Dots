<p align="center" >
  <img src="https://raw.githubusercontent.com/V8tr/AppAnalytics/master/logo.png" alt="AppAnalytics" title="AppAnalytics">
</p>
======
This repository contains CocoaPod for AppAnalytics (http://appanalytics.io).

### Current version:
* AppAnalytics.framework v1.0.0

## Installing
1) Create a Podfile:

```
$ touch Podfile
$ open -a Xcode Podfile
```

2) Add pods to Podfile:

  ```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'
pod 'AppAnalytics', '~> 1.0.0'
```

3) Run: 
 
`$ pod install`

4) From now on, be sure to always open the generated Xcode workspace (.xcworkspace) instead of the project file when building your project: 

`$ open <YourProjectName>.xcworkspace`

### Troubleshooting:

1) Cocoa pods 'Analyzing dependencies' process stuck.

```
$ pod repo remove master
$ pod setup
$ pod install
```

2) Undefined symbols for architecture armv7: "_OBJC_CLASS_$_AppAnalytics", referenced from ... .
Happens when you override cocoa pods linker flags in your target.
```
Go to your target Build Settings -> Other linker flags -> double click. Add $(inherited) to a new line .
```
