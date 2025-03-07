//
//  ProfileTarget.swift
//  SALog
//
//  Created by RAFA on 3/7/25.
//

import Moya

enum ProfileTarget {
    case userProfile(userNexonSN: Int)
}

extension ProfileTarget: TargetType {

    var baseURL: URL {
        return URL(string: NetworkEnvironment.baseURL)!
    }

    var path: String {
        switch self {
        case .userProfile(let userNexonSN):
            return "/Profile/GetProfileMain/\(userNexonSN)"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
