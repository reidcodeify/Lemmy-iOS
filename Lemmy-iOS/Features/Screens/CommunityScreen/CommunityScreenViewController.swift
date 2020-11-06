//
//  CommunityScreen.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class CommunityScreenViewController: UIViewController {
    
    typealias Model = CommunityScreenModel
    
    weak var coordinator: FrontPageCoordinator?
    
    var cancellable = Set<AnyCancellable>()
    let model: CommunityScreenModel
    
    let tableView = LemmyTableView(style: .plain)
    
    init(fromId: Int) {
        model = CommunityScreenModel(communityId: fromId)
        super.init(nibName: nil, bundle: nil)
        
        model.loadCommunity(id: fromId)
        model.loadPosts(id: fromId)
    }
    
    convenience init(community: LemmyModel.CommunityView) {
        self.init(fromId: community.id)
        model.communitySubject.send(community)
        model.loadPosts(id: community.id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = model
        tableView.dataSource = model
        tableView.registerClass(PostContentTableCell.self)
        self.view.addSubview(tableView)
        
        model.communitySubject
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [self] in
                tableView.reloadSections(IndexSet(integer: Model.Section.header.rawValue),
                                         with: .automatic)
                self.updateUIOnData(community: $0)
            }.store(in: &cancellable)
        
        model.postsSubject
            .receive(on: RunLoop.main)
            .sink { [self] _ in
                tableView.reloadSections(IndexSet(integer: Model.Section.posts.rawValue),
                                         with: .automatic)
            }.store(in: &cancellable)
        
        model.newDataLoaded = { [self] newPosts in
            guard !model.postsSubject.value.isEmpty else { return }
            
            let startIndex = model.postsSubject.value.count - newPosts.count
            let endIndex = startIndex + newPosts.count
            
            let newIndexpaths =
                Array(startIndex ..< endIndex)
                .map { (index) in
                    IndexPath(row: index, section: CommunityScreenModel.Section.posts.rawValue)
                }
            
            DispatchQueue.main.async {
                tableView.performBatchUpdates {
                    tableView.insertRows(at: newIndexpaths, with: .automatic)
                }
            }
        }
    
        model.goToPostScreen = { [self] (post) in
            coordinator?.goToPostScreen(post: post)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func updateUIOnData(community: LemmyModel.CommunityView) {
        self.title = community.name
        
        model.communityHeaderCell.communityHeaderView.descriptionReadMoreButton.addAction(UIAction(handler: { (_) in
            if let desc = community.description {
                
                let vc = MarkdownParsedViewController(mdString: desc)
                self.present(vc, animated: true)
            }
        }), for: .touchUpInside)
        
        model.communityHeaderCell.contentTypeView.addTap {
            let vc = self.model.communityHeaderCell.contentTypeView.configuredAlert
            self.present(vc, animated: true, completion: nil)
        }
    }
}
