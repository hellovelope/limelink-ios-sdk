//
//  LinkStat.swift
//  LimelinkIOSSDK_Example
//
//  Created by artue on 6/18/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation


public class LinkStats {
    private static let prefsName = "link_first_launch_prefs"
    private static let keyFirstLaunch = "is_first_launch"

    public static func isFirstLaunch() -> Bool {
        let userDefaults = UserDefaults.standard
        let isFirstLaunch = userDefaults.bool(forKey: keyFirstLaunch)
        if isFirstLaunch {
            userDefaults.set(false, forKey: keyFirstLaunch)
        }
        return isFirstLaunch
    }
}

func createLimeLinkRequest(privateKey: String, pathParamResponse: PathParamResponse, eventType: EventType) -> LimeLinkRequest {
    return LimeLinkRequest(
        privateKey: privateKey,
        suffix: pathParamResponse.mainPath,
        handle: pathParamResponse.subPath,
        eventType: eventType.rawValue
    )
}

func saveLimeLinkStatus(url: URL?, privateKey: String, apiService: ApiSerivce) {
    let pathParamResponse = parsePathParams(from: url)

    if pathParamResponse.mainPath.isEmpty {
        return
    }

    let eventType: EventType = LinkStats.isFirstLaunch() ? EventType.FIRST_RUN : EventType.RERUN
    let limeLinkRequest = createLimeLinkRequest(privateKey: privateKey, pathParamResponse: pathParamResponse, eventType: eventType)

    apiService.sendLimeLink(data: limeLinkRequest) { result in
        switch result {
        case .success:
            print("Request was successful")
        case .failure(let error):
            print("Request failed with error: \(error)")
        }
    }
}
