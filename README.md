# LocalizeKit
LocalizeKit is a collection of useful tools to help with the internationalization of your app.
It provides a convenient way to place all of your strings in one string file per language instead of having one file for the storyboard, one for the runtime strings and one for the plurals with support for attributed text.

The class in this [medium article](%28https://medium.com/@mario.negro.martin/easy-xib-and-storyboard-localization-b2794c69c9db) serves as a base for this framework but contains additionnal tools.
Plural localisation has been done based on the work of this library: [https://github.com/Smartling/ios-i18n](https://github.com/Smartling/ios-i18n) 

## Usage

### Runtime
Just call :
```"myLocalizedKey".localized```
To get the localized version of your string

Formatted strings are also supported :
```"myLocalizedKey".localizedWith(myString, otherString, ...)```

### Attributed Text
Attributed texts need a bit more work, first you need to declare your attributed localized strings this way:
```"myLocalizedKey" = "<html><head><meta charset='utf-8'></head>Attributed text <b>Bold</b></html>"```

Then you can call :
```
myLabel.attributedText = "myLocalizedKey".localizedAttributedForLabel(myLabel)
//OR with arguments
myLabel.attributedText = "myLocalizedKey".localizedAttributedForLabel(myLabel, str1, ...)
```
You need to pass the label to keep the label's current font and color, this particularly useful for dynamic color in dark mode.
You can use any html tag and css you want but keep in mind that the default color (=black) of the text will be replaced with the label's current color.

### Storyboard
Nearly every UI element in the storyboard can be localized, just select the component you want and a new Xib Loc Key field should appear under the attribute inspector.
UI elements localizable: 
- UILabel 
- UIButton (enabled / disabled)
- UINavigationItem
- UIBarItem
- UISegmentedControl (each segment separated with comma ,)
- UITextField (Use UITextFieldXIBLocalizable as base class to localize the placeholder)
- UITextView 

### Plurals
Plurals are also handled by this framework and follow the CLDR plural rules defined here : [http://cldr.unicode.org/index/cldr-spec/plural-rules](http://cldr.unicode.org/index/cldr-spec/plural-rules)
You need to define your plurals like this:
```
"myKey##{zero}" = "";
"myKey##{one}" = "";
"myKey##{two}" = "";
"myKey##{few}" = "";
"myKey##{many}" = "";
"myKey##{other}" = "";
```

Then you can call:
```
"myKey".pluralLocalizedWith(intOrFloat)
```
