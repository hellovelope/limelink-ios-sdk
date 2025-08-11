//
//  UniversalLinkHandlerBridge.m
//  LimelinkIOSSDK
//
//  Created by 김길현 on 8/10/25.
//

#import <Foundation/Foundation.h>
#import "UniversalLinkHandlerBridge.h"
#import "LimelinkIOSSDK-Swift.h"

@implementation UniversalLinkHandlerBridge

+ (void)handleUniversalLink:(NSURL *)url {
    [UniversalLink handleUniversalLink:url];
}

@end
