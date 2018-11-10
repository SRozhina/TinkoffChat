//
//  SwinjectStoryboard.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc
    class func setup() {
        defaultContainer
            .register(IConversationsStorage.self) { resolver in
                CoreDataConversationsStorage(conversationConverter: resolver.resolve(IConversationConverter.self)!,
                                             userInfoConverter: resolver.resolve(IUserInfoConverter.self)!) }
            .inObjectScope(.container)
        
        defaultContainer
            .register(ISelectedConversationService.self) { _ in SelectedConversationService() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IConversationConverter.self) { resolver in
                ConversationConverter(userInfoConverter: resolver.resolve(IUserInfoConverter.self)!,
                                      messageConverter: resolver.resolve(IMessageConverter.self)!) }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IUserInfoConverter.self) { resolver in
                UserInfoConverter(userInfoPathProvider: resolver.resolve(IUserInfoPathProvider.self)!) }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IMessageConverter.self) { _ in MessageConverter() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IUserInfoPathProvider.self) { _ in UserInfoPathProvider() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IUserInfoStorageProvider.self) { resolver in
                UserInfoStorageProvider(userInfoPathProvider: resolver.resolve(IUserInfoPathProvider.self)!) }
            .inObjectScope(.container)
        
        defaultContainer
            .register(ICommunicationService.self) { _ in MultipeerCommunicationService() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IErrorAlertBuilder.self) { _ in ErrorAlertBuilder() }
            .inObjectScope(.container)
        
        defaultContainer.register(IConversationPresenter.self) { resolver, view in
            ConversationPresenter(view: view,
                                  communicationService: resolver.resolve(ICommunicationService.self)!,
                                  selectedConversationService: resolver.resolve(ISelectedConversationService.self)!,
                                  conversationsStorage: resolver.resolve(IConversationsStorage.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ConversationViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IConversationPresenter.self, argument: view as IConversationView)!
            view.errorAlertBuilder = resolver.resolve(IErrorAlertBuilder.self)!
        }
        
        defaultContainer.register(IConversationsListPresenter.self) { resolver, view in
            ConversationsListPresenter(view: view,
                                       conversationsStorage: resolver.resolve(IConversationsStorage.self)!,
                                       selectedConversationService: resolver.resolve(ISelectedConversationService.self)!,
                                       communicationService: resolver.resolve(ICommunicationService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ConversationsListViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IConversationsListPresenter.self, argument: view as IConversationsListView)!
            view.errorAlertBuilder = resolver.resolve(IErrorAlertBuilder.self)!
        }
        
        defaultContainer.register(IEditProfilePresenter.self) { resolver, view in
            EditProfilePresenter(view: view,
                                 userInfoStorageProvider: resolver.resolve(IUserInfoStorageProvider.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(EditProfileViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IEditProfilePresenter.self, argument: view as IEditProfileView)!
        }
        
        defaultContainer.register(IProfilePresenter.self) { resolver, view in
            ProfilePresenter(view: view,
                             userInfoStorageProvider: resolver.resolve(IUserInfoStorageProvider.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ProfileViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IProfilePresenter.self, argument: view as IProfileView)!
        }
    }
}
