//
//  UniversalLinkHandlerBridge.m
//  LimelinkIOSSDK
//
//  Created by 김길현 on 8/10/25.
//

#import <Foundation/Foundation.h>
#import "UniversalLinkHandlerBridge.h"

@implementation UniversalLinkHandlerBridge

+ (void)handleUniversalLink:(NSURL *)url {
    // Swift 클래스에 접근하기 위해 NSClassFromString 사용
    Class universalLinkClass = NSClassFromString(@"UniversalLink");
    if (universalLinkClass) {
        id sharedInstance = [universalLinkClass performSelector:@selector(shared)];
        if (sharedInstance) {
            [sharedInstance performSelector:@selector(handleUniversalLink:) withObject:url];
        }
    }
}

@end
