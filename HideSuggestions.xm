#include "HideSuggestions.h"

NSUserDefaults *prefs;
BOOL enableTweak;
BOOL hideSuggestions;
BOOL enableTheming;
UIColor *backgroundColor;
NSString *siriSuggestionsText;

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

%hook SearchUILabel
	-(void)setText: (NSString *) arg1{
		if ([arg1 isEqual:@"Siri Suggestions"]) {
			NSString *newText = siriSuggestionsText;
			%orig(newText);
		} else {
			%orig;
		}
		
	}
%end

%hook SPUIResultsViewController

	- (void)viewDidAppear: (BOOL) arg1{
		[self iterateThroughSubviews:self.view];
		%orig;
	}
	%new
	- (void)iterateThroughSubviews: (UIView *) view{
		for (UIView *subview in view.subviews) {
			if ([NSStringFromClass([subview class]) isEqual: @"SearchUICardSectionCollectionViewCell"]) {
				view.hidden = YES;
			} else {
				[self iterateThroughSubviews:subview];
			}
		}
	}

%end

%end

void updatePrefs(){
	[prefs registerDefaults:@{
		@"enableTweak": @FALSE,
		@"hideSuggestions": @FALSE,
		@"enableTheming": @FALSE,
		@"backgroundColor": @"#ffffffff",
		@"siriSuggestionsText": @"Siri Suggestions",
	}];

	enableTweak = [[prefs objectForKey:@"enableTweak"] boolValue];
	hideSuggestions = [[prefs objectForKey:@"hideSuggestions"] boolValue];
	enableTheming = [[prefs objectForKey:@"enableTheming"] boolValue];
	backgroundColor = [GcColorPickerUtils colorFromDefaults:@"one.keycap.hidesuggestionsprefs" withKey:@"backgroundColor" fallback:@"ffffffff"];
	siriSuggestionsText = [prefs objectForKey:@"siriSuggestionsText"];
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
