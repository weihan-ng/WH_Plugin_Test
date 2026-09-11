//QmsPlugin.h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QmsPluginUI : NSObject

+ (UIViewController *)makeViewController;

/// Same as makeViewController but pre-loads the given credentials so the
/// ProjectViewController receives clientID, clientCode, userToken, and isOrigin
/// immediately — useful for the testApp debug harness.
+ (UIViewController *)makeViewControllerWithClientID:(NSString *)clientID
                                          clientCode:(NSString *)clientCode
                                           userToken:(NSString *)userToken
                                            isOrigin:(BOOL)isOrigin;

/// Fetches project list data and presents DashboardViewController fully configured
/// for the given FCM deep-link payload. The payload must contain at minimum
/// `project_id` and `plan_id`. Auth/base-URL must already be configured in APIConfig
/// (i.e. the SDK has already been initialised by the user opening the app).
///
/// @param payload  The FCM notification data dictionary.
/// @param presenter The view controller from which the dashboard will be presented modally.
+ (void)presentDashboardFromPayload:(NSDictionary *)payload
                 fromViewController:(UIViewController *)presenter;

/// Configures APIConfig with the project/plan context from the payload, then
/// presents AppointmentDetailsViewController modally. The payload must contain
/// `project_id`, `plan_id`, and `appointment_id` (or `id` as a fallback).
/// Auth/base-URL must already be configured in APIConfig.
///
/// @param payload  The FCM notification data dictionary.
/// @param presenter The view controller from which the appointment screen will be presented.
+ (void)presentAppointmentFromPayload:(NSDictionary *)payload
                   fromViewController:(UIViewController *)presenter;

/// Fetches the issue list, finds the matching issue by `issue_id` from the payload,
/// and presents IssueDetailViewController fully configured. The payload must contain
/// at minimum `project_id`, `plan_id`, and `issue_id`. Auth/base-URL must already
/// be configured in APIConfig.
///
/// @param payload  The FCM notification data dictionary.
/// @param presenter The view controller from which the issue screen will be presented.
+ (void)presentIssueFromPayload:(NSDictionary *)payload
             fromViewController:(UIViewController *)presenter;

/// Handles a draft_reminder notification tap. Checks whether the notification's
/// account_id matches the active account — switches if needed — then presents
/// DraftListingViewController filtered to the given project name.
/// AccountManager and DraftListingViewController are both inside the framework
/// so all logic is self-contained here.
///
/// @param payload  The notification userInfo dict (must contain `project_name` and `account_id`).
/// @param presenter The view controller from which the listing will be presented.
+ (void)presentDraftListingFromPayload:(NSDictionary *)payload
                    fromViewController:(UIViewController *)presenter;

@end

NS_ASSUME_NONNULL_END
