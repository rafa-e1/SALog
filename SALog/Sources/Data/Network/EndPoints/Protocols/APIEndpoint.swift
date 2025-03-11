//
//  APIEndpoint.swift
//  SALog
//
//  Created by RAFA on 3/11/25.
//

import Moya

protocol APIEndpoint: TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: Moya.Method { get }
    var task: Moya.Task { get }
    var headers: [String: String]? { get }
}
