//
//  ChannelsViewViewModelTests.swift
//  LimeTVStreamingTests
//
//  Created by Миша Перевозчиков on 13.12.2022.
//

import XCTest
import Combine
@testable import LimeTVStreaming

final class ChannelsViewViewModelTests: XCTestCase {
    
    var sut: ChannelsViewViewModel!
    var cancellables = Set<AnyCancellable>()
    
    private var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: #file)
               userDefaults.removePersistentDomain(forName: #file)
        sut = ChannelsViewViewModel(networkingService: MockNetworking(),favourites: Favourites(userDefaults: userDefaults))
    }

    override func tearDownWithError() throws {
        sut = nil
        userDefaults = nil
        cancellables = []
    }
    
    func test_ChannelsViewViewModel_requestChannels() throws {
        
        //Given
        guard let sut = self.sut else {
            XCTFail("View model unavailable")
            return
        }
        var channels: [Channel] = []
        let expectation = XCTestExpectation(description: "Fetched channels")
        //When
        sut.$channels
            .dropFirst()
            .sink { value in
                channels.append(contentsOf: value)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(self.sut.channels.count, channels.count)
    }
    
    func test_ChannelsViewViewModel_init_correctValues() throws {
        //Given
        guard let sut = self.sut else {
            XCTFail("View model unavailable")
            return
        }
        //Then
        XCTAssertTrue(sut.selectedCategory == .all)
        XCTAssertFalse(sut.showErrorMessage)
        XCTAssertTrue(sut.errorMessage.isEmpty)
        XCTAssertTrue(sut.searchableChannel.isEmpty)
        
    }
    
    func test_ChannelsViewViewModel_filteredChannels_shouldReturnAll() throws {
        //Given
        guard let sut = self.sut else {
            XCTFail("View model unavailable")
            return
        }
        //When
        sut.selectedCategory = .all
        
        //Then
        XCTAssertEqual(sut.filteredChannels, sut.channels)
    }
    
    func test_ChannelsViewViewModel_filteredChannels_shouldReturnFavoutites() throws {
        //Given
        guard let sut = self.sut else {
            XCTFail("View model unavailable")
            return
        }
        //When
        sut.selectedCategory = .favourites
        
        //Then
        XCTAssertEqual(sut.filteredChannels.count, 0)
    }
}
