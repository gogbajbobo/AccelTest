UDPushAuth
==========

Установка
---
`pod 'UDPushAuth', :git => 'https://github.com/Unact/UDPushAuth.git', :branch => 'master'`

Настройка
---
Необходимо создать класс, унаследованный от UDOAuthBasicAbstract, например UDOAuthBasic.
И реализовать методы 

- `(NSString *) reachabilityServer` - возвращает адрес сервера для проверки доступности
- `+ (id) tokenRetrieverMaker` - возвращает сконфигурированный класс, отвечающий протоколу UDAuthTokenRetrievable

```
#import "UDOAuthBasic.h"
#define TOKEN_SERVER_URL @"system.unact.ru"
#define AUTH_SERVICE_URI @"https://system.unact.ru/asa"

@implementation UDOAuthBasic

- (NSString *) reachabilityServer{
    return TOKEN_SERVER_URL;
}

+ (id) tokenRetrieverMaker{
    UDAuthTokenRetriever *tokenRetriever = [[UDAuthTokenRetriever alloc] init];
    tokenRetriever.authServiceURI = [NSURL URLWithString:AUTH_SERVICE_URI];
    
    UDPushAuthCodeRetriever *codeRetriever = [UDPushAuthCodeRetriever codeRetriever];
    codeRetriever.requestDelegate.uPushAuthServiceURI = [NSURL URLWithString:AUTH_SERVICE_URI];
#if DEBUG
    [(UDPushAuthRequestBasic *)[codeRetriever requestDelegate] setConstantGetParameters:@"_host=hqvsrv73&app_id=pushauth-dev&_svc=a/UPushAuth/"];
#else
    [(UDPushAuthRequestBasic *)[codeRetriever requestDelegate] setConstantGetParameters:@"_host=hqvsrv73&app_id=pushauth&_svc=a/UPushAuth/"];
#endif
    tokenRetriever.codeDelegate = codeRetriever;
    
    return tokenRetriever;
}
```

Затем добавить в AppDelegate

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.pushNotificatonCenter = [UDPushNotificationCenter sharedPushNotificationCenter];
    self.authCodeRetriever = (UDPushAuthCodeRetriever *)[(UDAuthTokenRetriever *)[[UDOAuthBasic sharedOAuth] tokenRetriever] codeDelegate];
    self.reachability = [Reachability reachabilityWithHostname:[[UDOAuthBasic sharedOAuth] reachabilityServer]];
    self.reachability.reachableOnWWAN = YES;
    [self.reachability startNotifier];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [self.authCodeRetriever registerDeviceWithPushToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{    
    [self.pushNotificatonCenter processPushNotification:userInfo];
}
```

Использование
---
AuthToken доступен через свойство tokenValue класса UDOAuthBasicAbstract.
Конкретные варианты использования токена реализуюися в наследниках UDOAuthBasicAbstract.

Пример реализации субкласса - UDOAuthBasic (не поставляется в составе cocoapods библиотеки).
UDOAuthBasic реализует совместимость с версией 0.1

`[[UDOAuthBasic sharedOAuth] authenticateRequest:(NSURLRequest *) request]` -
Возвращает аутентифицированный NSURLRequest или nil, если аутентификация невозможна.
