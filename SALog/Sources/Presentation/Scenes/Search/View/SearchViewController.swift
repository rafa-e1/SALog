//
//  SearchViewController.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//

import UIKit

final class SearchViewController: BaseViewController {

    // MARK: - Properties

    private let nicknameButton = UIButton()
    private let clanNameButton = UIButton()
    private let radioButtonsStackView = UIStackView()
    private let searchBar = SearchView()
    private let resultsTableView = UITableView()

    private let viewModel: SearchViewModel

    private var isNicknameSelected = true {
        didSet {
            updateUIForSelection()
            viewModel.updateSearchType(isNicknameSelected ? .nickname : .clan)
        }
    }

    // MARK: - Initializer

    init(viewModel: SearchViewModel = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setAddTargets()
        setDelegates()
        registerCells()
    }

    // MARK: - Actions

    @objc private func nicknameButtonTapped() {
        guard !isNicknameSelected else { return }
        isNicknameSelected = true
    }

    @objc private func clanNameButtonTapped() {
        guard isNicknameSelected else { return }
        isNicknameSelected = false
    }

    // MARK: - Helpers

    private func setDelegates() {
        searchBar.delegate = self
        viewModel.delegate = self
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }

    private func registerCells() {
        resultsTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "Cell"
        )
    }

    // MARK: - UI

    override func setStyle() {
        super.setStyle()

        nicknameButton.createRadioButton("닉네임", isSelected: isNicknameSelected)
        clanNameButton.createRadioButton("클랜명", isSelected: !isNicknameSelected)

        radioButtonsStackView.configureStackView(
            addArrangedSubviews: [nicknameButton, clanNameButton],
            axis: .horizontal,
            alignment: .trailing
        )

        resultsTableView.backgroundColor = .clear
    }

    override func setHierarchy() {
        view.addSubviews(
            radioButtonsStackView,
            searchBar,
            resultsTableView
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

        resultsTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    // MARK: - Helpers

    private func setAddTargets() {
        nicknameButton.addTarget(
            self,
            action: #selector(nicknameButtonTapped),
            for: .touchUpInside
        )

        clanNameButton.addTarget(
            self,
            action: #selector(clanNameButtonTapped),
            for: .touchUpInside
        )
    }

    private func updateUIForSelection() {
        UIView.animate(withDuration: 0.3) {
            self.nicknameButton.createRadioButton(
                "닉네임",
                isSelected: self.isNicknameSelected
            )

            self.clanNameButton.createRadioButton(
                "클랜명",
                isSelected: !self.isNicknameSelected
            )

            self.searchBar.updatePlaceholder(
                self.isNicknameSelected ? "닉네임을 입력해 주세요" : "클랜명을 입력해 주세요"
            )
        }
    }
}

// MARK: - SearchViewDelegate

extension SearchViewController: SearchViewDelegate {

    func didChangeSearchText(_ text: String) {
        viewModel.search(query: text)
    }
}

// MARK: - SearchViewModelDelegate

extension SearchViewController: SearchViewModelDelegate {

    func didUpdateSearchResults() {
        resultsTableView.reloadData()
    }

    func didEncounterError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        print("DEBUG: \(error.localizedDescription)")
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.searchType {
        case .nickname:
            return viewModel.searchResults.count
        case .clan:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear

        switch viewModel.searchType {
        case .nickname:
            let result = viewModel.searchResults[indexPath.row]
            cell.textLabel?.text = "\(result.userNickname) (ID: \(result.userNexonSN))"
        case .clan: break
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {}
