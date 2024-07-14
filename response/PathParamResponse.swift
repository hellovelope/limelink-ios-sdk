//
//  PathParamResponse.swift
//  LimelinkIOSSDK
//
//  Created by artue on 6/24/24.
//

import Foundation

public class PathParamResponse {
    public var mainPath: String
    public var subPath: String?
    
    init(mainPath: String, subPath: String? = nil) {
        self.mainPath = mainPath
        self.subPath = subPath
    }
    
    public String getMainPath() {
        return mainPath
    }
    
    public String get
}
