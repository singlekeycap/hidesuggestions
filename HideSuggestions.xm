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


// Hider is still broken, will fix later
%group hiderGroup

%hook SearchUICollectionView

- (NSInteger)numberOfItemsInSection: (NSInteger) arg1{
	if (arg1 == 1) {
		return 0;
	} else {
		return %orig;
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
	backgroundColor = [GcColorPickerUtils colorFromDefaults:@"one.keycap.hidesuggestions" withKey:@"backgroundColor" fallback:@"ffffffff"];
	enableCellColor = [[prefs objectForKey:@"enableCellColor"] boolValue];
	cellColor = [GcColorPickerUtils colorFromDefaults:@"one.keycap.hidesuggestions" withKey:@"cellColor" fallback:@"ffffffff"];
	enableSiriSuggestionsText = [[prefs objectForKey:@"enableSiriSuggestionsText"] boolValue];
	siriSuggestionsText = [prefs objectForKey:@"siriSuggestionsText"];
}

%ctor {
	prefs = [[NSUserDefaults alloc] initWithSuiteName:@"one.keycap.hidesuggestions"];
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
