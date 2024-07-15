# LimelinkIOSSDK


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
