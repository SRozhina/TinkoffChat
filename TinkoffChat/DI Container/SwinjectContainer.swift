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
            .register(IConversationsStorage.self) { _ in ConversationsInMemoryStorage() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(IMessagesStorage.self) { _ in MessagesInMemoryStorage() }
            .inObjectScope(.container)
        
        defaultContainer
            .register(ISelectedConversationPreviewService.self) { _ in SelectedConversationPreviewService() }
            .inObjectScope(.container)
        
        defaultContainer.register(IConversationPresenter.self) { resolver, view in
            ConversationPresenter(view: view,
                                  messagesStorage: resolver.resolve(IMessagesStorage.self)!,
                                  selectedConversationPreviewService: resolver.resolve(ISelectedConversationPreviewService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ConversationViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IConversationPresenter.self, argument: view as IConversationView)!
        }
        
        defaultContainer.register(IConversationsListPresenter.self) { resolver, view in
            ConversationsListPresenter(view: view,
                                       conversationsStorage: resolver.resolve(IConversationsStorage.self)!,
                                       selectedConversationService: resolver.resolve(ISelectedConversationPreviewService.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ConversationsListViewController.self) { resolver, view in
            view.presenter = resolver.resolve(IConversationsListPresenter.self, argument: view as IConversationsListView)!
        }
    }
}
