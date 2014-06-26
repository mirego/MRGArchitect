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

#import "MRGArchitectImportAction.h"
#import "MRGArchitectLoader.h"
#import "MRGArchitectExceptions.h"

@interface MRGArchitectImportAction ()

@property (nonatomic, weak) id <MRGArchitectLoader> loader;

@end

@implementation MRGArchitectImportAction

- (instancetype)initWithLoader:(id <MRGArchitectLoader>)loader
{
    if (self = [super init]) {
        _loader = loader;
    }
    return self;
}

- (NSString *)actionName
{
    return @"imports";
}

- (void)performActionWithValue:(id)actionValue onEntries:(NSMutableDictionary *)entriesToUpdate
{
    if ([actionValue isKindOfClass:[NSArray class]]) {
        NSArray *classNames = actionValue;

        for (NSString* className in classNames) {
            NSDictionary * loadedEntries = [self.loader loadEntriesWithClassName:className];
            
            NSMutableDictionary* updatedEntries = [NSMutableDictionary dictionaryWithDictionary:loadedEntries];
            [updatedEntries addEntriesFromDictionary:entriesToUpdate];

            [entriesToUpdate setDictionary:updatedEntries];
        }
    } else {
        @throw [NSException exceptionWithName:MRGArchitectUnexpectedValueTypeException reason:@"Unexpected value type encountered for an action" userInfo:[NSDictionary dictionaryWithObject:self.actionName forKey:@"actionName"]];
    }
}


@end