//
//  ApiSerivce.swift
//  LimelinkIOSSDK_Example
//
//  Created by artue on 6/18/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

protocol ApiSerivce {
    func sendLimeLink(data: LimeLinkRequest, completion: @escaping((Result<Void, Error>) -> Void))
}
