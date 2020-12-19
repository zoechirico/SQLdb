//
//  DBTests.swift
//  SQLdbTests
//
//  Created by Mike Chirico on 12/19/20.
//

import XCTest

class DBTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_DB() throws {
        
        let db = DB()
        db.open("test.sqlite")
        db.create()
        
        guard let  image = db.img(color: UIColor.green,size: CGSize(width: 20,height: 20)) else {
            print("Can't create image.")
            XCTAssertTrue(1==2)
            return
        }
        
        db.insert(data: "data a", image: image, num: 17.8)
        
        let r = db.result()
        
        XCTAssertTrue(r.count >= 1)
        for (_ , item) in r.enumerated() {
            print("\(item.t1key),\t \(item.data), \(item.num), \(item.timeEnter)")
        }
        
        db.close()
        
    }
    
    func test_DB_t2() throws {
        
        let db = DB()
        db.open("test.sqlite")
        
        db.sql(sql: "drop TABLE IF EXISTS t2;")
        db.sql(sql: "drop TRIGGER IF EXISTS insert_t2_timeEnter;")
        
        
        let sql = """
        CREATE TABLE IF NOT EXISTS t2 (t1key INTEGER
                  PRIMARY KEY,data text,num double,timeEnter DATE);
        CREATE TRIGGER IF NOT EXISTS insert_t2_timeEnter AFTER  INSERT ON t2
          BEGIN
            UPDATE t2 SET timeEnter = DATETIME('NOW')  WHERE rowid = new.rowid;
          END;
        """
        db.sql(sql: sql)
        
        db.sql(sql: "insert into t2 (data,num) values ('data',0.2);")
        
        
        let r = db.resultNI(sql: "select t1key,data,num,timeEnter from t2;")
        
        XCTAssertTrue(r.count >= 1)
        for (_ , item) in r.enumerated() {
            print("\(item.t1key),\t \(item.data), \(item.num),  timeEnter: \(item.timeEnter)")
        }
        
        db.close()
        
    }
    
    
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
