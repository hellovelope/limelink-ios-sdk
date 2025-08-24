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

   **Swift:**
   ```swift
   // Universal Link handling
   func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
       if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
           if let url = userActivity.webpageURL {
               UniversalLink.shared.handleUniversalLink(url) { uri in
                   if let uri = uri {
                       print("Universal Link URI: \(uri)")
                       // Handle the received URI here or pass it
                       // Note: You must use completion handler in both Swift and Objective-C
                   } else {
                       print("Failed to receive Universal Link URI")
                   }
               }
               return true
           }
       }
       return false
   }
   ```

   **Objective-C:**
   ```objc
   // Universal Link handling
   - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
       if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
           NSURL *url = userActivity.webpageURL;
           if (url) {
               [[UniversalLink shared] handleUniversalLink:url completion:^(NSString * _Nullable uri) {
                   if (uri) {
                       NSLog(@"Universal Link URI: %@", uri);
                       // Handle the received URI here or pass it
                       // Note: You must use completion handler in both Swift and Objective-C
                   } else {
                       NSLog(@"Failed to receive Universal Link URI");
                   }
               }];
               return YES;
           }
       }
       return NO;
   }
   ```

### Usage

#### 1. Subdomain Method (Recommended)
When accessing `https://{suffix}.limelink.org/link/{link_suffix}`:

1. SDK retrieves header information from the subdomain
2. Makes a request to `https://www.limelink.org/api/v1/dynamic_link/{link_suffix}` API with header information
3. Returns the `uri` value via completion handler for the app to handle

#### 2. Direct Access Method
When directly accessing `https://www.limelink.org/api/v1/dynamic_link/{suffix}`:

1. SDK makes a direct API request
2. Returns the `uri` value via completion handler for the app to handle

### Examples

**Swift:**
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

**Objective-C:**
```objc
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

## SDK Usage Examples

### Swift
```swift
import UIKit
import LimelinkIOSSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Save statistical information
        let url = URL(string: "your_url")!
        saveLimeLinkStatus(url: url, privateKey: "your_private_key")
        
        // Handle intent
        handleIntent()
    }
    
    private func handleIntent() {
        if let url = URL(string: "your_url") {
            let pathParamResponse = parsePathParams(from: url)
            let suffix = pathParamResponse.mainPath
            let handle = pathParamResponse.subPath
            
            if handle == "example" {
                // Navigate to the desired screen
            }
        }
    }
}
```

### Objective-C
```objc
#import <UIKit/UIKit.h>
#import <LimelinkIOSSDK/LimelinkIOSSDK.h>

@interface ViewController : UIViewController
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Save statistical information
    NSURL *url = [NSURL URLWithString:@"your_url"];
    [self saveLimeLinkStatusWithUrl:url privateKey:@"your_private_key"];
    
    // Handle intent
    [self handleIntent];
}

- (void)handleIntent {
    NSURL *url = [NSURL URLWithString:@"your_url"];
    if (url) {
        PathParamResponse *pathParamResponse = [self parsePathParamsFromUrl:url];
        NSString *suffix = pathParamResponse.mainPath;
        NSString *handle = pathParamResponse.subPath;
        
        if ([handle isEqualToString:@"example"]) {
            // Navigate to the desired screen
        }
    }
}

@end
```
