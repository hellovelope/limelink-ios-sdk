
import Foundation

public class LimelinkIOSSDK {
    
}


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
