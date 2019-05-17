// Copyright (c) 2014-2015, Mirego
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

NSString * const MRGArchitectActionPrefix = @"@";

@interface MRGArchitectJSONLoader ()

@property (nonatomic) NSMutableArray *registeredActions;
@property (nonatomic) NSDictionary *currentDictionnary;
@end

@implementation MRGArchitectJSONLoader

@synthesize traitCollection = _traitCollection;

+ (NSCache *)cache {
    static NSCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
        cache.name = @"com.mirego.MRGArchitect.JSONLoader.cache";
    });
    
    return cache;
}

+ (void)clearCache {
    [self.cache removeAllObjects];
}

- (instancetype)init {
    if (self = [super init]) {
        _registeredActions = [[NSMutableArray alloc] init];
        _currentDictionnary = @{};
    }
    return self;
}

- (void)registerAction:(Class)actionToRegister {
    id<MRGArchitectAction> actionToRegisterInstance = nil;
    
    if ([actionToRegister conformsToProtocol:@protocol(MRGArchitectAction)]) {
        actionToRegisterInstance = [[actionToRegister alloc] initWithLoader:self];
        
    } else {
        @throw [NSException exceptionWithName:MRGArchitectInvalidActionClassRegistered reason:@"The registered action class doesn't conforms to the MRGArchitectAction protocol" userInfo:[NSDictionary dictionaryWithObject:[actionToRegister description] forKey:@"invalidActionClass"]];
    }
    
    [self.registeredActions addObject:actionToRegisterInstance];
}

- (NSDictionary *)loadEntriesWithClassName:(NSString *)className {
    // Check if we have a architect file that uses the trait collection format
    NSString *path = [self pathForClassName:className suffix:@"-traits"];
    if ([path length] > 0) {
        return [self loadTraitDictionnaryWithPath:path];
    }
    
    // Fallback to old format
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    path = [self pathForClassName:className suffix:nil];
    if ([path length] > 0) {
        [paths addObject:path];
    }
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        default:
            break;
            
        case UIUserInterfaceIdiomPhone: {
            CGFloat screenHeight = CGRectGetHeight(UIScreen.mainScreen.bounds);
            path = [self pathForClassName:className suffix:@"~iphone"];
            if ([path length] > 0) {
                [paths addObject:path];
            }
            
            if (568.0f <= screenHeight) {
                path = [self pathForClassName:className suffix:@"-568h"];
                if ([path length] > 0) {
                    [paths addObject:path];
                }
                
                path = [self pathForClassName:className suffix:@"-568h~iphone"];
                if ([path length] > 0) {
                    [paths addObject:path];
                }
            }
            
            if (667.0f <= screenHeight) {
                path = [self pathForClassName:className suffix:@"-667h"];
                if ([path length] > 0) {
                    [paths addObject:path];
                }
                
                path = [self pathForClassName:className suffix:@"-667h~iphone"];
                if ([path length] > 0) {
                    [paths addObject:path];
                }
            }
            
            if (736.0f <= screenHeight) {
                path = [self pathForClassName:className suffix:@"-736h"];
                if ([path length] > 0) {
                    [paths addObject:path];
                }
                
                path = [self pathForClassName:className suffix:@"-736h~iphone"];
                if ([path length] > 0) {
                    [paths addObject:path];
                }
            }
            
            if (812.0f <= screenHeight) {
                path = [self pathForClassName:className suffix:@"-812h"];
                if ([path length] > 0) {
                    [paths addObject:path];
                }
                
                path = [self pathForClassName:className suffix:@"-812h~iphone"];
                if ([path length] > 0) {
                    [paths addObject:path];
                }
            }
            break;
        }
            
        case UIUserInterfaceIdiomPad: {
            path = [self pathForClassName:className suffix:@"~ipad"];
            if ([path length] > 0) {
                [paths addObject:path];
            }
            
            break;
        }
    }
    
    if (paths.count == 0) {
        @throw [NSException exceptionWithName:MRGArchitectParseErrorException reason:@"Cannot find a JSON file to load" userInfo:nil];
    }
    
    return [self loadEntriesWithPaths:paths];
}

- (NSString *)pathForClassName:(NSString *)className suffix:(NSString *)suffix {
    NSString *path = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.json", className, suffix ?: @""]];
    
    if ([self.class.cache objectForKey:path] != nil) {
        return path;
    }
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        return path;
    }
    
    return nil;
}

- (NSString *)identifierForSizeClass:(UIUserInterfaceSizeClass)class {
    switch(class) {
        case UIUserInterfaceSizeClassUnspecified:
            return @"*";
        case UIUserInterfaceSizeClassRegular:
            return @"+";
        case UIUserInterfaceSizeClassCompact:
            return @"-";
    }
}

