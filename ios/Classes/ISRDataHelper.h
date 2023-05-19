//
//  ISRDataHelper.h
//  speech_xf
//
//  Created by jia shi on 2023/5/19.
//

#ifndef ISRDataHelper_h
#define ISRDataHelper_h

#import <Foundation/Foundation.h>

@interface ISRDataHelper : NSObject

/**
 parse JSON data
 **/
+ (NSString *)stringFromJson:(NSString*)params;//


/**
 parse JSON data for cloud grammar recognition
 **/
+ (NSString *)stringFromABNFJson:(NSString*)params;

@end


#endif /* ISRDataHelper_h */
