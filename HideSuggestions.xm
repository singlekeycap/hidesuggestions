#include "HideSuggestions.h"

NSUserDefaults *prefs;
BOOL enableTweak;
BOOL hideSuggestions;
BOOL enableTheming;
UIColor *backgroundColor;

%group spotlightTheming

%hook SBHomeScreenSpotlightViewController
   -(void)viewWillAppear:(BOOL)arg1{
        if(enableTheming){
            [self.viewIfLoaded setBackgroundColor:(backgroundColor)];
		}
        return %orig;
    }
%end

%hook SPUIRemoteSearchViewController
	-(void)viewWillAppear:(BOOL)arg1{
		if(hideSuggestions){
			NSLog(@"[HideSuggestions] Spotlight children views: %@", self.viewIfLoaded.subviews);
		}
		return %orig;
	}

%end

%end

void updatePrefs(){
	[prefs registerDefaults:@{
		@"enableTweak": @FALSE,
		@"hideSuggestions": @FALSE,
		@"enableTheming": @FALSE,
		@"backgroundColor": @"#ffffffff"
	}];

	enableTweak = [[prefs objectForKey:@"enableTweak"] boolValue];
	hideSuggestions = [[prefs objectForKey:@"hideSuggestions"] boolValue];
	enableTheming = [[prefs objectForKey:@"enableTheming"] boolValue];
	backgroundColor = [GcColorPickerUtils colorFromDefaults:@"one.keycap.hidesuggestionsprefs" withKey:@"backgroundColor" fallback:@"ffffffff"];
}

%ctor {
	prefs = [[NSUserDefaults alloc] initWithSuiteName:@"one.keycap.hidesuggestionsprefs"];
	updatePrefs();

	if(enableTweak){
		%init(spotlightTheming);
	}
}
