//
//  SearchCollectionViewCell.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit
import Kingfisher

final class SearchCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Components

    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.image = .init(systemName: "home")
        imageView.layer.cornerRadius = Constants.Design.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.tintColor = .black
        button.backgroundColor = .white
        // todo: 버튼 cornerRadius를 원으로 적용하기
        button.layer.cornerRadius = 20
        button.clipsToBounds = true

        button.addTarget(self, action: #selector(likeButtonDidTouched(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "새싹몰"
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 2
        label.text = "맥북"
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.text = "10000000원"
        return label
    }()

    private var completion: ((Goods, Bool) -> Void)?
    private var data: Goods?

    // MARK: - Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        thumbnailImageView.kf.cancelDownloadTask()
        completion = nil
        data = nil
        likeButton.isSelected = false
    }

    override func configureUI() {
        super.configureUI()
        contentView.clipsToBounds = true
    }

    override func configureLayout() {
        super.configureLayout()
        [
            thumbnailImageView, likeButton, mallNameLabel, titleLabel, priceLabel
        ].forEach { contentView.addSubview($0) }

        thumbnailImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(thumbnailImageView.snp.width)
        }
        likeButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.trailing.bottom.equalTo(thumbnailImageView).inset(4)
        }
        mallNameLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(Constants.Design.cornerRadius)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mallNameLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(Constants.Design.cornerRadius)
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(Constants.Design.cornerRadius)
            $0.bottom.lessThanOrEqualTo(contentView)
        }
    }

    // MARK: - Action

    @objc private func likeButtonDidTouched(_ sender: UIButton) {
        guard let data else { return }
        sender.isSelected.toggle()
        completion?(data, sender.isSelected)
    }

}

extension SearchCollectionViewCell {

    func configure(with data: Goods, likeButtonDidTouched: @escaping (Goods, Bool) -> Void) {
        self.data = data
        mallNameLabel.text = data.mallName
        titleLabel.text = data.title
        likeButton.isSelected = data.favorite

        if let imageURLString = data.image, let imageURL = URL(string: imageURLString) {
            thumbnailImageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(),
                options: [
                    .processor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ],
                completionHandler: nil
            )
        }

        if let lowPrice = data.lowPrice, let price = Int(lowPrice) {
            if #available(iOS 15.0, *) {
                priceLabel.text = price.formatted()
            } else {
                priceLabel.text = NumberFormatter.convertData(number: price)
            }
        } else {
            priceLabel.text = ""
        }

        completion = likeButtonDidTouched
    }
}
