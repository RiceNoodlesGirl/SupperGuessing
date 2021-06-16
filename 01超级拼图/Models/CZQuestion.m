//
//  CZQuestion.m
//  01超级拼图
//
//  Created by mac on 2021/6/7.
//

#import "CZQuestion.h"

@implementation CZQuestion
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self=[super init]){
        self.answer=dict[@"answer"];
        self.icon=dict[@"icon"];
        self.options=dict[@"options"];
        self.title=dict[@"title"];
    }
    return self;
}
+ (instancetype)questionWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
