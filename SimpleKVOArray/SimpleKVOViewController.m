//
//  ViewController.m
//  SimpleKVOArray
//
//  Created by Dan Zinngrabe on 8/30/14.
//  Copyright (c) 2014 Dan Zinngrabe. All rights reserved.
//

#import "SimpleKVOViewController.h"

@interface SimpleKVOViewController ()
@property   (nonatomic, strong) NSMutableArray  *items;
@end

@implementation SimpleKVOViewController
@synthesize items;

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])){
        items = [[NSMutableArray alloc] init];
        // Start observing. Do this wherever makes sense in your implementation.
        // Adding observers should always be balanced with a removal at the appropriate point in the instance's life cycle.
        [self beginObservingValuesForKeyPaths:[self observedKeyPaths] options:[self observationOptions]];
    }
    return self;
}

- (void) dealloc {
    // Remove the observer
    [self endObservingValuesForKeysPaths:[self observedKeyPaths]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

- (IBAction)addButtonPressed:(id)sender {
    NSMutableArray  *array  = nil;
    
    // Notice that you do not have to implement the KVC collections accessors.
    // The system does it for you for declared properties.
    array = [self mutableArrayValueForKey:@"items"];
    [array addObject:@"foo"];
    
    // An alternative is to bracket the change to the property with the KVO notification methods
    
    /**
    [self willChangeValueForKey:@"items"];
    [[self items] addObject:@"foo"];
    [self didChangeValueForKey:@"items"];
    */
}

#pragma mark KVO

- (NSSet *) observedKeyPaths {
	return [NSSet setWithArray:@[@"items"]];
}

- (NSKeyValueObservingOptions) observationOptions {
    return (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld);
}

- (void) beginObservingValuesForKeyPaths:(id<NSFastEnumeration>)keyPaths options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths){
        [self addObserver:self forKeyPath:keyPath options:options context:(void *)self];
    }
}

- (void) endObservingValuesForKeysPaths:(id<NSFastEnumeration>)keyPaths {
    for (NSString *keyPath in keyPaths){
        [self removeObserver:self forKeyPath:keyPath context:(void *)self];
    }
}

- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    if (context == (__bridge void *)self){
        if ([[self observedKeyPaths] containsObject:keyPath]){
            [self showAlertWithChanges:change];
        }
    } else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
        
    }
}

#pragma mark Alert

- (void) showAlertWithChanges:(NSDictionary *)changes {
    UIAlertView *alert  = nil;
    alert = [[UIAlertView alloc] initWithTitle:@"Changes" message:[changes description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
