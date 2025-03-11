//
//  DomainConvertible.swift
//  SALog
//
//  Created by RAFA on 3/11/25.
//

import Foundation

protocol DomainConvertible {
    associatedtype DomainType
    func toDomain() -> DomainType
}

// MARK: - Character DTO

extension CharacterInfoResponseDTO: DomainConvertible {

    func toDomain() -> CharacterInfo {
        return .init(
            userNexonSN: userNexonSN,
            userNickname: userNickname,
            userImageURL: userImageURL
        )
    }
}

extension CharacterListResultResponseDTO: DomainConvertible {

    func toDomain()-> CharacterListResult {
        return .init(
            characterInfo: characterInfo.map { $0.toDomain() },
            totalCount: totalCount,
            pageNumber: pageNumber
        )
    }
}

extension SearchNicknameResultResponseDTO: DomainConvertible {

    func toDomain() -> SearchNicknameResult {
        return .init(rtnCode: rtnCode, message: message, result: result.toDomain())
    }
}

// MARK: - Clan DTO

extension ClanInfoResponseDTO: DomainConvertible {

    func toDomain() -> ClanInfo {
        return .init(
            clanID: clanID,
            clanName: clanName,
            clanMark1: clanMark1,
            clanMark2: clanMark2
        )
    }
}

extension ClanListResultResponseDTO: DomainConvertible {

    func toDomain()-> ClanListResult {
        return .init(
            clanInfo: clanInfo.map { $0.toDomain() },
            totalCount: totalCount,
            pageNumber: pageNumber
        )
    }
}

extension SearchClanResultResponseDTO: DomainConvertible {

    func toDomain() -> SearchClanResult {
        return .init(message: message, result: result.toDomain())
    }
}
