import Foundation
import UIKit

struct DeeplinkResponse: Codable {
    let deeplinkUrl: String
}

struct UniversalLinkResponse: Codable {
    let request_uri: String
}

class LimelinkSDK {
    static let shared = LimelinkSDK()

    private init() {}

    func handleUniversalLink(_ url: URL) {
        guard let host = url.host else { return }
        
        // {suffix}.limelink.org 패턴 확인
        if host.hasSuffix(".limelink.org") {
            handleSubdomainUniversalLink(url)
        } else if host == "limelink.org" {
            // limelink.org 직접 접근 시 처리
            handleLimeLinkUniversalLink(url)
        } else {
            // 기존 deeplink 처리 로직
            let path = url.path  // 예: /abc123
            let subdomain = host.components(separatedBy: ".").first ?? ""
            let platform = "ios"
            
            fetchDeeplink(subdomain: subdomain, path: path, platform: platform)
        }
    }
    
    // MARK: - 서브도메인 Universal Link 처리
    private func handleSubdomainUniversalLink(_ url: URL) {
        guard let host = url.host else { return }
        
        // {suffix}.limelink.org에서 suffix 추출
        let suffix = host.replacingOccurrences(of: ".limelink.org", with: "")
        
        print("🔗 서브도메인 Universal Link 감지: \(host), suffix: \(suffix)")
        
        // 먼저 서브도메인에서 헤더 정보 가져오기
        fetchSubdomainHeaders(suffix: suffix) { [weak self] headers in
            guard let self = self else { return }
            
            // 헤더 정보를 사용하여 Universal Link API 호출
            self.fetchUniversalLinkWithHeaders(suffix: suffix, headers: headers)
        }
    }
    
    // MARK: - LimeLink Universal Link 처리 (직접 접근)
    private func handleLimeLinkUniversalLink(_ url: URL) {
        let path = url.path
        
        // /universal-link/app/dynamic_link/{suffix} 패턴 확인
        let pattern = #"^/universal-link/app/dynamic_link/(.+)$"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: path, range: NSRange(path.startIndex..., in: path)),
              let suffixRange = Range(match.range(at: 1), in: path) else {
            print("❌ Universal Link 패턴이 일치하지 않습니다: \(path)")
            return
        }
        
        let suffix = String(path[suffixRange])
        fetchUniversalLink(suffix: suffix)
    }

    private func fetchDeeplink(subdomain: String, path: String, platform: String) {
        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "https://deep.limelink.org/link/subdomain=\(subdomain)&path=\(encodedPath)&platform=\(platform)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data else { return }

            do {
                let result = try JSONDecoder().decode(DeeplinkResponse.self, from: data)
                DispatchQueue.main.async {
                    self.navigateToDeeplink(result.deeplinkUrl)
                }
            } catch {
                print("❌ Deeplink decoding error:", error)
            }
        }.resume()
    }

    private func navigateToDeeplink(_ deeplink: String) {
        guard let deeplinkURL = URL(string: deeplink) else { return }

        // 내부 라우팅: 앱 구조에 맞춰 수정
        // 예: myapp://screen/123 → 딥링크 처리
        UIApplication.shared.open(deeplinkURL, options: [:], completionHandler: nil)
    }
    
    // MARK: - 서브도메인 헤더 정보 가져오기
    private func fetchSubdomainHeaders(suffix: String, completion: @escaping ([String: String]) -> Void) {
        let urlString = "https://\(suffix).limelink.org"
        
        guard let url = URL(string: urlString) else {
            print("❌ 서브도메인 URL 생성 실패: \(urlString)")
            completion([:])
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD" // 헤더만 가져오기 위해 HEAD 요청 사용
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 서브도메인 헤더 요청 실패: \(error)")
                completion([:])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ HTTP 응답이 아닙니다")
                completion([:])
                return
            }
            
            // 응답 헤더 추출
            let headers = httpResponse.allHeaderFields as? [String: String] ?? [:]
            print("📋 서브도메인 헤더 정보: \(headers)")
            
            completion(headers)
        }.resume()
    }
    
    // MARK: - 헤더 정보를 포함한 Universal Link API 호출
    private func fetchUniversalLinkWithHeaders(suffix: String, headers: [String: String]) {
        let urlString = "https://limelink.org/universal-link/app/dynamic_link/\(suffix)"
        
        guard let url = URL(string: urlString) else {
            print("❌ Universal Link URL 생성 실패: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 서브도메인에서 받은 헤더 정보를 요청에 포함
        for (key, value) in headers {
            // 중요한 헤더들만 전달 (보안상 민감한 정보 제외)
            if ["X-Request-ID", "X-User-Agent", "X-Referer", "X-Forwarded-For", "Authorization"].contains(key) {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        print("🔗 Universal Link API 호출: \(urlString)")
        print("📋 포함된 헤더: \(headers)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Universal Link API 호출 실패: \(error)")
                return
            }
            
            guard let data = data else {
                print("❌ Universal Link API 응답 데이터가 없습니다")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(UniversalLinkResponse.self, from: data)
                DispatchQueue.main.async {
                    self.navigateToUniversalLink(result.request_uri)
                }
            } catch {
                print("❌ Universal Link 응답 디코딩 실패: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📄 응답 내용: \(responseString)")
                }
            }
        }.resume()
    }
    
    // MARK: - 기존 Universal Link API 호출 (헤더 없이)
    private func fetchUniversalLink(suffix: String) {
        let urlString = "https://limelink.org/universal-link/app/dynamic_link/\(suffix)"
        
        guard let url = URL(string: urlString) else {
            print("❌ Universal Link URL 생성 실패: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Universal Link API 호출 실패: \(error)")
                return
            }
            
            guard let data = data else {
                print("❌ Universal Link API 응답 데이터가 없습니다")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(UniversalLinkResponse.self, from: data)
                DispatchQueue.main.async {
                    self.navigateToUniversalLink(result.request_uri)
                }
            } catch {
                print("❌ Universal Link 응답 디코딩 실패: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📄 응답 내용: \(responseString)")
                }
            }
        }.resume()
    }
    
    // MARK: - Universal Link 내부 라우팅
    private func navigateToUniversalLink(_ requestUri: String) {
        print("🔗 Universal Link 리다이렉트: \(requestUri)")
        
        // request_uri가 URL인 경우 직접 열기
        if let url = URL(string: requestUri) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    print("✅ Universal Link 리다이렉트 성공")
                } else {
                    print("❌ Universal Link 리다이렉트 실패")
                }
            }
        } else {
            // request_uri가 앱 내 경로인 경우 커스텀 스킴으로 처리
            let customScheme = "limelink://\(requestUri)"
            if let customURL = URL(string: customScheme) {
                UIApplication.shared.open(customURL, options: [:]) { success in
                    if success {
                        print("✅ 커스텀 스킴 리다이렉트 성공: \(customScheme)")
                    } else {
                        print("❌ 커스텀 스킴 리다이렉트 실패: \(customScheme)")
                    }
                }
            } else {
                print("❌ 유효하지 않은 request_uri: \(requestUri)")
            }
        }
    }
}
