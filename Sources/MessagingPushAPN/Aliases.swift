import CioMessagingPush2
import Foundation

// File contains aliases to expose public classes from CioMessagingPush2 module.
// We want to avoid customers needing to ever import CioMessagingPush2 module and instead import the specific
// implementation that thier app uses (example: CioMessagingPushAPN2).

public typealias MessagingPush = CioMessagingPush2.MessagingPush
public typealias MessagingPushConfigBuilder = CioMessagingPush2.MessagingPushConfigBuilder
public typealias MessagingPushConfigOptions = CioMessagingPush2.MessagingPushConfigOptions
#if canImport(UserNotifications)
public typealias CustomerIOParsedPushPayload = CioMessagingPush2.CustomerIOParsedPushPayload
#endif
