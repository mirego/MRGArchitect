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

#import "MRGArchitect.h"

static UIColor *MRGUIColorWithHexString(NSString *hexString) {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@interface MRGArchitect ()
@property NSDictionary *entries;
@end

@implementation MRGArchitect

- (instancetype)initWithClassName:(NSString *)className {
    if (self = [super init]) {
        NSString *path = [self pathForClassName:className];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        _entries = [self dictionaryWithData:data error:&error];
    }
    
    return self;
}

- (BOOL)boolForKey:(NSString *)key {
    id object = [self objectForKey:key expectedClass:[NSNumber class]];
    return [object boolValue];
}

- (NSString *)stringForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]]) {
		return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
		return [object stringValue];
    } else {
        NSString *reason = [NSString stringWithFormat:@"Unexpected value type for key '%@'", key];
        @throw [NSException exceptionWithName:MRGArchitectUnexpectedValueTypeException reason:reason userInfo:nil];
    }
}

- (NSInteger)integerForKey:(NSString *)key {
    id object = [self objectForKey:key expectedClass:[NSNumber class]];
    return [object integerValue];
}

- (CGFloat)floatForKey:(NSString *)key {
    id object = [self objectForKey:key expectedClass:[NSNumber class]];
    return [object floatValue];
}

- (UIColor *)colorForKey:(NSString *)key {
    NSString *hexString = [self stringForKey:key];
    return MRGUIColorWithHexString(hexString);
}


#pragma mark - Private Implementation

- (NSString *)pathForClassName:(NSString *)className {
    NSString *path = nil;
    if (568.0f == CGRectGetHeight([UIScreen mainScreen].bounds)) {
        path = [[NSBundle bundleForClass:NSClassFromString(className)] pathForResource:[NSString stringWithFormat:@"%@-%@", className, @"568h"] ofType:@"json"];
    } else {
        path = [[NSBundle bundleForClass:NSClassFromString(className)] pathForResource:className ofType:@"json"];
    }
    
    return path;
}

- (NSDictionary *)dictionaryWithData:(NSData *)data error:(NSError **)error {
    if (!data) return nil;
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    if (!error) {
        return nil;
    }
    
    return dictionary;
}

- (id)objectForKey:(NSString *)key {
    return [self objectForKey:key expectedClass:nil];
}

- (id)objectForKey:(NSString *)key expectedClass:(Class)class {
    id object = [self.entries objectForKey:key];
    if (nil == object) {
        NSString *reason = [NSString stringWithFormat:@"Key '%@' not found.", key];
        @throw [NSException exceptionWithName:MRGArchitectKeyNotFoundException reason:reason userInfo:nil];
    }
    
    if (class && ![object isKindOfClass:class]) {
        NSString *reason = [NSString stringWithFormat:@"Unexpected value type for key '%@'", key];
        @throw [NSException exceptionWithName:MRGArchitectUnexpectedValueTypeException reason:reason userInfo:nil];
    }
    
    return object;
}


@end
