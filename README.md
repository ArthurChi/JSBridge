# JSBridge
make iOS and Android work in a same way

## Why use this
Over time, the number of hybrid app is increasing. what we have to do is interact with javascript. Developer can use interface to do that in Android platform. so I believe that there must be a way to interact with javascript in iOS like Android. In other word, I want to make iOS and Android work in a same way.
## How to use
First, you need to register a object with a alias same to Android platform.</br>
In this case, class Person have complied a protocol which inherit JSExport. Then you can use object `person` in your javascript.
```
Person* p = [Person createWithFirstName:@"123" lastName:@"abc"];
    [_webView.bridge registerObject:p alias:@"person"];
```

## Cocos Pod
pod 'JSBridge'


