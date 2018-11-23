//
//  SwinjectStoryboard.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import SwinjectStoryboard
import CoreData

extension SwinjectStoryboard {
    @objc
    class func setup() {
        
        // MARK: - Container
        defaultContainer
            .register(NSPersistentContainer.self) { _ in
            let container = NSPersistentContainer(name: "TinkoffChat")
            container.loadPersistentStores(completionHandler: { _, _ in })
            container.viewContext.automaticallyMergesChangesFromParent = true
            return container
        }
            .inObjectScope(.container)
        
        // MARK: - Helpers
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
            .register(IErrorAlertBuilder.self) { _ in ErrorAlertBuilder() }
            .inObjectScope(.container)
        
        // MARK: - Storages
        defaultContainer
            .register(IConversationsStorage.self) { resolver in
                CoreDataConversationsStorage(conversationConverter: resolver.resolve(IConversationConverter.self)!,
                                             userInfoConverter: resolver.resolve(IUserInfoConverter.self)!,
                                             container: resolver.resolve(NSPersistentContainer.self)!,
                                             userInfoPathProvider: resolver.resolve(IUserInfoPathProvider.self)!) }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IUserInfoStorage.self) { resolver in
                CoreDataUserInfoStorage(userInfoPathProvider: resolver.resolve(IUserInfoPathProvider.self)!,
                                        container: resolver.resolve(NSPersistentContainer.self)!) }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IMessagesStorage.self) { resolver in
                CoreDataMessagesStorage(container: resolver.resolve(NSPersistentContainer.self)!)}
            .inObjectScope(.container)
        
        // MARK: - Services
        defaultContainer
            .register(ISelectedConversationService.self) { _ in SelectedConversationService() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(ICommunicationService.self) { _ in MultipeerCommunicationService() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IAvatarNetworkService.self) { _ in PixabayAvatarNetworkService(session: URLSession.shared) }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IMessagesDataService.self) { resolver in
                MessagesDataService(container: resolver.resolve(NSPersistentContainer.self)!,
                                    messageConverter: resolver.resolve(IMessageConverter.self)!)}
        
        defaultContainer
            .register(IConversationsDataService.self) { resolver in
                ConversationsDataService(container: resolver.resolve(NSPersistentContainer.self)!,
                                         conversationConverter: resolver.resolve(IConversationConverter.self)!,
                                         conversationsStorage: resolver.resolve(IConversationsStorage.self)!,
                                         messagesStorage: resolver.resolve(IMessagesStorage.self)!)}
        
        defaultContainer.register(IUserProfileDataService.self) { resolver in
            UserProfileDataService(container: resolver.resolve(NSPersistentContainer.self)!,
                                   userInfoConverter: resolver.resolve(IUserInfoConverter.self)!,
                                   conversationsStorage: resolver.resolve(IConversationsStorage.self)!,
                                   userInfoStorage: resolver.resolve(IUserInfoStorage.self)!)
        }
        
        // MARK: - Conversation
        defaultContainer.register(IConversationPresenter.self) { resolver, view in
            ConversationPresenter(view: view,
                                  interactor: resolver.resolve(IConversationInteractor.self)!)
        }
        
        defaultContainer.register(IConversationInteractor.self) { resolver in
            ConversationInteractor(selectedConversationService: resolver.resolve(ISelectedConversationService.self)!,
                                   messagesDataChangedService: resolver.resolve(IMessagesDataService.self)!,
                                   communicationService: resolver.resolve(ICommunicationService.self)!,
                                   conversationsDataChangedService: resolver.resolve(IConversationsDataService.self)!)
            }
        
        defaultContainer.storyboardInitCompleted(ConversationViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IConversationPresenter.self, argument: view as IConversationView)!
            view.errorAlertBuilder = resolver.resolve(IErrorAlertBuilder.self)!
        }
        
        // MARK: - Conversations List
        defaultContainer.register(IConversationsListPresenter.self) { resolver, view in
            ConversationsListPresenter(view: view,
                                       interactor: resolver.resolve(IConversationsListInteractor.self)!)
        }
        
        defaultContainer.register(IConversationsListInteractor.self) { resolver in
            ConversationsListInteractor(selectedConversationService: resolver.resolve(ISelectedConversationService.self)!,
                                        communicationService: resolver.resolve(ICommunicationService.self)!,
                                        conversationsDataChangedService: resolver.resolve(IConversationsDataService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ConversationsListViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IConversationsListPresenter.self, argument: view as IConversationsListView)!
            view.errorAlertBuilder = resolver.resolve(IErrorAlertBuilder.self)!
        }
        
        // MARK: - Profile
        defaultContainer.register(IProfilePresenter.self) { resolver, view in
            ProfilePresenter(view: view,
                             interactor: resolver.resolve(IProfileInteractor.self)!)
        }
        
        defaultContainer.register(IProfileInteractor.self) { resolver in
            ProfileInteractor(userProfileDataChangedService: resolver.resolve(IUserProfileDataService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ProfileViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IProfilePresenter.self, argument: view as IProfileView)!
        }
        
        // MARK: - Edit Profile
        defaultContainer.register(IEditProfilePresenter.self) { resolver, view in
            EditProfilePresenter(view: view,
                                 interactor: resolver.resolve(IEditProfileInteractor.self)!)
        }
        
        defaultContainer.register(IEditProfileInteractor.self) { resolver in
            EditProfileInteractor(userProfileDataChangedService: resolver.resolve(IUserProfileDataService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(EditProfileViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IEditProfilePresenter.self, argument: view as IEditProfileView)!
        }
        
        // MARK: - Load avatar
        defaultContainer.register(ILoadAvatarPresenter.self) { resolver, view in
            LoadAvatarPresenter(view: view,
                                avatarNetworkService: resolver.resolve(IAvatarNetworkService.self)!,
                                userProfileDataService: resolver.resolve(IUserProfileDataService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(LoadAvatarViewController.self) { resolver, view in
            view.presenter = resolver.resolve(ILoadAvatarPresenter.self, argument: view as ILoadAvatarView)!
        }
    }
}
