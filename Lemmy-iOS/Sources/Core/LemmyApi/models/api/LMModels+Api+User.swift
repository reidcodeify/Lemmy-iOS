//
//  LMModels+Api.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels.Api {
    enum User {
        
        struct Login: Codable {
            let usernameOrEmail: String
            let password: String
            
            enum CodingKeys: String, CodingKey {
                case usernameOrEmail = "username_or_email"
                case password
            }
        }
        
        struct Register: Codable {
            let username: String
            let email: String?
            let password: String
            let passwordVerify: String
            let admin: Bool
            let showNsfw: Bool
            let captchaUuid: String?
            let captchaAnswer: String?
            
            enum CodingKeys: String, CodingKey {
                case username, email
                case password
                case passwordVerify = "password_verify"
                case admin
                case showNsfw = "show_nsfw"
                case captchaUuid = "captcha_uuid"
                case captchaAnswer = "captcha_answer"
            }
        }
        
        struct GetCaptcha: Codable {}
        
        struct GetCaptchaResponse: Codable {
            let ok: CaptchaResponse?
        }
        
        struct CaptchaResponse: Codable {
            let png: String // A Base64 encoded png
            let wav: String // A Base64 encoded wav aud,
            let uuid: String
        }
        
        struct SaveUserSettings: Codable {
            let showNsfw: Bool
            let theme: String
            let defaultSortType: LemmySortType
            let defaultListingType: LemmyListingType
            let lang: String
            let avatar: String?
            let banner: String?
            let preferredUsername: String?
            let email: String?
            let bio: String?
            let matrixUserId: String?
            let newPassword: String?
            let newPasswordVerify: String?
            let oldPassword: String
            let showAvatars: Bool
            let sendNotificationsToEmail: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case showNsfw = "show_nsfw"
                case theme
                case defaultSortType = "default_sort_type"
                case defaultListingType = "default_listing_type"
                case lang, avatar, banner
                case preferredUsername = "preferred_username"
                case email, bio
                case matrixUserId = "matrix_user_id"
                case newPassword = "new_password"
                case newPasswordVerify = "new_password_verify"
                case oldPassword = "old_password"
                case showAvatars = "show_avatars"
                case sendNotificationsToEmail = "send_notifications_to_email"
                case auth
            }
        }
        
        struct LoginResponse: Codable {
            let jwt: String
        }
        
        struct GetUserDetails: Codable {
            let userId: Int?
            let username: String
            let sort: String
            let page: Int?
            let limit: Int?
            let communityId: Int
            let savedOnly: Bool
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case username
                case sort
                case page
                case limit
                case communityId = "community_id"
                case savedOnly = "saved_only"
                case auth
            }
        }
        
        struct GetUserDetailsResponse: Codable {
            let userView: LMModels.Views.UserViewSafe?
            let userViewDangerous: LMModels.Views.UserViewDangerous?
            let follows: [LMModels.Views.CommunityFollowerView]
            let moderates: [LMModels.Views.CommunityModeratorView]
            let comments: [LMModels.Views.CommentView]
            let posts: [LMModels.Views.PostView]
            
            enum CodingKeys: String, CodingKey {
                case userView = "user_view"
                case userViewDangerous = "user_view_dangerous"
                case follows
                case moderates
                case comments
                case posts
            }
        }
        
        struct GetRepliesResponse: Codable {
            let replies: [LMModels.Views.CommentView]
        }
        
        struct GetUserMentionsResponse: Codable {
            let mentions: [LMModels.Views.UserMentionView]
        }
        
        struct MarkAllAsRead: Codable {
            let auth: String
        }
        
        struct AddAdmin: Codable {
            let user_id: Int
            let added: Bool
            let auth: String
        }
        
        struct AddAdminResponse: Codable {
            let admins: [LMModels.Views.UserViewSafe]
        }
        
        struct BanUser: Codable {
            let userId: Int
            let ban: Bool
            let removeData: Bool
            let reason: String?
            let expires: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case ban
                case removeData = "remove_data"
                case reason
                case expires
                case auth
            }
        }
        
        struct BanUserResponse: Codable {
            let userView: LMModels.Views.UserViewSafe
            let banned: Bool
            
            enum CodingKeys: String, CodingKey {
                case userView = "user_view"
                case banned
            }
        }
        
        struct GetReplies: Codable {
            let sort: LemmySortType
            let page: Int?
            let limit: Int?
            let unreadOnly: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case sort
                case page
                case limit
                case unreadOnly = "unread_only"
                case auth
            }
        }
        
        struct GetUserMentions: Codable {
            let sort: LemmySortType
            let page: Int?
            let limit: Int?
            let unreadOnly: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case sort
                case page
                case limit
                case unreadOnly = "unread_only"
                case auth
            }
        }
        
        struct MarkUserMentionAsRead: Codable {
            let userMentionId: Int
            let read: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case userMentionId = "user_mention_id"
                case read
                case auth
            }
        }
        
        struct UserMentionResponse: Codable {
            let userMentionView: LMModels.Views.UserMentionView
            
            enum CodingKeys: String, CodingKey {
                case userMentionView = "user_mention_view"
            }
        }
        
        struct DeleteAccount: Codable {
            let password: String
            let auth: String
        }
        
        struct PasswordReset: Codable {
            let email: String
        }
        
        struct PasswordResetResponse: Codable {}
        
        struct PasswordChange: Codable {
            let token: String
            let password: String
            let passwordVerify: String
            
            enum CodingKeys: String, CodingKey {
                case token
                case password
                case passwordVerify = "password_verify"
            }
        }
        
        struct CreatePrivateMessage: Codable {
            let content: String
            let recipientId: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case content
                case recipientId = "recipient_id"
                case auth
            }
        }
        
        struct EditPrivateMessage: Codable {
            let editId: Int
            let content: String
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case content
                case auth
            }
        }
        
        struct DeletePrivateMessage: Codable {
            let editId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case deleted
                case auth
            }
        }
        
        struct MarkPrivateMessageAsRead: Codable {
            let editId: Int
            let read: Bool
            let auth: Bool
            
            enum CodingKeys: String, CodingKey {
                case editId = "edit_id"
                case read
                case auth
            }
        }
        
        struct GetPrivateMessages: Codable {
            let unreadOnly: Bool
            let page: Int?
            let limit: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case unreadOnly = "unread_only"
                case page
                case limit
                case auth
            }
        }
        
        struct PrivateMessagesResponse: Codable {
            let privateMessages: [LMModels.Views.PrivateMessageView]
            
            enum CodingKeys: String, CodingKey {
                case privateMessages = "private_messages"
            }
        }
        
        struct PrivateMessageResponse: Codable {
            let privateMessageView: LMModels.Views.PrivateMessageView
            
            enum CodingKeys: String, CodingKey {
                case privateMessageView = "private_message_view"
            }
        }
        
        struct UserJoin: Codable {
            let auth: String
        }
        
        struct UserJoinResponse: Codable {
            let joined: Bool
        }
        
        struct GetReportCount: Codable {
            let community: Int?
            let auth: String
        }
        
        struct GetReportCountResponse: Codable {
            let community: Int?
            let commentReports: Int
            let postReports: Int
            
            enum CodingKeys: String, CodingKey {
                case community
                case commentReports = "comment_reports"
                case postReports = "post_reports"
            }
        }
        
    }
}
