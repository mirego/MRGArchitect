// Copyright (c) 2014, Mirego
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// - Neither the name of the Mirego nor the names of its contributors may
//   be used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import <XCTest/XCTest.h>
#import "MRGArchitect.h"

static const CGFloat accuracy = 0.01f;

@interface MRGArchitectTests : XCTestCase
@property MRGArchitect *architect;
@end

@implementation MRGArchitectTests

- (void)setUp {
    [super setUp];
    _architect = [[MRGArchitect alloc] initWithClassName:NSStringFromClass([self class])];
}

- (void)tearDown {
    _architect = nil;
    [super tearDown];
}

- (void)testBoolForKey {
    BOOL value = [self.architect boolForKey:@"testBoolForKey"];
    XCTAssertTrue(value, @"Expecting a 'true' value for key: testBoolForKey");
}

- (void)testStringForKey {
    NSString *value = [self.architect stringForKey:@"testStringForKey"];
    XCTAssertTrue([@"Hello, World!" isEqualToString:value], @"Expecting the string value 'Hello, World!' for the key: testStringForKey");
}

- (void)testNonStringForKey {
    NSString *value = nil;
    @try {
        value = [self.architect stringForKey:@"testNonStringForKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonStringForKey");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testIntegerForKey {
    NSInteger value = [self.architect integerForKey:@"testIntegerForKey"];
    XCTAssertEqual(3, value, @"Expecting the integer value '3' for the key: testIntegerForKey");
}

- (void)testNonIntegerForKey {
    NSInteger value = 0;
    @try {
        value = [self.architect integerForKey:@"testNonIntegerForKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonIntegerForKey");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testFloatForKey {
    CGFloat value = [self.architect floatForKey:@"testFloatForKey"];
    XCTAssertEqualWithAccuracy(3.141593, value, accuracy, @"Expecting the float value '3.141593' for key: testFloatForKey");
}

- (void)testNonFloatForKey {
    CGFloat value = 0.0f;
    @try {
        value = [self.architect floatForKey:@"testNonFloatForKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonFloatForKey");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testColorForKey {
    UIColor *value = [self.architect colorForKey:@"testColorForKey"];
    XCTAssertEqualObjects([UIColor redColor], value, @"Expecting the color value 'red' for key: testColorForKey");
}

- (void)testNonColorForKey {
    UIColor *value = nil;
    @try {
        value = [self.architect colorForKey:@"testNonColorForKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonColorForKey");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testEdgeInsetsKey {
    UIEdgeInsets value = [self.architect edgeInsetsForKey:@"testEdgeInsetsKey"];
    UIEdgeInsets expectedValue = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 4.0f);
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(expectedValue, value), @"Expecting the UIEdgeInsets value '{1, 2, 3, 4}' for key: testEdgeInsetsKey");
}

- (void)testStringEdgeInsetsKey {
    UIEdgeInsets value = [self.architect edgeInsetsForKey:@"testStringEdgeInsetsKey"];
    UIEdgeInsets expectedValue = UIEdgeInsetsMake(4.0f, 3.0f, 2.0f, 1.0f);
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(expectedValue, value), @"Expecting the UIEdgeInsets value '{4, 3, 2, 1}' for key: testStringEdgeInsetsKey");
}

- (void)testNonEdgeInsetsKey {
    UIEdgeInsets value;
    @try {
        value = [self.architect edgeInsetsForKey:@"testNonEdgeInsetsKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonEdgeInsetsKey");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testNotQuiteEdgeInsetsKey {
    UIEdgeInsets value = [self.architect edgeInsetsForKey:@"testNotQuiteEdgeInsetsKey"];
    UIEdgeInsets expectedValue = UIEdgeInsetsZero;
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(expectedValue, value), @"Expecting the UIEdgeInsets value '{0, 0, 0, 0}' for key: testNotQuiteEdgeInsetsKey");
}

- (void)testNotFoundKey {
    NSString *value = nil;
    @try {
        value = [self.architect stringForKey:@"testNotFoundKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNotFoundKey");
        XCTAssertEqual(MRGArchitectKeyNotFoundException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectKeyNotFoundException");
    }
}

@end
