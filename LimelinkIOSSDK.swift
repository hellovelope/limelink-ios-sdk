
import Foundation

public class LimelinkIOSSDK {
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


public func parseQueryParams(from url: URL?) -> [String: String] {
    guard let urlString = getScheme(from: url), let url = URL(string: urlString) else {
        return [:]
    }

    var queryParams = [String: String]()
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    components?.queryItems?.forEach { queryParams[$0.name] = $0.value }
    
    return queryParams
}

public func parsePathParams(from url: URL?) -> PathParamResponse {
    guard let urlString = getScheme(from: url), let url = URL(string: urlString) else {
        return PathParamResponse(mainPath: "", subPath: "")
    }

    let pathSegments = url.pathComponents.filter { $0 != "/" }
    
    let mainPath = pathSegments.indices.contains(0) ? pathSegments[0] : ""
    let subPath = pathSegments.indices.contains(2) ? pathSegments[2] : nil
    
    return PathParamResponse(mainPath: mainPath, subPath: subPath)
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

protocol ApiSerivce {
    func sendLimeLink(data: LimeLinkRequest, completion: @escaping((Result<Void, Error>) -> Void))
}

public class ApiServiceImpl: ApiSerivce {
    private let baseURL = URL(string: "https://limelink.org")!
    
    func sendLimeLink(data: LimeLinkRequest, completion: @escaping (Result<Void, Error>) -> Void) {
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
}


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

public class PathParamResponse {
    var mainPath: String
    var subPath: String?
    
    init(mainPath: String, subPath: String? = nil) {
        self.mainPath = mainPath
        self.subPath = subPath
    }
}


enum EventType: String {
    case FIRST_RUN = "first_run"
    case RERUN = "rerurn"
}
