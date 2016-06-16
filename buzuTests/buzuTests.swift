//
//  buzuTests.swift
//  buzuTests
//
//  Created by Ricardo Hurla on 06/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import buzu

class buzuTests: XCTestCase {
    
    //THOSE TESTS WILL ERASE ANY DATA SAVED ON THE NSUserDefaults
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func setUp() {
        super.setUp()
        // Clean Favorites before run tests
        self.defaults.removeObjectForKey("FavLanes")
    }
    
    override func tearDown() {
        // Clean Favorites after run tests
        self.defaults.removeObjectForKey("FavLanes")
        super.tearDown()
    }
    
    func testConstants() {
        // Verify if the constants still have the same value
        XCTAssertEqual(kBaseURL, "http://api.olhovivo.sptrans.com.br/v0/")
        XCTAssertEqual(kAuthenticationURL, "Login/Autenticar?token=")
        XCTAssertEqual(kSearchURL, "Linha/Buscar?termosBusca=")
        XCTAssertEqual(kPositionURL, "Posicao?codigoLinha=")
        XCTAssertEqual(kStopsURL, "Parada/BuscarParadasPorLinha?codigoLinha=")
        
        // Verify if the keys still have the same value
        XCTAssertEqual(kApplicationToken, "da96bf36a683d98dd757c0f885a8f380c04f044edf1d820ce64ff54e0ce301aa")
        XCTAssertEqual(kTwitterConsumerKey, "2pqkau7C6xSgOFzWYJA4cjWcD")
        XCTAssertEqual(kTwitterConsumerSecret, "aLVjDBTI0bbWLtsprkRpDQCIb1nLv2VpzJlRfDwbQhD67fOfwu")
    }
    
    func testAuthenticationOnSptransAPI() {
        
        // Test that verify the request for authentication with the SPTrans API
        var done:Bool = false;
        ServiceManager.sharedInstance.authenticateOnAPI { (result, err) in
            
            // Request result tests
            XCTAssertNil(err)
            XCTAssertNotNil(result)
            XCTAssertEqual(result, "true")
            
            done = true
            
        }
        
        self.waitForBlockToFinish(done, timeout: 20.0)
        
    }
    
    func testBusListRequest() {
        
        // Test that verify the search request for a bus lane, add and remove a favorite object
        var done:Bool = false;
        let searchTerm:String = "917M"
        
        ServiceManager.sharedInstance.searchForBus(searchTerm) { (result, err) in
            
            // Request result tests
            XCTAssertNil(err)
            XCTAssertNotNil(result)
            XCTAssertNotEqual(result.count, 0)
            XCTAssertNotNil(result[0])
            XCTAssertNotNil(result[0]["CodigoLinha"])
            XCTAssertNotNil(result[0]["CodigoLinha"].number)
            
            // Favorite Tests
            var dataArray:JSON = AppManager.sharedInstance.getFavorites()
            XCTAssertEqual(dataArray.count, 0)
            
            AppManager.sharedInstance.addFavoriteBusLane(result[0])
            dataArray = AppManager.sharedInstance.getFavorites()
            XCTAssertNotEqual(dataArray.count, 0)
            
            AppManager.sharedInstance.removeFavoriteBusLane(result[0])
            dataArray = AppManager.sharedInstance.getFavorites()
            XCTAssertEqual(dataArray.count, 0)
            
            done = true
            
        }
        
        self.waitForBlockToFinish(done, timeout: 20.0)
    }
    
    //MARK: BLOCK TIMEOUT
    func waitForBlockToFinish(finished:Bool, timeout:NSTimeInterval) -> Void {
        // Runs a background timeout for the request and make sure that the block of the methods is called
        let timeoutDate = NSDate.init(timeIntervalSinceNow: timeout)
        
        repeat {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: timeoutDate)
            if timeoutDate.timeIntervalSinceNow < 0.0 {
                break;
            }
        } while finished == false
        
    }
 
}
