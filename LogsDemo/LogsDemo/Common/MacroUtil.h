
#ifdef __OBJC__

#ifdef DEBUG
#define TXLog(fmt,...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define TXLog(fmt,...) //NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#define SHAREDINSTANCE(clsname) \
+ (instancetype) sharedInstance \
{ \
    static clsname *sharedInstance = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        sharedInstance = [[clsname alloc] init]; \
    }); \
    return sharedInstance; \
}


#endif /* MacroUtil_h */
