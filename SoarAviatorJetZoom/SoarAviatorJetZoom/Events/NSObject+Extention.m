//
//  NSObject+Extention.m
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import "NSObject+Extention.h"
#import <objc/runtime.h>

@implementation NSObject (Extention)

- (NSDictionary *)jsonToDicWithJsonString:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    } else {
        return nil;
    }
}

// 1. Perform a selector after a delay
- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay {
    [self performSelector:selector withObject:nil afterDelay:delay];
}

// 2. Safely perform a selector with an optional argument
- (void)safelyPerformSelector:(SEL)selector withObject:(id)object {
    if ([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL, id) = (void *)imp;
        func(self, selector, object);
    }
}

// 3. Convert object to JSON string
- (NSString *)toJSONString {
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    return error ? nil : [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// 4. Associate an object to self
- (void)setAssociatedObject:(id)object forKey:(const void *)key {
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 5. Retrieve associated object
- (id)getAssociatedObjectForKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

// 6. Check if the object responds to a selector
- (BOOL)canPerformSelector:(SEL)selector {
    return [self respondsToSelector:selector];
}

// 7. Execute a block on the main thread
- (void)performBlockOnMainThread:(void (^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

// 8. Execute a block in the background
- (void)performBlockInBackground:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

// 9. Swizzle instance methods
+ (void)swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

// 10. Print all properties and values of the object
- (void)logPropertiesAndValues {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableString *logString = [NSMutableString stringWithFormat:@"\nProperties of %@:\n", [self class]];
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id value = [self valueForKey:propertyName];
        [logString appendFormat:@"%@: %@\n", propertyName, value];
    }
    free(properties);
    NSLog(@"%@", logString);
}

@end
