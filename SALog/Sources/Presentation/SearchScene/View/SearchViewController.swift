//
//  SearchViewController.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//


import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController {

    // MARK: - Properties

    private let viewModel: SearchViewModelProtocol

    private let nicknameButton = UIButton()
    private let clanNameButton = UIButton()
    private let radioButtonsStackView = UIStackView()
    private let searchBar = SearchView()
    private let tableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let searchTypeRelay = BehaviorRelay<SearchType>(value: .nickname)

    // MARK: - Initializer

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setTableView()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Bindings

    private func bindViewModel() {
        let input = SearchViewModel.Input(
            searchType: searchTypeRelay.asObservable(),
            query: searchBar.textField.rx.text.orEmpty.asObservable()
        )

        let output = viewModel.transform(input: input)

        searchTypeRelay
            .flatMap { type in
                output.results.map { results in
                    results.filter { $0.isMatchingType(type) }
                }
            }
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchResultCell.identifier,
                cellType: SearchResultCell.self
            )) { _, item, cell in
                switch item {
                case .nickname(let user):
                    cell.configure(type: .nickname, user: user)
                case .clan(let clan):
                    cell.configure(type: .clan, clan: clan)
                }
            }
            .disposed(by: disposeBag)

        output.isLoading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        output.errorMessage.bind { [weak self] error in
            let alert = UIAlertController(title: "에러", message: error, preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }.disposed(by: disposeBag)

        nicknameButton.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      self.searchTypeRelay.value != .nickname
                else {
                    return
                }

                self.searchTypeRelay.accept(.nickname)
                self.updateSearchTypeUI(isNicknameSelected: true)
            }
            .disposed(by: disposeBag)

        clanNameButton.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      self.searchTypeRelay.value != .clan
                else {
                    return
                }

                self.searchTypeRelay.accept(.clan)
                self.updateSearchTypeUI(isNicknameSelected: false)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers

    private func setTableView() {
        tableView.register(
            SearchResultCell.self,
            forCellReuseIdentifier: SearchResultCell.identifier
        )

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func updateSearchTypeUI(isNicknameSelected: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.nicknameButton.createRadioButton("닉네임", isSelected: isNicknameSelected)
            self.clanNameButton.createRadioButton("클랜명", isSelected: !isNicknameSelected)
            self.searchBar.updatePlaceholder(
                isNicknameSelected ? "닉네임을 입력해 주세요" : "클랜명을 입력해 주세요"
            )
        }
    }

    // MARK: - UI

    override func setStyle() {
        super.setStyle()

        nicknameButton.createRadioButton("닉네임", isSelected: true)
        clanNameButton.createRadioButton("클랜명", isSelected: false)

        radioButtonsStackView.configureStackView(
            addArrangedSubviews: [nicknameButton, clanNameButton],
            axis: .horizontal,
            alignment: .trailing
        )

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        activityIndicatorView.color = .systemOrange
    }

    override func setHierarchy() {
        view.addSubviews(
            radioButtonsStackView,
            searchBar,
            tableView,
            activityIndicatorView
        )
    }

    override func setLayout() {
        radioButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.equalTo(-16)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(radioButtonsStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
