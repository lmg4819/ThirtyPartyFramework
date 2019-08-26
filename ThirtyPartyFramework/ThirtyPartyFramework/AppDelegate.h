//
//  AppDelegate.h
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/*

 OHHTTPStub : 测试您的应用程序与虚假的网络数据和自定义的响应时间，响应代码和报头!
 TTGTagCollectionView : 标签流显示控件，同时支持文字或自定义View
 HCSStarRatingView : 简单的星级评级视图
 VTMagic : 一个用于iOS的页面容器库
 
 */
@end


/*
 apm.ssuid
 
 NSString *fullSpm = [NSString stringWithFormat:@"%@.%@", ANALYTICS_PAYSUCCESS_CLICK_SSU_GOTODETAIL, [NSObject mcObjectToString:ssuModel.ssu_id]];
 
 
 首页清单埋点：
 [MCStatisticsManager clickHomeWithSpm:MCInventoryHomeClickInventory];
 
 
 #import "MCStatisticsManager+ToB.h"
 
 埋点
 
 ServiceIconInGC
 
 
 
 
 UIKIT_EXTERN NSString *const MCHomeClickTheMapCell;           // 首页-配送中地图-点击
 UIKIT_EXTERN NSString *const MCHomeClickServiceIconInGC;      // 首页-联系客服-点击icon
 UIKIT_EXTERN NSString *const MCHomeCloseExclusiveSales;      // 首页-关闭专属销售tips
 UIKIT_EXTERN NSString *const MCHomeCorrectAddressFloatWindowShow;  // 纠正地址浮窗模块曝光
 UIKIT_EXTERN NSString *const MCHomeCorrectAddressFloatWindowToMakeSure;//纠正地址浮窗-去确认
 UIKIT_EXTERN NSString *const MCHomeEvaluationFloatPresentation;//首页-评价浮层-展示
 UIKIT_EXTERN NSString *const MCHomeEvaluationFloatChooseSatisfy;//首页-评价浮层-点击满意
 UIKIT_EXTERN NSString *const MCHomeEvaluationFloatChooseUnSatidfy;//首页-评价浮层-点击不满意
 UIKIT_EXTERN NSString *const MCHomeEvaluationFloatChooseCustom;//首页-评价浮层-点击我还有话说
 UIKIT_EXTERN NSString *const MCHomeEvaluationFloatClose;//首页-评价浮层-点击关闭
 
 
 latitude:39.978849
 longitude:116.40727
 
 
 
 订单详情页
 [MCStatisticsManager clickOrderDetailWithSpm:MCOrderScoreConvertInOD];
 检疫证明按钮点击跳转对应 H5 页（267 新增）
 
 
 订单列表
  [MCStatisticsManager clickOrderListWithSpm:spm params:@{@"order_id": [NSObject mcObjectToString:self.model.order_id]}];
 
 //点击售后详情-订单列表页按钮
 UIKIT_EXTERN NSString *const MCOrderListClickAfterSalesDetail;
 //订单列表页-点击“评价详情”
 UIKIT_EXTERN NSString *const MCOrderListClickEvaluateDetail;
 //查看物流
 UIKIT_EXTERN NSString *const MCOrderListCheckTheLogistics;
 //再次购买
 UIKIT_EXTERN NSString *const MCOrderListBugAgain;
 //立即评价
 UIKIT_EXTERN NSString *const MCOrderListEvaluateImmediately;
 //取消订单
 UIKIT_EXTERN NSString *const MCOrderListCancelOrder;
 //申请售后
 UIKIT_EXTERN NSString *const MCOrderListApplyForAfterSales;
 //退款进度
 UIKIT_EXTERN NSString *const MCOrderListProgressForRefund;
 //订单列表页检疫证明按钮点击
 UIKIT_EXTERN NSString *const MCOrderListQuarantineCertificate;
 
 
 MCOrderListBugAgain
 
 
 NSString *spm = [NSString stringWithFormat:@"%@.%@", MCContactDriverForDeliveryInfoInOD,self.orderDetailModel.orderID];
 
 */
/*
 个人基本情况
 价值观
 进来后的工作业绩
 工作规划
 
 */
