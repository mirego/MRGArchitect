//
//  MRGArchitectJSONLoader.m
//  MRGArchitectExample
//
//  Created by Jean-Francois Morin on 2014-06-25.
//  Copyright (c) 2014 Mirego, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MRGArchitectJSONLoader.h"
#import "MRGArchitect.h"

@interface MRGArchitectJSONLoaderTests : XCTestCase

@end

@implementation MRGArchitectJSONLoaderTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInvalidActionRegistration
{
    MRGArchitectJSONLoader *loader = nil;
    
    @try {
        loader = [[MRGArchitectJSONLoader alloc] init];
        [loader registerAction:[NSString class]];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testInvalidActionRegistration");
        XCTAssertEqualObjects(MRGArchitectInvalidActionClassRegistered, exception.name, @"Expecting the exception thrown to be named: MRGArchitectInvalidActionClassRegistered");
    }
}

@end
