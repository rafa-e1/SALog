//
//  SearchEndPoint.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Moya

enum SearchEndPoint {
    case searchByNickname(nickname: String)
    case searchByClan(clanName: String)
}

extension SearchEndPoint: APIEndpoint {

    var baseURL: URL {
        return URL(string: NetworkEnvironment.baseURL)!
    }

    var path: String {
        switch self {
        case .searchByNickname(let nickname):
            return "/Search/GetSearchAll/\(nickname)/1"
        case .searchByClan(let clanName):
            return "/Search/GetSearchClanAll/\(clanName)/1"
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
}
