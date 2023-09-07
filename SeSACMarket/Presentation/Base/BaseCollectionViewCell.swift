//
//  BaseCollectionViewCell.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() { }

    func configureLayout() { }
}
