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

#import "MRGArchitectJSONLoader.h"
#import "MRGArchitectExceptions.h"
#import "MRGArchitectAction.h"

static NSString *MRGArchitectActionPrefix = @"@";

@interface MRGArchitectJSONLoader ()

@property (nonatomic) NSMutableArray *registeredActions;

@end

@implementation MRGArchitectJSONLoader

- (instancetype)init
{
    if (self = [super init]) {
        _registeredActions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerAction:(Class)actionToRegister
{
    id<MRGArchitectAction> actionToRegisterInstance = nil;

    if ([actionToRegister conformsToProtocol:@protocol(MRGArchitectAction)]) {
        actionToRegisterInstance = [[actionToRegister alloc] initWithLoader:self];
    } else {
        @throw [NSException exceptionWithName:MRGArchitectInvalidActionClassRegistered reason:@"The registered action class doesn't conforms to the MRGArchitectAction protocol" userInfo:[NSDictionary dictionaryWithObject:[actionToRegister description] forKey:@"invalidActionClass"]];
    }

    [self.registeredActions addObject:actionToRegisterInstance];
}


- (NSDictionary *)loadEntriesWithClassName:(NSString *)className {
    NSMutableArray *paths = [[NSMutableArray alloc] init];

    NSString *path = [[[NSBundle bundleForClass:NSClassFromString(className)] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", className]];
    if (path) [paths addObject:path];

    if (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM()) {
        NSString *path = nil;

        path = [[[NSBundle bundleForClass:NSClassFromString(className)] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@~iphone.json", className]];
        if (path) [paths addObject:path];
        
        if (568.0f == CGRectGetHeight([UIScreen mainScreen].bounds)) {
            path = [[[NSBundle bundleForClass:NSClassFromString(className)] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-568h.json", className]];
            if (path) [paths addObject:path];
            
            path = [[[NSBundle bundleForClass:NSClassFromString(className)] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-568h~iphone.json", className]];
            if (path) [paths addObject:path];
        }
    } else if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        NSString *path = [[[NSBundle bundleForClass:NSClassFromString(className)] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@~ipad.json", className]];
        if (path) [paths addObject:path];
    }

    NSMutableDictionary *entries = [[NSMutableDictionary alloc] init];
    for (NSString *path in paths) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        NSMutableDictionary *dictionary = [self dictionaryWithData:data error:&error];
        if (error) {
            @throw [NSException exceptionWithName:MRGArchitectParseErrorException reason:[error description] userInfo:[error userInfo]];
        } else {
            [self performActionEntries:dictionary];
            [entries addEntriesFromDictionary:dictionary];
        }
    }

    return [NSDictionary dictionaryWithDictionary:entries];
}

- (void)performActionEntries:(NSMutableDictionary *)entries
{
    [entries enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *actionName = [self actionNameForKey:key];
        if (actionName.length > 0) {
            const NSUInteger indexOfRegisteredAction = [self.registeredActions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                id<MRGArchitectAction> registeredAction = obj;
                return [registeredAction.actionName isEqualToString:actionName];
            }];

            if (indexOfRegisteredAction == NSNotFound) {
                @throw [NSException exceptionWithName:MRGArchitectUnexpectedActionTypeException reason:@"Unexpected action type encountered (no matching action class registered)" userInfo:[NSDictionary dictionaryWithObject:key forKey:@"invalidActionType"]];
            } else {
                id <MRGArchitectAction> actionToPerform = self.registeredActions[indexOfRegisteredAction];
                [actionToPerform performActionWithValue:obj onEntries:entries];
            }
        }
    }];
}

- (NSString *)actionNameForKey:(id)key
{
    NSString *actionName = nil;

    const BOOL isValidKey = [key isKindOfClass:[NSString class]];
    if (isValidKey) {
        NSString *stringKey = key;

        const NSUInteger actionPrefixLength = MRGArchitectActionPrefix.length;
        const BOOL isAnAction = stringKey.length > actionPrefixLength && [stringKey hasPrefix:MRGArchitectActionPrefix];
        if (isAnAction) {
            actionName = [key substringFromIndex:actionPrefixLength];
        }
    }

    return actionName;
}

- (NSMutableDictionary *)dictionaryWithData:(NSData *)data error:(NSError **)error {
    if (!data) return nil;

    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    if (!error) {
        return nil;
    }

    return [NSMutableDictionary dictionaryWithDictionary:dictionary];
}

@end