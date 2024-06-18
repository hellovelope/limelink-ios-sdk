//
//  PathParamResponse.swift
//  LimelinkIOSSDK_Example
//
//  Created by artue on 6/18/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public class PathParamResponse {
    var mainPath: String
    var subPath: String?
    
    init(mainPath: String, subPath: String? = nil) {
        self.mainPath = mainPath
        self.subPath = subPath
    }
}
