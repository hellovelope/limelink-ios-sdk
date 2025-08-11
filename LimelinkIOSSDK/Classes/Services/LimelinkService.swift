//
//  LinkStats.swift
//  LimelinkIOSSDK
//
//  Created by artue on 6/24/24.
//

import Foundation

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

private func createLimeLinkRequest(privateKey: String, pathParamResponse: PathParamResponse, eventType: EventType) -> LimeLinkRequest {
    return LimeLinkRequest(
        private_key: privateKey,
        suffix: pathParamResponse.mainPath,
        handle: pathParamResponse.subPath,
        event_type: eventType.rawValue
    )
}

public func saveLimeLinkStatus(url: URL?, privateKey: String) {
    let pathParamResponse = parsePathParams(from: url)

    if pathParamResponse.mainPath.isEmpty {
        return
    }

    let eventType: EventType = LinkStats.isFirstLaunch() ? EventType.FIRST_RUN : EventType.RERUN
    let limeLinkRequest = createLimeLinkRequest(privateKey: privateKey, pathParamResponse: pathParamResponse, eventType: eventType)

    sendLimeLink(data: limeLinkRequest) { result in
        switch result {
        case .success:
            print("Request was successful")
        case .failure(let error):
            print("Request failed with error: \(error)")
        }
    }
}

private func sendLimeLink(data: LimeLinkRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let baseURL = URL(string: "https://limelink.org")!
        let url = baseURL.appendingPathComponent("/api/v1/stats/event")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(data) // JSONEncoder 인스턴스를 생성
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
