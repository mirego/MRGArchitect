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

#import <OCMock/OCMock.h>
#import "MRGArchitectJSONLoader+Tests_JSONLoader.h"

#import <MRGArchitect/MRGArchitect.h>
#import <MRGArchitect/MRGArchitectImportAction.h>

@interface Tests_JSONLoader : XCTestCase

@property id mock;
@end

@implementation Tests_JSONLoader

- (void)setUp
{
    [super setUp];
    MRGArchitectJSONLoader *loader = [[MRGArchitectJSONLoader alloc] init];
    [loader registerAction:[MRGArchitectImportAction class]];
    _mock = OCMPartialMock(loader);
    
    OCMStub([_mock fileExistsAtPath:[OCMArg any]]).andReturn(YES);
    OCMStub([_mock pathForClassName:@"class" suffix:@"-traits"]).andReturn(nil);
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
    OCMStub([_mock pathForClassName:@"class" suffix:nil]).andReturn(@"class.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"~ipad"]).andReturn(@"class~ipad.json");
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~ipad.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

- (void)testLoadEntriesForIPhone
{
    OCMStub([_mock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPhone);
    OCMStub([_mock screenHeight]).andReturn(480.0f);
    OCMStub([_mock pathForClassName:@"class" suffix:nil]).andReturn(@"class.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"~iphone"]).andReturn(@"class~iphone.json");
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~iphone.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

- (void)testLoadEntriesForIPhone5
{
    OCMStub([_mock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPhone);
    OCMStub([_mock screenHeight]).andReturn(568.0f);
    OCMStub([_mock pathForClassName:@"class" suffix:nil]).andReturn(@"class.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"~iphone"]).andReturn(@"class~iphone.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-568h"]).andReturn(@"class-568h.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-568h~iphone"]).andReturn(@"class-568h~iphone.json");
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~iphone.json", @"class-568h.json", @"class-568h~iphone.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

- (void)testLoadEntriesForIPhone6
{
    OCMStub([_mock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPhone);
    OCMStub([_mock screenHeight]).andReturn(667.0f);
    OCMStub([_mock pathForClassName:@"class" suffix:nil]).andReturn(@"class.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"~iphone"]).andReturn(@"class~iphone.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-568h"]).andReturn(@"class-568h.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-568h~iphone"]).andReturn(@"class-568h~iphone.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-667h"]).andReturn(@"class-667h.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-667h~iphone"]).andReturn(@"class-667h~iphone.json");
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~iphone.json", @"class-568h.json", @"class-568h~iphone.json", @"class-667h.json", @"class-667h~iphone.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

- (void)testLoadEntriesForIPhone6Plus
{
    OCMStub([_mock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPhone);
    OCMStub([_mock screenHeight]).andReturn(736.0f);
    OCMStub([_mock pathForClassName:@"class" suffix:nil]).andReturn(@"class.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"~iphone"]).andReturn(@"class~iphone.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-568h"]).andReturn(@"class-568h.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-568h~iphone"]).andReturn(@"class-568h~iphone.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-667h"]).andReturn(@"class-667h.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-667h~iphone"]).andReturn(@"class-667h~iphone.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-736h"]).andReturn(@"class-736h.json");
    OCMStub([_mock pathForClassName:@"class" suffix:@"-736h~iphone"]).andReturn(@"class-736h~iphone.json");
    OCMExpect(([_mock loadEntriesWithPaths:[OCMArg checkWithBlock:^BOOL(NSMutableArray *paths) {
        return [paths isEqualToArray:@[@"class.json", @"class~iphone.json", @"class-568h.json", @"class-568h~iphone.json", @"class-667h.json", @"class-667h~iphone.json", @"class-736h.json", @"class-736h~iphone.json"]];
    }]]));
    
    [_mock loadEntriesWithClassName:@"class"];
}

@end
