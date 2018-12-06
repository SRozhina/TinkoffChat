//
//  TinkoffChatTests.swift
//  LoadAvatarTests
//
//  Created by Sofia on 06/12/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import XCTest
@testable import TinkoffChat

class LoadAvatarPresenterTests: XCTestCase {

    var presenter: ILoadAvatarPresenter!
    var viewMock: LoadAvatarViewMock! = LoadAvatarViewMock()
    var avatarNetworkServiceMock: AvatarNetworkServiceMock! = AvatarNetworkServiceMock()
    var userProfileDataServiceMock: UserProfileDataServiceMock! = UserProfileDataServiceMock()
    
    override func setUp() {
        presenter = LoadAvatarPresenter(view: viewMock,
                                        avatarNetworkService: avatarNetworkServiceMock,
                                        userProfileDataService: userProfileDataServiceMock)
    }

    override func tearDown() {
        presenter = nil
        viewMock = nil
        avatarNetworkServiceMock = nil
        userProfileDataServiceMock = nil
    }

    func testSetup() {
        //given
        let userInfo = UserInfo(name: "TestUser")
        userProfileDataServiceMock.stubbedGetUserProfileInfoResult = userInfo
        let url = URL(string: "https://www.google.com")!
        avatarNetworkServiceMock.stubbedGetImagesURLsCompletionResult = ([url], ())
        //when
        presenter.setup()
        //then
        XCTAssert(userProfileDataServiceMock.invokedSetupService)
        XCTAssert(userProfileDataServiceMock.invokedGetUserProfileInfo)
        XCTAssert(viewMock.invokedStartLoading)
        XCTAssert(avatarNetworkServiceMock.invokedGetImagesURLs)
        XCTAssert(viewMock.invokedSetImageURLs)
    }
    
    func testGettingImage() {
        //given
        let url = URL(string: "https://www.google.com")!
        let image = UIImage(named: "logo")!
        avatarNetworkServiceMock.stubbedGetImageCompletionResult = (image, ())
        //when
        presenter.getImage(for: url) {
            //then
            XCTAssertEqual($0.image, image)
        }
    }
    
    func testSelectingImage() {
        //given
        let userInfo = UserInfo(name: "TestUser")
        userProfileDataServiceMock.stubbedGetUserProfileInfoResult = userInfo
        let url = URL(string: "https://www.google.com")!
        avatarNetworkServiceMock.stubbedGetImagesURLsCompletionResult = ([url], ())
        presenter.setup()
        //when
        presenter.selectImage(from: url)
        //then
        XCTAssert(viewMock.invokedStartLoading)
        XCTAssert(userProfileDataServiceMock.invokedSaveUserProfileInfo)
        XCTAssert(viewMock.invokedDismiss)
    }
}
