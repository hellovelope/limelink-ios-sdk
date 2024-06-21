//
//  UrlHandler.swift
//  LimelinkIOSSDK
//
//  Created by artue on 6/21/24.
//

import Foundation

public class UrlHandler {
    private static let mainUrlKey = "original-url"

    /* 기본 URL 추출 */
    private static func getUrl(from url: URL?) -> String? {
        return url?.absoluteString
    }

    /* Scheme에서 original URL 추출 */
    public static func getScheme(from url: URL?) -> String? {
        guard let url = url else { return nil }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == mainUrlKey })?.value
    }
}

