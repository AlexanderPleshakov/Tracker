#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"ru.AlexanderPleshakov.Tracker";

/// The "TBlue" asset catalog color resource.
static NSString * const ACColorNameTBlue AC_SWIFT_PRIVATE = @"TBlue";

/// The "AddButton" asset catalog image resource.
static NSString * const ACImageNameAddButton AC_SWIFT_PRIVATE = @"AddButton";

/// The "AddTracker" asset catalog image resource.
static NSString * const ACImageNameAddTracker AC_SWIFT_PRIVATE = @"AddTracker";

/// The "BlueImage" asset catalog image resource.
static NSString * const ACImageNameBlueImage AC_SWIFT_PRIVATE = @"BlueImage";

/// The "DoneTracker" asset catalog image resource.
static NSString * const ACImageNameDoneTracker AC_SWIFT_PRIVATE = @"DoneTracker";

/// The "Logo" asset catalog image resource.
static NSString * const ACImageNameLogo AC_SWIFT_PRIVATE = @"Logo";

/// The "RedImage" asset catalog image resource.
static NSString * const ACImageNameRedImage AC_SWIFT_PRIVATE = @"RedImage";

/// The "ResetTextField" asset catalog image resource.
static NSString * const ACImageNameResetTextField AC_SWIFT_PRIVATE = @"ResetTextField";

/// The "StubImage" asset catalog image resource.
static NSString * const ACImageNameStubImage AC_SWIFT_PRIVATE = @"StubImage";

/// The "TCheckmark" asset catalog image resource.
static NSString * const ACImageNameTCheckmark AC_SWIFT_PRIVATE = @"TCheckmark";

/// The "TabStatistic" asset catalog image resource.
static NSString * const ACImageNameTabStatistic AC_SWIFT_PRIVATE = @"TabStatistic";

/// The "TabTracks" asset catalog image resource.
static NSString * const ACImageNameTabTracks AC_SWIFT_PRIVATE = @"TabTracks";

#undef AC_SWIFT_PRIVATE
