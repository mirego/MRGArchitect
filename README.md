# MRGArchitect

[![CI Status](https://travis-ci.org/mirego/MRGArchitect.svg?branch=master)](https://travis-ci.org/mirego/MRGArchitect)
[![Version](https://img.shields.io/cocoapods/v/MRGArchitect.svg?style=flat)](http://cocoadocs.org/docsets/MRGArchitect)
[![License](https://img.shields.io/cocoapods/l/MRGArchitect.svg?style=flat)](http://cocoadocs.org/docsets/MRGArchitect)
[![Platform](https://img.shields.io/cocoapods/p/MRGArchitect.svg?style=flat)](http://cocoadocs.org/docsets/MRGArchitect)

## How to use it

### First things first

- Add `MRGArchitect` in your `Podfile`
- Run `pod install` in your terminal at the root of your project

### Simple way

Say you want properties for your `LoginView`. Create a `LoginView.json` file and add properties for your view inside a JSON object.

Instantiate your `MRGArchitect` in your `LoginView.m` and keep it in a member variable like so :
```objc
  self.architect = [MRGArchitect architectForObject:self];
```


From now on you are able to retrieve properties from your JSON file with `MRGArchitect`’s helpers like so :
```objc
  // returns BOOL
  [self.architect boolForKey:@"boolKey"];

  // returns NSString *
  [self.architect stringForKey:@"stringKey"];

  // returns NSInteger
  [self.architect integerForKey:@"integerKey"];

  // returns NSUInteger
  [self.architect unsignedIntegerForKey:@"unsignedIntegerKey"];

  // returns int
  [self.architect intForKey:@"intKey"];

  // returns unsigned int
  [self.architect unsignedIntForKey:@"unsignedIntKey"];

  // returns CGFloat
  [self.architect floatForKey:@"floatKey"];

  // returns UIColor *
  [self.architect colorForKey:@"colorKey"];

  // returns UIEdgeInsets
  [self.architect edgeInsetsForKey:@"edgeInsetsKey"];

  // returns CGPoint
  [self.architect pointForKey:@"pointKey"];

  // returns CGSize
  [self.architect sizeForKey:@"sizeKey"];

  // returns UIFont *
  [self.architect fontForKey:@"fontKey"];

  // returns CGRect
  [self.architect rectForKey:@"rectKey"];

  // returns MRGArchitectGradient (helper class with colors & locations)
  [self.architect gradientForKey:@"gradientKey"];
```

### Perfectionist way

Say you also have properties that apply to all of your views. Instead of having one instance of `MRGArchitect` specific for your view and another instance for your generic properties, use the importation feature.

In your JSON file, import another file like so :
```json
{
  "@imports": [
    "FileNameToImportWithoutExtension"
  ]
}
```

### Backstage secrets

#### Understanding properties compilation

`MRGArchitect` loads more than one file (if it finds more than one) for a given class name.

Here is the order it will search for files on iPhone :
- `<name>.json`
- `<name>~iphone.json`
- `<name>-568h.json`
- `<name>-568h~iphone.json`
- `<name>-667h.json`
- `<name>-667h~iphone.json`
- `<name>-736h.json`
- `<name>-736h~iphone.json`

On iPad :
- `<name>.json`
- `<name>~ipad.json`

These are the order the files will be loaded and so the order the properties will be compiled. For example :
- for a given class name, the property "foo" of `<name>.json` will be overriden by the property "foo" of `<name>~iphone.json`, on iPhone,
- and the property "bar" of `<name>.json` will be overriden by the property "bar" of `<name>~ipad.json`, on iPad.

Of course, it only applies if these files exist.

#### Working with traits and size classes

`MRGArchitect` also supports size class dependant properties.  For this to work, you need to provide a property file
`<name>-traits.json` with a data structure in this fashion:
```javascript
{
    "[* *]": {
        "title":"Any Any"
    },
    "[+ *]": {
        "title":"Regular Any"
    },
    "[* -]": {
        "title":"Any Compact"
    },
    "[- *]": {
        "title":"Compact Any"
    },
    "[- +]": {
        "title":"Compact Regular"
    },
    "[+ +]": {
        "title":"Regular Regular"
    }
}
```
In your view, update `MRGArchitect`'s trait collection when appropriate ([see Apple's `traitCollectionDidChange` documentation](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITraitEnvironment_Ref/#//apple_ref/occ/intfm/UITraitEnvironment/traitCollectionDidChange:)):
```objc
self.architect.traitCollection = self.traitCollection;
```
Properties whose size class description match the current size class will be loaded, from the most generic to the most precise.  The following chart illustrate the current possibilities:

![Device Size Classes](https://raw.githubusercontent.com/Mirego/MRGArchitect/assets/size_classes.png)

#### Defining complex properties

 - Colors :
    ```javascript
    "colorKey": "#FF0000",
    // OR (ARGB format)
    "colorWithAlphaKey": "#80FAFAFA"
    ```

 - Edge Insets :
    ```javascript
    "edgeInsetsKey": {
      "top": 1.0,
      "left": 2.0,
      "bottom": 3.0,
      "right": 4.0
    },
    // OR
    "stringEdgeInsetsKey": "{4.0, 3.0, 2.0, 1.0}"
    ```

 - Points :
    ```javascript
    "pointKey": {
      "x": 1.0,
      "y": 2.0
    },
    // OR
    "stringPointKey": "{2.0, 1.0}"
    ```

 - Sizes :
    ```javascript
    "sizeKey": {
      "width": 10.0,
      "height": 20.0
    },
    // OR
    "stringSizeKey": "{20.0, 10.0}"
    ```

 - Fonts :
    ```javascript
    "fontKey": {
      "name": "HelveticaNeue",
      "size": 15.0
    }
    ```

 - Rects :
    ```javascript
    "rectKey": {
      "origin": {
        "x": 10.0,
        "y": 10.0
      },
      "size": {
        "width": 64.0,
        "height": 64.0
      }
    },
    // OR
    "stringRectKey": "{{10.0, 10.0}, {64.0, 64.0}}"
    ```

 - Gradients :
    ```javascript
    "gradientKey": [
	    {
		    "location": 0.0,
		    "color": "#FFFFFF"
	    },
	    {
		    "location": 0.3,
		    "color": "#878787"
	    },
	    {
		    "location": 1.0,
		    "color": "#000000"
	    }
    ]
    ```

## License

`MRGArchitect` is © 2014-2015 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE`](https://github.com/mirego/MRGArchitect/blob/master/LICENSE) file.

## About Mirego

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](http://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
