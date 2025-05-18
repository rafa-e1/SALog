//
//  ProfileViewModel.swift
//  SALog
//
//  Created by RAFA on 1/12/25.
//

import RxCocoa
import RxSwift

protocol ProfileViewModelInput {
    var selectTab: Observable<ProfileMenuTab> { get }
}

protocol ProfileViewModelOutput {
    var selectedTab: Observable<ProfileMenuTab> { get }
}

protocol ProfileViewModelProtocol {
    func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput
}

final class ProfileViewModel: ProfileViewModelProtocol {

    // MARK: - Input

    struct Input: ProfileViewModelInput {
        let selectTab: Observable<ProfileMenuTab>
    }

    // MARK: - Output

    struct Output: ProfileViewModelOutput {
        let selectedTab: Observable<ProfileMenuTab>
    }

    // MARK: - Properties

    private let selectedTabRelay = BehaviorRelay<ProfileMenuTab>(value: .basicInfo)
    private let disposeBag = DisposeBag()

    // MARK: - Helpers

    func transform(input: ProfileViewModelInput) -> ProfileViewModelOutput {
        bindTabSelection(input: input)

        return Output(
              selectedTab: selectedTabRelay.asObservable()
          )
    }
}

// MARK: - Configuration

private extension ProfileViewModel {

    func bindTabSelection(input: ProfileViewModelInput) {
        input.selectTab
            .distinctUntilChanged()
            .bind(to: selectedTabRelay)
            .disposed(by: disposeBag)
    }
}
