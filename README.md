# LimelinkIOSSDK
<img src="https://limelink.org/assets/default_lime-C14nNSvc.svg" alt="이미지 설명" style="display: block; margin-left: auto; margin-right: auto; width: 30%;">


[![Version](https://img.shields.io/cocoapods/v/LimelinkIOSSDK.svg?style=flat)](https://cocoapods.org/pods/LimelinkIOSSDK)
[![License](https://img.shields.io/cocoapods/l/LimelinkIOSSDK.svg?style=flat)](https://cocoapods.org/pods/LimelinkIOSSDK)
[![Platform](https://img.shields.io/cocoapods/p/LimelinkIOSSDK.svg?style=flat)](https://cocoapods.org/pods/LimelinkIOSSDK)

### Installation and requirements
Add pod file
```
pod 'LimelinkIOSSDK'
```

If it's completed, let's refer to the SDK Usage Guide and create it.


# SDK Usage Guide
### Save statistical information
Open ***ViewController.swift*** and add the following code
```
import UIKit
import LimelinkIOSSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Example */
        let url = URL(string: "your_url")!
        saveLimeLinkStatus(url: url, privateKey: "your_private_key")
    }
}
```
- This way, you can save information about the first run or relaunch of the app. You can check the actual metrics on the https://limelink.org console.
- The privateKey value is required. If you don't have it, obtain it from the https://limelink.org console and use it.

### Use handle information superficially
Open ***ViewController*** and add the following code

```
import UIKit
import LimelinkIOSSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Example */
        handleIntent()

    }
    
    private func handleIntent() {
        if let url = URL(string: "your_url") {
            let pathParamResponse = parsePathParams(from:url)
            let suffix = pathParamResponse.mainPath

            let handle = pathParamResponse.subPath
            if handle == "example" {
              //Navigate to the desired screen
            }
        }
    }
}
```


- This way, you can handle the information superficially and navigate to the desired screen based on the handle value.

## Universal Link Support

### Setup Instructions

1. **Info.plist Configuration**
   - Add `applinks:limelink.org` to `com.apple.developer.associated-domains`
   - Register `limelink` scheme in `CFBundleURLTypes`

2. **AppDelegate Configuration**
   ```swift
   // Universal Link handling
   func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
       if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
           if let url = userActivity.webpageURL {
               LimelinkSDK.shared.handleUniversalLink(url)
               return true
           }
       }
       return false
   }
   ```

### Usage

#### 1. Subdomain Method (Recommended)
When accessing `https://{suffix}.limelink.org`:

1. SDK retrieves header information from the subdomain
2. Makes a request to `https://limelink.org/universal-link/app/dynamic_link/{suffix}` API with header information
3. Redirects to the appropriate screen within the app using the `request_uri` received from the API

#### 2. Direct Access Method
When directly accessing `https://limelink.org/universal-link/app/dynamic_link/{suffix}`:

1. SDK makes a direct API request
2. Redirects to the appropriate screen within the app using the `request_uri`

### Examples

```swift
// Method 1: Subdomain Access
// When accessing https://abc123.limelink.org
// 1. Collect header information from subdomain
// 2. Call https://limelink.org/universal-link/app/dynamic_link/abc123 API
// 3. API response: {"request_uri": "https://example.com/some-page"}
// 4. Redirect to appropriate screen

// Method 2: Direct Access
// When accessing https://limelink.org/universal-link/app/dynamic_link/abc123
// 1. Make direct API call
// 2. API response: {"request_uri": "product/detail/123"}
// 3. Handle with limelink://product/detail/123 scheme
```
