//
//  APIDefine.h
//  TXProject
//
//  Created by Sam on 2018/12/25.
//  Copyright © 2018年 sam. All rights reserved.
//

#ifndef APIDefine_h
#define APIDefine_h


#define AVATAR_HOST_URL @"https://app.tianxun168.com"

#define TX_HOST_URL @"https://app.tianxun168.com/api/sh/"

#define LOGIN_URL @"account/sign_in"

#define LOGIN_SEND_CODE @"account/sendSms"

#define ACCOUT_CHANGE_PWD @"account/reset_password_by_id"

#define REGISTER_USER @"account/phone_register"

#define WEB_HOST_URL @"https://app.tianxun168.com/h5/ios_app.html#/"

#define COMMERCE_LIST @"chamber/get_user_chamber_info"

#define GROUND_SCROLL_IMAGE @"common/get_advert_img"

#define ENTRE_LIST_DATA @"profession/list_msg_focus"

#define COMMERCE_DETAIL @"common/load_commerce_detail_by_id"

#define HOME_SCROLL_IMAGE @"common/get_recycle_img"


#define HOME_SHOP_CYCLE @"ios_app.html#/member/moment_index"

#define SH_URL_GET_APPSTORE @"https://itunes.apple.com/lookup"

#define SH_FRIEND_NUMBER @"moments/moment_count"

#define SH_GET_INFO_NUMBER @"moments/system_count"

#define SH_MINE_MESSAGE @"account/get_member_account"

#define SH_COMMERCE_ARRAY @"chamber/get_user_chamber_info"

#define SH_CHANGE_COMMERCE @"account/saveCommerce"

#define SH_SAVE_USER_DATA @"account/update_member_account"

#define SH_UPLOAD_AVATAR @"ios/uploadIosAvatar"

#define SH_GET_IM_TOKEN @"chat/refreshToken"

#define SH_GET_COMMERCE_MEMBER_LIST @"common/get_commerce_list_member_by_commerce_id"

#define SH_GET_MEMBERS_MESSAGE @"common/getMemberNameByIds"

#define SH_DETAIL_NEWS @"news/detailCommerceNews"
#define SH_LIST_NEWS @"news/listCommerceNews"
#define SH_NOTIFY_MESSAGE @"notify/get_secretary_notify"

#define SH_COMMERCE_DETAIL @"common/load_commerce_detail_by_id"

#define SH_LIST_CHUANGYE @"profession/list_msg_focus"

#define SH_ENTRE_LIST_DETAIL @"profession/detail_msg_focus"

#define SH_SEARCH_COMMERCE_LIST @"common/get_member_search_list_by_search_type"

#define SH_COMPANY_LIST @"common/listCommonBindEnterprise"

#define SH_SHOW_WEB @"secretary/appChangeDisplay"

#define SH_EDUCATION_NUMBER @"common/count_db_info"

#define SH_SERVER_LIST @"profession/list_msg_focus"

#define SH_SCHOOL_LIST @"academy/list_academy"

#define SH_BAODIAN_ALL @"pioneer_park/search_revered_new"
#define SH_ZONGHE_ALL @"service/search_service_new"

#define SH_WEB_DETAIL @"profession/detail_msg_focus"

#define SH_HOME_COMMERCES @"common/get_common_info_with_page"
#define SH_GET_AREA @"common/getArea"
#define SH_GET_NEWS_LIST @"survey/list_new_policy"
#define SH_GET_NEWS_DETAIL @"survey/detail_new_policy"
#define SH_ADD_COMMERCE @"member/add_application"
#define SH_CREATE_COMMERCE @"member/create_commerce"
#define SH_ENTRE_DETAIL @"pioneer_park/detail_revered"
#define SH_SERVICE_DETAIL @"service/detail_service"
#define SH_LOAD_INFO @"member/preLoadMemberInfo"

#define SH_UPLOAD_SERVICE @"pioneer_park/addUpdatePioneerPark"
#define SH_UPLOAD_ZONGHE @"service/addUpdateIntegrateService"

#define SH_PRICE_PAY @"price/getAdPrice"

#define SH_COMPANY_LIST @"common/listCommonBindEnterprise"

#define SH_DETAIL_COMPANY @"enterprise/detail_enterprise"
#define SH_COMPANY_DEFAULT @"enterprise/handleEnterprise"
#define SH_UPDATE_COMPANY @"enterprise/addUpdateEnterprise"
#define SH_CREAT_ORDER @"price/createOrderPay"


#define SH_MEMBER_DETAIL @"common/load_member_detail_by_id"
#define SH_MOMENTS_DATA @"moments/get_member_moment_count"
#define SH_ADD_FRIENDS @"moments/apply_friends"
#define SH_DELETE_FRIENDS @"moments/delete_friends"

#define SH_FRIEND_LIST @"moments/get_friends_list"

#define SH_UPLOAD_ENTREPRISE_LOGO @"enterprise/upload_enterprise_logo"

#define SH_APPLE_FRIENDS @"moments/get_apply_friends_list"
#define SH_HANDLE_FRIENDS @"moments/handle_friends"
#define SH_CHECK_PAY_SERVICE @"pioneer_park/trackTheOrder"
#define SH_CHECK_PAY_ZONGHE @"pioneer_park/trackTheOrderSynthesis"

#define SH_INVESTMENT_LIST @"merchants/merchants_list"
#define SH_MOTION_LIST @"common/list_collection"
#define SH_INVESTMEMT_DETAIL @"merchants/merchants_detail"

#define SH_STUDENT_JOB_LIST @"common/list_demand_talent"

#define SH_SHOW_MESSAGE @"merchants/merchants_show_message"

#define SH_ADD_MESSAGE @"merchants/merchants_add_message"

#define SH_ADD_COLLECTION @"common/add_collection"
#define SH_DELETE_COLLECTION @"common/delete_collection"

#define SH_GET_VERSION @"common/getVersionsControl"

#define SH_JOB_STU_DETAIL @"common/detail_demand_talent"

#define SH_OTHER_JOB @"common/list_demand_talent"

#define SH_COMMENT_REPAY @"demand/replayComments"

#define SH_COMMENT_LIST @"demand/listCommentsNew"

#define SH_PRODUCTION_LIST @"common/list_demand_product"

#define SH_FILE_LIST @"common/listFile"
#define SH_FILE_PREVIEW @"common/getPreviewFile"
#define SH_DETAIL_FILE @"common/detailFile"
#define SH_LIST_COMMENTS @"common/listComments"
#define SH_REPAY_COMMENTS @"common/ratingMessage"

#define SH_ADD_TALENT @"demand/addUpdateTalent"
#define SH_HANDLE_TALENT @"demand/handleDemand"
#define SH_DETAIL_TALENT @"common/detail_demand_talent"
#define SH_PROJECT_DETAIL @"common/detail_demand_product"
#define SH_PRODUCT_COMMENTS @"demand/listComments"
#define SH_ADD_PRODUCTION @"demand/addUpdateProduct"



#define SH_TUIJIAN_JOB @"common/list_demand_talent"
#define SH_NEWS_POST_HOME @"common/list_demand_technology"

#define SH_SCHOOL_DETAIL @"academy/detail_academy"
#define SH_STUDENT_DETAIL @"student/detail_student"
#define SH_TEACHER_DETAIL @"expert/detail_expert_info"


#define SH_NEW_GET_AREA @"commerce_work/getRegion"


#define SH_LIKE_SERVICE @"pioneer_park/pioneerParkRatingService"

////产教融接口
#define SH_LIST_STUDENT_EDU @"student/list_student"
#endif /* APIDefine_h */
