//
//  NSObject+Extention.h
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Extention)

// 1. Perform a selector after a delay
- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay;

// 2. Safely perform a selector with an optional argument
- (void)safelyPerformSelector:(SEL)selector withObject:(id)object;

// 3. Convert object to JSON string
- (NSString *)toJSONString;

// 4. Associate an object to self
- (void)setAssociatedObject:(id)object forKey:(const void *)key;

// 5. Retrieve associated object
- (id)getAssociatedObjectForKey:(const void *)key;

// 6. Check if the object responds to a selector
- (BOOL)canPerformSelector:(SEL)selector;

// 7. Execute a block on the main thread
- (void)performBlockOnMainThread:(void (^)(void))block;

// 8. Execute a block in the background
- (void)performBlockInBackground:(void (^)(void))block;

// 9. Swizzle instance methods
+ (void)swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

// 10. Print all properties and values of the object
- (void)logPropertiesAndValues;

- (NSDictionary *)jsonToDicWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
