//
//  ApiService.swift
//  LimelinkIOSSDK
//
//  Created by artue on 6/21/24.
//

import Foundation

protocol ApiSerivce {
    func sendLimeLink(data: LimeLinkRequest, completion: @escaping((Result<Void, Error>) -> Void))
}
