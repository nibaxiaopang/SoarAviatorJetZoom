//
//  PulseADataInstance.h
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, StrikeUUidType)
{
    StrikeUUidTypeT = 0,
    StrikeUUidTypeW,
    StrikeUUidTypeN,
};

@interface AviatorUUidInstance : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSDictionary *eventParams;
@property (nonatomic, assign) StrikeUUidType type;
@property (nonatomic, copy) NSString *typeStr;

- (NSString *)airGetUUID;

- (NSString *)eventTokenWithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
