//
//  SearchEndPoint.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Moya

enum SearchEndPoint {
    case searchByNickname(nickname: String, page: Int)
    case searchByClan(clanName: String, page: Int)
}

extension SearchEndPoint: APIEndpoint {

    var baseURL: URL {
        return URL(string: NetworkEnvironment.baseURL)!
    }

    var path: String {
        switch self {
        case .searchByNickname(let nickname, let page):
            return "/Search/GetSearchAll/\(nickname)/\(page)"
        case .searchByClan(let clanName, let page):
            return "/Search/GetSearchClanAll/\(clanName)/\(page)"
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
