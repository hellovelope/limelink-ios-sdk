//
//  UniversalLinkHandlerBridge.h
//  LimelinkIOSSDK
//
//  Created by 김길현 on 8/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UniversalLinkHandlerBridge : NSObject

+ (void)handleUniversalLink:(NSURL *)url;

@end
 
NS_ASSUME_NONNULL_END
