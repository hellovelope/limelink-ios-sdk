//
//  ApiServiceImpl.swift
//  LimelinkIOSSDK
//
//  Created by artue on 6/24/24.
//

import Foundation

public class ApiServiceImpl: ApiSerivce {
    private let baseURL = URL(string: "https://limelink.org")!
    
    public func sendLimeLink(data: LimeLinkRequest, completion: @escaping (Result<Void, Error>) -> Void) {
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
