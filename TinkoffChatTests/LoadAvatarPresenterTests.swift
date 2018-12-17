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
        let userInfo = UserInfo(name: "TestUser")
        userProfileDataServiceMock.stubbedGetUserProfileInfoResult = userInfo
        let image = UIImage(named: "logo")!
        let url = URL(string: "https://www.google.com")!
        avatarNetworkServiceMock.stubbedGetImagesURLsCompletionResult = ([url], ())
        avatarNetworkServiceMock.stubbedGetImageCompletionResult = (image, ())
        presenter.setup()
        let imageExpectation = expectation(description: "image loaded")
        var resultImage: UIImage?
        
        //when
        presenter.getImage(for: url) {
            resultImage = $0.image
            imageExpectation.fulfill()
        }
        
        //then
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertEqual(resultImage, image)
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
        XCTAssert(userProfileDataServiceMock.invokedSaveUserProfileInfo)
    }
}
