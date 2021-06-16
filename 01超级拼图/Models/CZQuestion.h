//
//  CZQuestion.h
//  01超级拼图
//
//  Created by mac on 2021/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZQuestion : NSObject

@property(nonatomic,copy)NSString *answer;//安全起见，不想改变用copy
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSArray *options;//想要改变就用strong

//这两个方法背住
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)questionWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
