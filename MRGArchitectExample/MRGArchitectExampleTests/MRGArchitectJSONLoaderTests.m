//
//  MRGArchitectJSONLoader.m
//  MRGArchitectExample
//
//  Created by Jean-Francois Morin on 2014-06-25.
//  Copyright (c) 2014 Mirego, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MRGArchitectJSONLoader+MRGArchitectJSONLoaderTests.h"
#import "MRGArchitect.h"
#import "MRGArchitectImportAction.h"

@interface MRGArchitectJSONLoaderTests : XCTestCase
@property id mock;
@end

@implementation MRGArchitectJSONLoaderTests

- (void)setUp
{
    [super setUp];
    MRGArchitectJSONLoader *loader = [[MRGArchitectJSONLoader alloc] init];
    [loader registerAction:[MRGArchitectImportAction class]];
    _mock = OCMPartialMock(loader);

    OCMStub([_mock pathPrefixWithClassName:[OCMArg any]]).andReturn(@"");
}

- (void)tearDown
{
    OCMVerifyAll(_mock);
    _mock = nil;
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

- (void)testLoadEntriesForIPad
{
    OCMStub([_mock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPad);
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~ipad.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

- (void)testLoadEntriesForIPhone
{
    OCMStub([_mock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPhone);
    OCMStub([_mock screenHeight]).andReturn(480.0f);
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~iphone.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

- (void)testLoadEntriesForIPhone5
{
    OCMStub([_mock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPhone);
    OCMStub([_mock screenHeight]).andReturn(568.0f);
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~iphone.json", @"class-568h.json", @"class-568h~iphone.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

- (void)testLoadEntriesForIPhone6
{
    OCMStub([_mock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPhone);
    OCMStub([_mock screenHeight]).andReturn(667.0f);
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~iphone.json", @"class-568h.json", @"class-568h~iphone.json", @"class-667h.json", @"class-667h~iphone.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

- (void)testLoadEntriesForIPhone6Plus
{
    OCMStub([_mock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPhone);
    OCMStub([_mock screenHeight]).andReturn(736.0f);
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~iphone.json", @"class-568h.json", @"class-568h~iphone.json", @"class-667h.json", @"class-667h~iphone.json", @"class-736h.json", @"class-736h~iphone.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

@end
