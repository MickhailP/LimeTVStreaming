//
//  ImagePreviewViewModelTests.swift
//  LimeTVStreamingTests
//
//  Created by Миша Перевозчиков on 14.12.2022.
//

import XCTest
@testable import LimeTVStreaming

final class ImagePreviewViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {

    }

    func test_ImagePreviewViewModel_init() async throws {
        
        //Given
        let imageURL = UUID().uuidString
        let imageKey = Int.random(in: 0..<10)
        //When
        let sut = ImagePreviewViewModel(imageURL: imageURL, imageKey: imageKey, networking: MockNetworking())
        
        //Then
        wait(for: [], timeout: 2)
        XCTAssertEqual(sut.imageURL, imageURL)
        XCTAssertEqual(sut.imageKey, String(imageKey))
        XCTAssertTrue(sut.isLoading)
    }

}
