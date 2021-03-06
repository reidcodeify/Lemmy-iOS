//
//  CommentContentCenterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nantes
import SwiftyMarkdown

// MARK: - CommentCenterView: UIView -
class CommentCenterView: UIView {

    // MARK: - ViewData
    struct ViewData {
        let comment: String
        let isDeleted: Bool
    }

    // MARK: - Properties
    var onLinkTap: ((URL) -> Void)?
    var onUserMentionTap: ((LemmyUserMention) -> Void)?
    var onCommunityMentionTap: ((LemmyCommunityMention) -> Void)?
    
    private lazy var commentLabel = NantesLabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .lemmyLabel
        $0.enabledTextCheckingTypes = [.link]
        $0.delegate = self
        $0.numberOfLines = 0
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with data: CommentCenterView.ViewData) {
        let commentText: NSAttributedString = data.isDeleted
            ? createAttributesForDeletedComment()
            : createAttributesForNormalComment(data: data)
        
        commentLabel.attributedText = commentText
        commentLabel.linkAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lemmyBlue]
    }
    
    func prepareForReuse() {
        commentLabel.attributedText = nil
    }

    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
    
    private func createAttributesForDeletedComment() -> NSAttributedString {
        NSAttributedString(string: "Deleted by creator", attributes: [.font: UIFont.italicSystemFont(ofSize: 17),
                                                                      .foregroundColor: UIColor.label])
    }
    
    private func createAttributesForNormalComment(data: CommentCenterView.ViewData) -> NSAttributedString {
        let md = SwiftyMarkdown(string: data.comment)
        md.link.color = .lemmyBlue
        return md.attributedString()
    }
}

extension CommentCenterView: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        self.addSubview(commentLabel)
    }
    
    func makeConstraints() {
        commentLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension CommentCenterView: NantesLabelDelegate {
    func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        if let mention = LemmyUserMention(url: link) {
            onUserMentionTap?(mention)
            return
        }
        
        if let mention = LemmyCommunityMention(url: link) {
            onCommunityMentionTap?(mention)
            return
        }
        
        onLinkTap?(link)
    }
}