- (NSDictionary *)loadTraitDictionnaryWithPath:(NSString *)path {
    self.currentDictionnary = [self loadDictionaryAtPath:path];
    return [self loadEntriesForCurrentSizeClassKeyWithFallbacks];
}

- (NSDictionary *)getCurrentTraitCollectionEntries {
    return [self loadEntriesForCurrentSizeClassKeyWithFallbacks];
}

- (NSDictionary *)loadEntriesForCurrentSizeClassKeyWithFallbacks {
    NSArray *keysToLoad = [self sizeClassKeysToLoadInOrder];
    
    NSMutableDictionary *entries = [[NSMutableDictionary alloc] initWithCapacity:keysToLoad.count];
    for (NSString *key in keysToLoad) {
        [entries addEntriesFromDictionary:[self loadEntriesForSizeClassKey:key inDictionnary:self.currentDictionnary]];
    }
    
    return [NSDictionary dictionaryWithDictionary:entries];
}

- (NSDictionary *)loadEntriesForSizeClassKey:(NSString *)key inDictionnary:(NSDictionary *)dictionary {
    id object = [dictionary objectForKey:key];
    
    if ([object isKindOfClass:[NSMutableDictionary class]]) {
        [self performActionEntries:object];
        return object;
    }
    
    return @{};
}

- (NSArray *)sizeClassKeysToLoadInOrder {
    NSString *horizontalClass = [self identifierForSizeClass:self.traitCollection.horizontalSizeClass];
    NSString *verticalClass = [self identifierForSizeClass:self.traitCollection.verticalSizeClass];
    
    return
    @[
      @"[* *]",
      [NSString stringWithFormat:@"[* %@]", verticalClass],
      [NSString stringWithFormat:@"[%@ *]", horizontalClass],
      [NSString stringWithFormat:@"[%@ %@]", horizontalClass, verticalClass],
      ];
}

- (NSDictionary *)loadEntriesWithPaths:(NSArray *)paths {
    NSDictionary *entries = [self.class.cache objectForKey:paths];
    if (entries != nil) {
        return entries;
    }
    
    NSMutableDictionary *mutableEntries = [[NSMutableDictionary alloc] initWithCapacity:paths.count];
    for (NSString *path in paths) {
        NSMutableDictionary *dictionary = [[self.class loadDictionaryAtPath:path] mutableCopy];
        [self performActionEntries:dictionary];
        
        [mutableEntries addEntriesFromDictionary:dictionary];
    }
    
    entries = [mutableEntries copy];
    
    [self.class.cache setObject:entries forKey:paths];
    return entries;
}

- (void)performActionEntries:(NSMutableDictionary *)entries {
    for (NSString *key in [entries allKeys]) {
        id obj = [entries objectForKey:key];
        NSString *actionName = [self actionNameForKey:key];
        if (actionName.length > 0) {
            const NSUInteger indexOfRegisteredAction = [self.registeredActions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                id<MRGArchitectAction> registeredAction = obj;
                return [registeredAction.actionName isEqualToString:actionName];
            }];
            
            if (indexOfRegisteredAction == NSNotFound) {
                @throw [NSException exceptionWithName:MRGArchitectUnexpectedActionTypeException reason:@"Unexpected action type encountered (no matching action class registered)" userInfo:[NSDictionary dictionaryWithObject:key forKey:@"invalidActionType"]];
            }
            
            id <MRGArchitectAction> actionToPerform = self.registeredActions[indexOfRegisteredAction];
            [actionToPerform performActionWithValue:obj onEntries:entries];
        }
    }
}

- (NSString *)actionNameForKey:(id)key {
    NSString *actionName = nil;
    
    BOOL isValidKey = [key isKindOfClass:[NSString class]];
    if (isValidKey) {
        NSString *stringKey = key;
        
        NSUInteger actionPrefixLength = MRGArchitectActionPrefix.length;
        BOOL isAnAction = (stringKey.length > actionPrefixLength) && [stringKey hasPrefix:MRGArchitectActionPrefix];
        if (isAnAction) {
            actionName = [key substringFromIndex:actionPrefixLength];
        }
    }
    
    return actionName;
}

- (NSDictionary *)loadDictionaryAtPath:(NSString *)path {
    NSDictionary *dictionary = [self.class.cache objectForKey:path];
    if (dictionary != nil) {
        return dictionary;
    }
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    if (data == nil) {
        @throw [NSException exceptionWithName:MRGArchitectParseErrorException reason:[error description] userInfo:[error userInfo]];
    }
    
    error = nil;
    dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (dictionary == nil) {
        @throw [NSException exceptionWithName:MRGArchitectParseErrorException reason:[error description] userInfo:[error userInfo]];
    }
    
    [self.class.cache setObject:dictionary forKey:path];
    return dictionary;
}

@end
