//
//  VoteButtonsWithScoreView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class VoteButtonsWithScoreView: UIView {
    
    struct ViewData {
        let score: Int
        var voteType: LemmyVoteType
    }
    
    var viewData: ViewData?
    
    var upvoteButtonTap: ((VoteButtonsWithScoreView, LemmyVoteType) -> Void)?
    var downvoteButtonTap: ((VoteButtonsWithScoreView, LemmyVoteType) -> Void)?
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    let upvoteBtn = VoteButton(voteType: .top).then {
        $0.setImage(Config.Image.arrowUp, for: .normal)
    }
    
    let downvoteBtn = VoteButton(voteType: .down).then {
        $0.setImage(Config.Image.arrowDown, for: .normal)
    }
    
    private let scoreLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    init() {
        super.init(frame: .zero)
        
        downvoteBtn.addTarget(self, action: #selector(downvoteButtonTapped(sender:)), for: .touchUpInside)
        upvoteBtn.addTarget(self, action: #selector(upvoteButtonTapped(sender:)), for: .touchUpInside)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewData: ViewData) {
        self.viewData = viewData
        self.scoreLabel.text = String(viewData.score)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        upvoteBtn.setImage(Config.Image.arrowUp, for: .normal)
        downvoteBtn.setImage(Config.Image.arrowDown, for: .normal)
    }
    
    @objc private func upvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {
            let type = viewData.voteType == .up ? .none : LemmyVoteType.up
            upvoteButtonTap?(self, type)
        }
    }
    
    @objc private func downvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {
            let type = viewData.voteType == .down ? .none : LemmyVoteType.down
            downvoteButtonTap?(self, type)
        }
    }
}

extension VoteButtonsWithScoreView: ProgrammaticallyViewProtocol {
    func setupView() {
    }
    
    func addSubviews() {
        self.addSubview(stackView)
        stackView.addStackViewItems(
            .view(upvoteBtn),
            .view(scoreLabel),
            .view(downvoteBtn)
        )
    }
    
    func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
