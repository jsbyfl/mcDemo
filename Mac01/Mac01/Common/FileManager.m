
#import "FileManager.h"

#import "MacroUtil.h"

@interface FileManager ()

@property (strong) NSFileManager *fileManager;

@end

@implementation FileManager

SHAREDINSTANCE(FileManager);

- (id)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config
{
    self.fileManager = [NSFileManager defaultManager];
}

- (NSString *)createAppRootDirectory
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSLocalDomainMask, false) firstObject];
    path = [path  stringByAppendingString:@"/.AllUsers/temp"];
    
    BOOL isDirectory = true;
    
    if (![self.fileManager fileExistsAtPath:path isDirectory:&isDirectory])
    {
        NSError *error;
        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
//    path = [path stringByAppendingPathComponent:@"iOACloudScmClient.EXE$"];
//    if (![self.fileManager fileExistsAtPath:path isDirectory:&isDirectory])
//    {
//        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
//    }
//
    return path ;
}

- (NSString *)createAppUpgradeRootDirectory
{
    NSString *path = [self createAppRootDirectory];
    
    BOOL isDirectory = true;
    
    path = [path stringByAppendingPathComponent:@"AppUpgrade"];
    if (![self.fileManager fileExistsAtPath:path isDirectory:&isDirectory])
    {
        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    }
    
    return path ;
}

- (NSString *)createAppPolicyRootDirectory
{
    NSString *rootDirectory = [self createAppRootDirectory];
    
    BOOL isDirectory = true;
    
    NSString *path = [rootDirectory stringByAppendingPathComponent:@"Policy"];
    
    if (![self.fileManager fileExistsAtPath:path isDirectory:&isDirectory])
    {
        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    }
    
    return path ;
}


- (NSString *)createDirectoryWithName:(NSString *)name rootDirectory:(NSString *)root
{
    NSString *path = [root stringByAppendingPathComponent:name];
    BOOL isDirectory = true;
    if (![self.fileManager fileExistsAtPath:path isDirectory:&isDirectory])
    {
        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    }
    
    return path;
}

- (NSString *)createFilePath:(NSString *)path
{
    BOOL isDirectory = false;
    if (![self.fileManager fileExistsAtPath:path isDirectory:&isDirectory])
    {
        BOOL isCreate = [self.fileManager createFileAtPath:path contents:nil attributes:nil];
        if (!isCreate)
        {
            return nil;
        }
    }
    return path;
}

- (NSString *)createFilePathWithFileName:(NSString *)name directory:(NSString *)directory
{
    NSString *path = [directory stringByAppendingString:[@"/" stringByAppendingString:name]];

    return [self createFilePath:path];
}




@end
