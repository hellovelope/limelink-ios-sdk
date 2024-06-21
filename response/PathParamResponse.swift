//
//  PathParamResponse.swift
//  LimelinkIOSSDK
//
//  Created by artue on 6/21/24.
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
