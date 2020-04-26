//
//  eTekiRecuiterUITests.swift
//  eTekiRecuiterUITests
//
//  Created by Siva Sagar Palakurthy on 10/07/19.
//  Copyright © 2019 amzurtech. All rights reserved.
//

import XCTest

class eTekiRecuiterUITests: XCTestCase {
    
    var app: XCUIApplication = XCUIApplication()


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        

        app.launch()
        //self.tryLaunch([LaunchArguments.MockNetworkResponses])

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {}

    func testExample() {

        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements

       
        let textField = app.textFields["ENTER_EMAIL"]
        textField.typeText("anusha.u@mailinator.com")

        
        let password = app.secureTextFields["ENTER_PASSWORD"]
        password.typeText("12345678")


        let signInButton = elementsQuery/*@START_MENU_TOKEN@*/.buttons["SIGN_IN"]/*[[".buttons[\"Sign in\"]",".buttons[\"SIGN_IN\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        signInButton.tap()
        
        sleep(5)
        
        let filtersButton = app.buttons["Filters"]
        filtersButton.tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"My Jobs").children(matching: .other).element(boundBy: 1).tap()
        tablesQuery.cells.containing(.staticText, identifier:"Active").children(matching: .other).element(boundBy: 1).tap()
        tablesQuery.cells.containing(.staticText, identifier:"Inactive").children(matching: .other).element(boundBy: 1).tap()
        app.buttons["Apply"].tap()
        filtersButton.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).tables.children(matching: .cell).element(boundBy: 0).buttons["more"].tap()
                             
    }
    
    func testSignInFeature() {
        
        let app = XCUIApplication()
       // app.navigationBars["Dashboard"].children(matching: .button).element.tap()
 
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery/*@START_MENU_TOKEN@*/.textFields["ENTER_EMAIL"]/*[[".textFields[\"Email Address\"]",".textFields[\"ENTER_EMAIL\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let enterPasswordSecureTextField = elementsQuery/*@START_MENU_TOKEN@*/.secureTextFields["ENTER_PASSWORD"]/*[[".secureTextFields[\"Password\"]",".secureTextFields[\"ENTER_PASSWORD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        enterPasswordSecureTextField.tap()
        enterPasswordSecureTextField.tap()
        elementsQuery/*@START_MENU_TOKEN@*/.buttons["SIGN_IN"]/*[[".buttons[\"Sign in\"]",".buttons[\"SIGN_IN\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 3).navigationBars["Dashboard"].children(matching: .button).element.tap()
        
    }
    
    
    func tryLaunch(_ counter: Int = 10) {
          sleep(3)
          XCUIApplication().terminate()
          sleep(3)
          
          app = XCUIApplication()
          app.launch()
          sleep(3)
          if !app.exists && counter > 0 {
              tryLaunch(counter - 1)
          }
      }

}


