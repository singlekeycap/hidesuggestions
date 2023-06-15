#include "HSRootListController.h"

NSUserDefaults *prefs;
NSArray *rootPreferenceKeys;

@implementation HSRootListController
	-(id)init {
		prefs = [[NSUserDefaults alloc] initWithSuiteName:@"one.keycap.hidesuggestionsprefs"];
		rootPreferenceKeys = @[
			@"enableTweak",
			@"hideSuggestions",
			@"enableBackgroundColor",
			@"backgroundColor",
			@"enableCellColor",
			@"cellColor",
			@"enableSiriSuggestionsText",
			@"siriSuggestionsText"
		];
		return [super init];
	}

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		}
		return _specifiers;
	}

	-(void)respring {
		pid_t pid;
		const char* args[] = {"killall", "-9", "backboardd", NULL};
		posix_spawn(&pid, ROOT_PATH("/usr/bin/killall"), NULL, NULL, (char* const*)args, NULL);
	}
	-(void)askBeforeRespring {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to respring?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* respringAction = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
			[self respring];
		}];
		UIAlertAction* laterAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
		[alert addAction:respringAction];
		[alert addAction:laterAction];
		[self presentViewController:alert animated:YES completion:nil];
	}

	- (void) twtKeycap {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/singlekeycap"] options:@{} completionHandler:nil];
	}

	- (void) twtSneethan {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/realsneethan"] options:@{} completionHandler:nil];
	}

	- (void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(askBeforeRespring)];
		self.navigationItem.rightBarButtonItem = respringButton; 
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier{
		[super setPreferenceValue:value specifier:specifier];
	}

@end