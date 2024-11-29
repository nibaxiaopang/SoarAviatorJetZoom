//
//  PulseADataInstance.m
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import "AviatorUUidInstance.h"
#import <Security/Security.h>

@interface AviatorUUidInstance ()

@property (nonatomic, strong) NSString *keychainKey;

@end
@implementation AviatorUUidInstance

+ (instancetype)sharedInstance {
    static AviatorUUidInstance *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialization code here
        self.keychainKey = [[NSBundle mainBundle] bundleIdentifier];
    }
    return self;
}

- (void)setTypeStr:(NSString *)typeStr
{
    _typeStr = typeStr;
    if ([typeStr isEqualToString:@"wj"]) {
        self.type = StrikeUUidTypeW;
    } else if ([typeStr isEqualToString:@"9f"]) {
        self.type = StrikeUUidTypeN;
    } else {
        self.type = StrikeUUidTypeT;
    }
}

- (NSString *)eventTokenWithKey:(NSString *)key
{
    return [self.eventParams objectForKey:key];
}

#pragma mark - uuid
- (NSString *)airGetUUID {
    NSString *uuid = [self getUUIDFromKeychain];
    if (uuid) {
        return uuid;
    } else {
        uuid = [[NSUUID UUID] UUIDString];
        [self saveUUIDToKeychain:uuid];
        return uuid;
    }
}

- (NSString *)getUUIDFromKeychain {
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount: self.keychainKey,
                            (__bridge id)kSecReturnData: (__bridge id)kCFBooleanTrue,
                            (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne};

    CFTypeRef item = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &item);

    if (status == errSecSuccess) {
        NSData *data = (__bridge_transfer NSData *)item;
        NSString *uuid = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return uuid;
    }
    return nil;
}

- (void)saveUUIDToKeychain:(NSString *)uuid {
    NSData *data = [uuid dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount: self.keychainKey};

    SecItemDelete((__bridge CFDictionaryRef)query);
    NSMutableDictionary *newQuery = [query mutableCopy];
    newQuery[(__bridge id)kSecValueData] = data;

    SecItemAdd((__bridge CFDictionaryRef)newQuery, NULL);
}

@end
