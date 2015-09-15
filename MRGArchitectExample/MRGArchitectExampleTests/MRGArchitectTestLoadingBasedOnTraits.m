//
//  MRGArchitectTestLoadingBasedOnTraits.m
//  MRGArchitectExample
//
//  Created by Marc Lefrancois on 2015-09-15.
//  Copyright (c) 2015 Mirego, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MRGArchitect.h"

@interface MRGArchitectTestLoadingBasedOnTraits : XCTestCase

@property (nonatomic, strong) MRGArchitect *architect;
@end

@implementation MRGArchitectTestLoadingBasedOnTraits {
    MRGArchitect *_architect;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [MRGArchitect clearCache];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSettingNoTraitCollection {
    self.architect = [MRGArchitect architectForClassName:NSStringFromClass([self class])];
    [self.architect setTraitCollection:nil];
    XCTAssertEqualObjects([self.architect stringForKey:@"title"], @"any any");
}

- (void)testSettingRegularAnyTraitCollection {
    self.architect = [MRGArchitect architectForClassName:NSStringFromClass([self class])];
    UITraitCollection *collection = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
    [self.architect setTraitCollection:collection];
    XCTAssertEqualObjects([self.architect stringForKey:@"title"], @"Regular any");
}

- (void)testSettingRegularAnyTraitCollectionSubtitleSpecifiedInAnyAnyIsStillThere {
    self.architect = [MRGArchitect architectForClassName:NSStringFromClass([self class])];
    UITraitCollection *collection = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
    [self.architect setTraitCollection:collection];
    XCTAssertEqualObjects([self.architect stringForKey:@"moto"], @"MRGArchitect Rocks");
}

- (void)testFallbacks {
    self.architect = [MRGArchitect architectForClassName:NSStringFromClass([self class])];
    UITraitCollection *collectionHorizontal = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
    UITraitCollection *collectionVertical = [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassCompact];
    [self.architect setTraitCollection:[UITraitCollection traitCollectionWithTraitsFromCollections:@[collectionHorizontal, collectionVertical]]];
    XCTAssertEqualObjects([self.architect stringForKey:@"moto"], @"MRGArchitect Rocks");
    XCTAssertEqualObjects([self.architect stringForKey:@"subtitle"], @"Regular any");
    XCTAssertEqualObjects([self.architect stringForKey:@"subtitle2"], @"Regular any");
    XCTAssertEqualObjects([self.architect stringForKey:@"subtitle3"], @"any Compact");
    XCTAssertEqualObjects([self.architect stringForKey:@"title"], @"Regular Compact");
}


@end
