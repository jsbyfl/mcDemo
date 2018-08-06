
#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (instancetype)sharedInstance;

- (NSString *)createAppRootDirectory;

- (NSString *)createAppUpgradeRootDirectory;

- (NSString *)createAppPolicyRootDirectory;

- (NSString *)createDirectoryWithName:(NSString *)name rootDirectory:(NSString *)root;

- (NSString *)createFilePath:(NSString *)path;

- (NSString *)createFilePathWithFileName:(NSString *)name directory:(NSString *)directory;

@end
