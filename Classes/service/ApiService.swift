//
//  ApiService.swift
//  LimelinkIOSSDK
//
//  Created by artue on 6/24/24.
//

import Foundation

public protocol ApiSerivce {
   func sendLimeLink(data: LimeLinkRequest, completion: @escaping((Result<Void, Error>) -> Void))
}
