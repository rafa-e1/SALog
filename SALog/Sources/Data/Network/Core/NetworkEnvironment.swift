//
//  NetworkEnvironment.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Foundation

struct NetworkEnvironment {

    static var baseURL: String {
        guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String,
              !baseURL.isEmpty
        else {
            fatalError("BASE_URL을 찾을 수 없습니다.")
        }

        return baseURL
    }
}
