//
//  LemmyGreenOutlinePostEmbed.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyGreenOutlinePostEmbed: UIView {

    struct Data {
        let title: String?
        let description: String?
        let url: String?
    }
    
    private var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()

    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ viewData: Data) {
        
        titleLabel.text = viewData.title
        descriptionLabel.text = viewData.description

        if viewData.title == nil {
            titleLabel.isHidden = true
            titleLabel.removeFromSuperview()
        }
        if viewData.description == nil {
            descriptionLabel.isHidden = true
            descriptionLabel.removeFromSuperview()
        }

        if viewData.description == nil && viewData.title == nil {
            self.isHidden = true
            self.removeFromSuperview()
        }
        
        setupUI(viewData)
    }

    func setupUI(_ viewData: Data) {
        guard viewData.title != nil else { return }

        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGreen.cgColor

        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }

        if viewData.description != nil {
            self.addSubview(descriptionLabel)

            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.leading.equalToSuperview().inset(10)
                make.trailing.equalToSuperview().inset(10)
                make.bottom.equalToSuperview().inset(10)
            }
        } else {
            titleLabel.snp.remakeConstraints { (make) in
                make.top.leading.bottom.trailing.equalToSuperview().inset(10)
            }
        }
    }
}
