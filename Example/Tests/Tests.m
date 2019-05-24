// Copyright (c) 2014-2019, Mirego
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

@import XCTest;

#import "MRGArchitect.h"

static const CGFloat accuracy = 0.01f;

@interface Tests : XCTestCase

@property MRGArchitect *architect;
@end

@implementation Tests

- (void)setUp {
    [super setUp];
    [MRGArchitect clearCache];
    _architect = [MRGArchitect architectForClassName:NSStringFromClass([self class])];
}

- (void)tearDown {
    _architect = nil;
    [super tearDown];
}

- (void)testParseError {
    MRGArchitect *architect = nil;
    @try {
        architect = [MRGArchitect architectForClassName:@"Tests_Invalid"];
        XCTAssert(false, "Should've thrown an exception");
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testParseError");
        XCTAssertEqualObjects(MRGArchitectParseErrorException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectParseErrorException");
    }
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

- (void)testUnsignedIntegerForKey {
    NSUInteger value = [self.architect unsignedIntegerForKey:@"testUIntegerForKey"];
    XCTAssertEqual(3, value, @"Expecting the unsigned integer value '3' for the key: testUIntegerForKey");
}

- (void)testNonUnsignedIntegerForKey {
    NSUInteger value = 0;
    @try {
        value = [self.architect unsignedIntegerForKey:@"testNonUIntegerForKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonUIntegerForKey");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testIntForKey {
    int value = [self.architect intForKey:@"testIntForKey"];
    XCTAssertEqual(3, value, @"Expecting the int value '3' for the key: testIntForKey");
}

- (void)testNonIntForKey {
    int value = 0;
    @try {
        value = [self.architect intForKey:@"testNonIntForKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonIntForKey");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testUnsignedIntForKey {
    unsigned int value = [self.architect unsignedIntForKey:@"testUIntForKey"];
    XCTAssertEqual(3, value, @"Expecting the unsigned int value '3' for the key: testUIntForKey");
}

- (void)testNonUnsignedIntForKey {
    unsigned int value = 0;
    @try {
        value = [self.architect unsignedIntForKey:@"testNonUIntForKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonUIntForKey");
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

- (void)testColorWithAlphaForKey {
    UIColor *value = [self.architect colorForKey:@"testColorWithAlphaForKey"];
    UIColor *color = [UIColor colorWithRed:255/255.0f green:0 blue:0 alpha:255/255.0f];
//    XCTAssertTrue([[[UIColor redColor] colorWithAlphaComponent:128/255.0f] isEqual:value], @"Expecting the color value 'red 50%%' for key: testColorForKey");
    XCTAssertEqualObjects(color, value, @"Expecting the color value 'red 50%%' for key: testColorForKey");
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

- (void)testPointForKey {
    CGPoint value = [self.architect pointForKey:@"testPointForKey"];
    CGPoint expectedValue = CGPointMake(1.0f, 2.0f);
    XCTAssertTrue(CGPointEqualToPoint(expectedValue, value), @"Expecting the CGPoint value '{1, 2}' for key: testPointForKey");
}

- (void)testStringPointForKey {
    CGPoint value = [self.architect pointForKey:@"testStringPointForKey"];
    CGPoint expectedValue = CGPointMake(2.0f, 1.0f);
    XCTAssertTrue(CGPointEqualToPoint(expectedValue, value), @"Expecting the CGPoint value '{2, 1}' for key: testStringPointForKey");
}

- (void)testNotQuitePoint {
    CGPoint value = [self.architect pointForKey:@"testNotQuitePoint"];
    CGPoint expectedValue = CGPointZero;
    XCTAssertTrue(CGPointEqualToPoint(expectedValue, value), @"Expecting the CGPoint value '{0, 0}' for key: testNotQuitePoint");
}

- (void)testNonPointKey {
    CGPoint value;
    @try {
        value = [self.architect pointForKey:@"testNonPointKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonPointKey");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testSizeForKey {
    CGSize value = [self.architect sizeForKey:@"testSizeForKey"];
    CGSize expectedValue = CGSizeMake(10.0f, 20.0f);
    XCTAssertTrue(CGSizeEqualToSize(expectedValue, value), @"Expecting the CGSize value '{10, 20}' for key: testSizeForKey");
}

- (void)testStringSizeForKey {
    CGSize value = [self.architect sizeForKey:@"testStringSizeForKey"];
    CGSize expectedValue = CGSizeMake(20.0f, 10.0f);
    XCTAssertTrue(CGSizeEqualToSize(expectedValue, value), @"Expecting the CGSize value '{20, 10}' for key: testStringSizeForKey");
}

- (void)testNotQuiteSize {
    CGSize value = [self.architect sizeForKey:@"testNotQuiteSize"];
    CGSize expectedValue = CGSizeZero;
    XCTAssertTrue(CGSizeEqualToSize(expectedValue, value), @"Expecting the CGSize value '{0, 0}' for key: testNotQuiteSize");
}

- (void)testNonSizeKey {
    CGSize value;
    @try {
        value = [self.architect sizeForKey:@"testNonSizeKey"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNonSizeKey");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
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

- (void)testOverridenKey {
    NSInteger value = [self.architect integerForKey:@"testOverridenKey"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        XCTAssertEqual(142, value, @"Expecting the integer value '142' for the key: testOverridenKey");
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        XCTAssertEqual(242, value, @"Expecting the integer value '242' for the key: testOverridenKey");
    } else {
        XCTAssert(NO, @"Unknown userInterfaceIdiom");
    }
}

- (void)testFontKey {
    UIFont *value = [self.architect fontForKey:@"testFontKey"];
    XCTAssertNotNil(value, @"Expecting the UIFont of name 'HelveticaNeue' for key: testFontKey");
}

- (void)testNotQuiteFont {
    UIFont *value = nil;
    @try {
        value = [self.architect fontForKey:@"testNotQuiteFont"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNotQuiteFont");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testRectForKey {
    CGRect value = [self.architect rectForKey:@"testRectForKey"];
    CGRect expectedValue = CGRectMake(10.0, 10.0, 64.0, 64.0);
    XCTAssertTrue(CGRectEqualToRect(expectedValue, value), @"Expecting the CGRect value '{{10.0, 10.0}, {64.0, 64.0}}' for key: testRectForKey");
}

- (void)testStringRectForKey {
    CGRect value = [self.architect rectForKey:@"testStringRectForKey"];
    CGRect expectedValue = CGRectMake(10.0, 20.0, 64.0, 80.0);
    XCTAssertTrue(CGRectEqualToRect(expectedValue, value), @"Expecting the CGRect value '{{10.0, 10.0}, {64.0, 64.0}}' for key: testRectForKey");
}

- (void)testNotQuiteRect {
    CGRect value;
    @try {
        value = [self.architect rectForKey:@"testNotQuiteRect"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNotQuiteRect");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testGradientForKey {
    MRGArchitectGradient *gradient = [self.architect gradientForKey:@"testGradientForKey"];
    NSArray *colors = @[(id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:2].CGColor];
    NSArray *locations = @[@(0.0f), @(0.3f), @(1.0)];
    XCTAssertTrue(gradient.colors.count == 3 && gradient.locations.count == 3);
    XCTAssertTrue([[UIColor colorWithCGColor:(CGColorRef)gradient.colors[0]] isEqual:[UIColor colorWithCGColor:(CGColorRef)colors[0]]]);
    XCTAssertTrue([[UIColor colorWithCGColor:(CGColorRef)gradient.colors[1]] isEqual:[UIColor colorWithCGColor:(CGColorRef)colors[1]]]);
    XCTAssertTrue([[UIColor colorWithCGColor:(CGColorRef)gradient.colors[2]] isEqual:[UIColor colorWithCGColor:(CGColorRef)colors[2]]]);
    XCTAssertTrue([gradient.locations isEqualToArray:locations]);
}

- (BOOL)color:(UIColor *)color isEqualToColor:(UIColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate( colorSpaceRGB, components );
            
            UIColor *color = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return color;
        } else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace(color);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}

- (void)testNotQuiteGradient {
    MRGArchitectGradient *gradient;
    @try {
        gradient = [self.architect gradientForKey:@"testNotQuiteGradient"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testNotQuiteGradient");
        XCTAssertEqual(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testImportGlobalKey {
    NSString *value = [self.architect stringForKey:@"testGlobalStringKey"];
    XCTAssertTrue([@"global" isEqualToString:value], @"Expecting the string value 'global' for the key: testGlobalStringKey");
}

- (void)testImportFirstLevelOverrideGlobalKey {
    NSString *value = [self.architect stringForKey:@"testGlobalOverrideStringKey1"];
    XCTAssertTrue([@"global 1 is hidden" isEqualToString:value], @"Expecting the string value 'global 1 is hidden' for the key: testGlobalOverrideStringKey1");
}

- (void)testImportSecondLevelOverrideGlobalKey {
    NSString *value = [self.architect stringForKey:@"testGlobalOverrideStringKey2"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        XCTAssertTrue([@"global 2 is hidden~iphone" isEqualToString:value], @"Expecting the string value 'global 2 is hidden' for the key: testGlobalOverrideStringKey2~iphone");
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        XCTAssertTrue([@"global 2 is hidden~ipad" isEqualToString:value], @"Expecting the string value 'global 2 is hidden' for the key: testGlobalOverrideStringKey2~ipad");
    } else {
        XCTAssert(NO, @"Unknown userInterfaceIdiom");
    }
}

- (void)testInvalidActionType {
    MRGArchitect *architect = nil;
    @try {
        architect = [MRGArchitect architectForClassName:@"Tests_InvalidAction"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testInvalidActionType");
        XCTAssertEqualObjects(MRGArchitectUnexpectedActionTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedActionTypeException");
    }
}

- (void)testInvalidImportActionValue {
    MRGArchitect *architect = nil;
    @try {
        architect = [MRGArchitect architectForClassName:@"Tests_InvalidImportActionValue"];
    }
    @catch (NSException *exception) {
        XCTAssertNotNil(exception, @"Expecting an exception to be thrown for key: testInvalidImportActionValue");
        XCTAssertEqualObjects(MRGArchitectUnexpectedValueTypeException, exception.name, @"Expecting the exception thrown to be named: MRGArchitectUnexpectedValueTypeException");
    }
}

- (void)testValidInstanciationFromObject {
    XCTAssertNoThrow([MRGArchitect architectForObject:self], "Expecting the instanciation to complete without exception");
}

- (void)testInValidInstanciationFromObject {
    XCTAssertThrows([MRGArchitect architectForObject:[MRGArchitectGradient new]], "Expecting the instanciation to throw exception");
}

@end
