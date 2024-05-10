
import Foundation

public struct DeepLinkParser {
    public static func parseQueryParams(url: String) -> [String: String] {
        guard let uri = URL(string: url) else {
            return [:] // URL 파싱 실패 시 빈 딕셔너리 반환
        }
        
        var queryParams = [String: String]()
        if let components = URLComponents(url: uri, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for item in queryItems {
                if let value = item.value {
                    queryParams[item.name] = value
                }
            }
        }
        
        return queryParams
    }
}
