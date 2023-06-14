#include "HideSuggestions.h"

NSUserDefaults *prefs;
BOOL enableTweak;
BOOL hideSuggestions;
BOOL enableTheming;
UIColor *backgroundColor;

%group themerGroup

%hook SPUINavigationController

	- (void)viewWillAppear: (BOOL) arg1{
		[self.view setBackgroundColor:(backgroundColor)];
		%orig;
	}

%end

%end


// THIS GROUP IS NON-FUNCTIONAL AT THE MOMENT
%group hiderGroup

%hook SPUIResultsViewController

	- (void)viewWillAppear: (BOOL) arg1{
		UIView *suggestionsView = self.view;
		while (suggestionsView.subviews.count > 0) {
			suggestionsView = suggestionsView.subviews[0];
			NSLog(@"[HideSuggestions] Subview Classes: %@", NSStringFromClass([suggestionsView class]));
			if ([NSStringFromClass([suggestionsView class]) isEqual: @"SearchUILabel"]) {
				NSLog(@"[HideSuggestions] Attempting to change text");
				
				// Very poor attempt, doesn't work
				UILabel *suggestionsLabel = (UILabel *)suggestionsView;
				[suggestionsLabel setText:@"HSFTW"];
				break;
			}
		}
		%orig;
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
		if(hideSuggestions){
			%init(hiderGroup);
		}
		if(enableTheming){
			%init(themerGroup);
		}
	}
}
