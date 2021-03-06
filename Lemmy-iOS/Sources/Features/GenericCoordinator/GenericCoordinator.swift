//
//  GenericCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

class GenericCoordinator<T: UIViewController>: BaseCoordinator, SFSafariViewControllerDelegate {
    var rootViewController: T! // implement it
    
    var router: RouterProtocol?
    
    init(router: RouterProtocol?) {
        self.router = router
        super.init()
        self.navigationController = router?.navigationController
        self.router?.viewController = self.rootViewController
    }
    
    override func start() {
        fatalError("Override this")
    }
    
    func goToCommunityScreen(communityId: Int? = nil, communityName: String? = nil) {
        let coordinator = CommunityScreenCoordinator(
            router: Router(navigationController: navigationController),
            communityId: communityId,
            communityName: communityName
        )
        self.store(coordinator: coordinator)
        coordinator.start()
        self.router?.push(coordinator.rootViewController, isAnimated: true, onNavigateBack: {
            self.free(coordinator: coordinator)
        })
    }
    
    func goToProfileScreen(userId: Int? = nil, username: String? = nil) {
        let coordinator = ProfileScreenCoordinator(
            router: Router(navigationController: navigationController),
            profileId: userId,
            profileUsername: username
        )
        self.store(coordinator: coordinator)
        coordinator.start()
        self.router?.push(coordinator.rootViewController, isAnimated: true, onNavigateBack: {
            self.free(coordinator: coordinator)
        })
    }
    
    func goToBrowser(with url: URL, inApp: Bool = true) {
        // https://stackoverflow.com/a/35458932
        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") && inApp {
            // Can open with SFSafariViewController
            let safariVc = SFSafariViewController(url: url)
            safariVc.delegate = self
            rootViewController.present(safariVc, animated: true, completion: nil)
        } else {
            // Scheme is not supported or no scheme is given, use openURL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func goToPostScreen(postId: Int) {
        self.goToPostScreenWrapper(post: nil, postId: postId)
    }
    
    func goToPostScreen(post: LMModels.Views.PostView) {
        self.goToPostScreenWrapper(post: post, postId: post.id)
    }
    
    private func goToPostScreenWrapper(post: LMModels.Views.PostView?, postId: Int) {
        let coordinator = PostScreenCoordinator(
            router: Router(navigationController: navigationController),
            postId: postId,
            postInfo: post
        )
        self.store(coordinator: coordinator)
        coordinator.start()
        router?.push(coordinator.rootViewController, isAnimated: true, onNavigateBack: {
            self.free(coordinator: coordinator)
        })
    }
        
    func goToWriteComment(postId: Int, parrentComment: LMModels.Views.CommentView?) {
        ContinueIfLogined(on: rootViewController, coordinator: self) {
            // TODO(uuttff8): Move this code to another component
            let haptic = UIImpactFeedbackGenerator(style: .light)
            haptic.prepare()
            haptic.impactOccurred()
            
            let assembly = WriteCommentAssembly(parentComment: parrentComment, postId: postId)
            let vc = assembly.makeModule()
            let navigationController = StyledNavigationController(rootViewController: vc)
            navigationController.presentationController?.delegate = vc
            rootViewController.present(navigationController, animated: true)
        }
    }
    
    func goToPostAndScroll(to comment: LMModels.Views.CommentView) {
        let coordinator = PostScreenCoordinator(
            router: Router(navigationController: navigationController),
            postId: comment.post.id,
            postInfo: nil,
            scrollToComment: comment
        )
        self.store(coordinator: coordinator)
        coordinator.start()
        coordinator.router?.push(coordinator.rootViewController, isAnimated: true, onNavigateBack: {
            self.free(coordinator: coordinator)
        })
    }
    
    func goToInstances() {
        LemmyShareData.shared.loginData.logout()
        
        if !LemmyShareData.shared.isLoggedIn {
            self.childCoordinators.removeAll()
            
            NotificationCenter.default.post(name: .didLogin, object: nil)
            
            let myCoordinator = InstancesCoordinator(router: Router(navigationController: StyledNavigationController()))
            myCoordinator.start()
            self.childCoordinators.append(myCoordinator)
            myCoordinator.router.setRoot(myCoordinator, isAnimated: true)

            UIApplication.shared.windows.first!.replaceRootViewControllerWith(
                myCoordinator.router.navigationController!,
                animated: true
            )
        } else {
            fatalError("Unexpexted error, must not be happen")
        }
    }
    
    func goToWriteMessage(recipientId: Int) {
        let assembly = WriteMessageAssembly(recipientId: recipientId)
        let vc = assembly.makeModule()
        let navigationController = StyledNavigationController(rootViewController: vc)
        navigationController.presentationController?.delegate = vc
        rootViewController.present(navigationController, animated: true)
    }
    
    // MARK: - SFSafariViewControllerDelegate -
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.rootViewController.dismiss(animated: true)
    }
}
