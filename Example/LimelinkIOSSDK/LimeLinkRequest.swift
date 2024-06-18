//
//  LimeLinkRequest.swift
//  LimelinkIOSSDK_Example
//
//  Created by artue on 6/18/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public class LimeLinkRequest: Codable {
    var privateKey: String
    var suffix: String
    var handle: String?
    var eventType: String
    var operatingSystem: String

    init(privateKey: String, suffix: String, handle: String? = nil, eventType: String, operatingSystem: String = "android") {
        self.privateKey = privateKey
        self.suffix = suffix
        self.handle = handle
        self.eventType = eventType
        self.operatingSystem = operatingSystem
    }
}
