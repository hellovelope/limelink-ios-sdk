//
//  LimeLinkRequest.swift
//  LimelinkIOSSDK
//
//  Created by artue on 6/24/24.
//

import Foundation

public class LimeLinkRequest: Codable {
    var private_key: String
    var suffix: String
    var handle: String?
    var event_type: String
    var operating_system: String

    init(private_key: String, suffix: String, handle: String? = nil, event_type: String, operating_system: String = "ios") {
        self.private_key = private_key
        self.suffix = suffix
        self.handle = handle
        self.event_type = event_type
        self.operating_system = operating_system
    }
}
