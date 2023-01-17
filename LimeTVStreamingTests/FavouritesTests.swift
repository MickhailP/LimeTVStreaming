//
//  FavouritesTests.swift
//  LimeTVStreamingTests
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import XCTest
@testable import LimeTVStreaming

final class FavouritesTests: XCTestCase {

    var sut: FavouritesChannelsDataService!
    private var userDefaults: UserDefaults!
    
    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        sut = FavouritesChannelsDataService(userDefaultsContainer: userDefaults)
        
    }

    override func tearDownWithError() throws {
        userDefaults = nil
        sut = nil
    }

    func test_Favourites_contains_stress() throws {
        
        //Given
        let loopCount = Int.random(in: 0..<100)
        
        //When
        for i in 0..<loopCount {
            sut.addToFavourites(i)
        }
        
        //Then
        for i in 0..<loopCount {
            XCTAssertTrue(sut.contains(i))
        }
        XCTAssertEqual(sut.favouritesChannels.count, loopCount)
        
    }
    
    func test_Favourites_deleteFromFavourites_stress() throws {
        //Given
        let loopCount = Int.random(in: 0..<100)
        for i in 0..<loopCount {
            sut.addToFavourites(i)
        }
        
        //When
        for i in 0..<loopCount {
            sut.deleteFromFavourites(i)
        }
        
        //Then
        XCTAssertEqual(sut.favouritesChannels.count, 0)
    }
    
    func test_Favourites_deleteFromFavourites_shouldNotContainsInUserDefaults() throws {
        //Given
        let loopCount = Int.random(in: 0..<100)
        for i in 0..<loopCount {
            sut.addToFavourites(i)
        }
        
        //When
        for i in 0..<loopCount {
            sut.deleteFromFavourites(i)
        }
        
        //Then
        let storedData = sut.getAlObjects(from: userDefaults)
        XCTAssertEqual(sut.favouritesChannels.count, storedData.count)
    }
}
