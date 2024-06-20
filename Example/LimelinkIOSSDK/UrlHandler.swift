//
//  UrlHandler.swift
//  LimelinkIOSSDK_Example
//
//  Created by artue on 6/18/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public class UrlHandler {
    private static let mainUrlKey = "original-url"

    /* 기본 URL 추출 */
    private static func getUrl(from url: URL?) -> String? {
        return url?.absoluteString
    }

    /* Scheme에서 original URL 추출 */
    static func getScheme(from url: URL?) -> String? {
        guard let url = url else { return nil }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == mainUrlKey })?.value
    }
}

func parseQueryParams(from url: URL?) -> [String: String] {
    guard let urlString = UrlHandler.getScheme(from: url), let url = URL(string: urlString) else {
        return [:]
    }

    var queryParams = [String: String]()
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    components?.queryItems?.forEach { queryParams[$0.name] = $0.value }
    
    return queryParams
}

func parsePathParams(from url: URL?) -> PathParamResponse {
    guard let urlString = UrlHandler.getScheme(from: url), let url = URL(string: urlString) else {
        return PathParamResponse(mainPath: "", subPath: "")
    }

    let pathSegments = url.pathComponents.filter { $0 != "/" }
    
    let mainPath = pathSegments.indices.contains(0) ? pathSegments[0] : ""
    let subPath = pathSegments.indices.contains(2) ? pathSegments[2] : nil
    
    return PathParamResponse(mainPath: mainPath, subPath: subPath)
}
