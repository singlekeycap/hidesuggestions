#include "HideSuggestions.h"

NSUserDefaults *prefs;
BOOL enableTweak;
BOOL hideSuggestions;
BOOL enableBackgroundColor;
BOOL enableCellColor;
BOOL enableSiriSuggestionsText;
UIColor *backgroundColor;
UIColor *cellColor;
NSString *siriSuggestionsText;

%group themerGroup

%hook SearchUILabel
	-(void)setText: (NSString *) arg1{
		if ([arg1 isEqual:@"Siri Suggestions"] && enableSiriSuggestionsText) {
			NSString *newText = siriSuggestionsText;
			%orig(newText);
		} else {
			%orig;
		}
		
	}
%end

%hook SPUINavigationController

	- (void)viewWillAppear: (BOOL) arg1{
		if (enableBackgroundColor) {
			[self.view setBackgroundColor:(backgroundColor)];
		}
		%orig;
	}

%end

%hook SearchUICardSectionCollectionViewCell

	- (void)setBackgroundColor: (UIColor *) arg1{
		if (enableCellColor) {
			UIColor *newColor = cellColor;
			%orig(newColor);
		} else {
			%orig;
		}
	}

%end

%end

%group hiderGroup

%hook SearchUIResultsCollectionViewController

	- (void)viewDidAppear: (BOOL) arg1{
		// [self iterateThroughSubviews:self.view];
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
		@"enableBackgroundColor": @FALSE,
		@"backgroundColor": @"#ffffffff",
		@"enableCellColor": @FALSE,
		@"cellColor": @"#ffffffff",
		@"enableSiriSuggestionsText": @FALSE,
		@"siriSuggestionsText": @"Siri Suggestions",
	}];

	enableTweak = [[prefs objectForKey:@"enableTweak"] boolValue];
	hideSuggestions = [[prefs objectForKey:@"hideSuggestions"] boolValue];
	enableBackgroundColor = [[prefs objectForKey:@"enableBackgroundColor"] boolValue];
	backgroundColor = [GcColorPickerUtils colorFromDefaults:@"one.keycap.hidesuggestionsprefs" withKey:@"backgroundColor" fallback:@"ffffffff"];
	enableCellColor = [[prefs objectForKey:@"enableCellColor"] boolValue];
	cellColor = [GcColorPickerUtils colorFromDefaults:@"one.keycap.hidesuggestionsprefs" withKey:@"cellColor" fallback:@"ffffffff"];
	enableSiriSuggestionsText = [[prefs objectForKey:@"enableSiriSuggestionsText"] boolValue];
	siriSuggestionsText = [prefs objectForKey:@"siriSuggestionsText"];
}

%ctor {
	prefs = [[NSUserDefaults alloc] initWithSuiteName:@"one.keycap.hidesuggestionsprefs"];
	updatePrefs();

	if(enableTweak){
		if(hideSuggestions){
			%init(hiderGroup);
		}
		if(enableBackgroundColor | enableCellColor | enableSiriSuggestionsText){
			%init(themerGroup);
		}
	}
}
