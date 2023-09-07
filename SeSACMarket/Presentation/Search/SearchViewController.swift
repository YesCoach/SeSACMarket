//
//  SearchViewController.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit

final class SearchViewController: BaseViewController {

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요."
        searchBar.searchTextField.addTarget(
            self,
            action: #selector(keyboardReturnButtonDidTouched),
            for: .editingDidEndOnExit
        )
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.delegate = self
        return searchBar
    }()

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
        self.title = "쇼핑 검색"
    }

    override func configureLayout() {
        super.configureLayout()
        view.addSubview(searchBar)

        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc private func keyboardReturnButtonDidTouched() {

    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
