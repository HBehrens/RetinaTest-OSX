RetinaTest-OSX
==============

This Cocoa app has been tested on OSX Lion and OSX Mountain Lion.
It demonstrates various techniques to render a sample image according to the display's pixel density.
The given sample image comes in two flavors "LoDPI" at 50x50px and "HiDPI" 100x100px so you can easily tell them apart. On the web views, there's also the distinction between `image`, `background` and `backgroundHover`.

Currently, these techniques are tested:

 * PNG-suffix `@2x` on an `NSImage`
 * Multi-Resolution TIFF on an `NSImage`
 * Media queries on a CSS background to swap PNG versions
 * Ordinary HTML image tag with PNG (while @2x-version exists) and multi-resolution TIFF 
 * CSS background with multi-resolution TIFF as described in this [blog post by Jacob Gorban](http://gorban.org/post/27478047050/using-multi-resolution-tiff-files-with-webkit-on-mac?c8885330)
 * Conditional resource loading as described in this [blog post by Shaun Inman](http://shauninman.com/tmp/retina/) but by implementing `webView:resource:willSendRequest:redirectResponse:redirectResponse fromDataSource:` of `WebResourceLoadDelegate` instead of mod_rewrite rules 
 * And additional `RetinaHelper.js` that reloads images whenever you move the window on or off an Retina display (read: external non-retina display or beamer)

Findings
========
**NSImage** works fine with both PNG-suffix and multi-resolution TIFFs. For **embedded web views** use a combination of 

 * media queries for (dynamic) css backgrounds and
 * conditional resource loading plus `RetinaHelper.js` for ordinary images

to deliver the desired effect. This works even if you move your Cocoa window between Retina and non-Retina displays. Multi-Resolution TIFFs do not work for web views. They will always show their first image.

Setup
=====
To produce Retina-ready HTML for an embedded web view please do not forget to explicitly set

 * css `background-size` for background graphics and 
 * `width` and `height` for `img` tags

to avoid cropped backgrounds or blown-up images.

Use the category from `NSURL+Retina.h` and an implementation like this

````
#pragma mark - WebResourceLoadDelegate

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource {
    if(request.URL.isFileURL) {
        return [NSURLRequest requestWithURL:[request.URL urlForRetinaFactorOfView:sender]];
    }
    return request;
}
````    

to load image resources depending on the display's capabilities. `RetinaHelper.js` will take care to reload `img` tags whenever you move the window onto a display with a different pixel density.

If you do not have access to a Mac with a Retina display you can use [this approach to enable HiDPI graphic modes](http://developer.apple.com/library/mac/#documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Testing/Testing.html).

To produce multi-resolution TIFFs run `tiffutil -cathidpicheck sample.png sample@2x.png -out sample.tiff` as described in the [High Resolution Guidelines for OS X](http://developer.apple.com/library/mac/#documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html#//apple_ref/doc/uid/TP40012302-CH7-SW13).

Known Issues
============
In general, the aforementioned setup for embedded web views works as expected. Anyway, you should distinguish between image files for `img` tags and css backgrounds: Since the cocoa web view caches data for urls and won't ask the `WebResourceLoadDelegate` a second time it could happen that an initial request on a Retina display for `image.png` for and `img` tag will be redirected to `image@2x.png`. After moving that window onto a non-Retina display the css media query for a background image would swap from `image@2x.png` to `image.png` which previously has been cached as `image@2x.png`.

**To avoid any strange behavior** like this simply separate files names for css backgrounds and `img` tags.

Feedback Appreciated
====================

Please let my know if you find any other techniques or workarounds to make the TIFF work.

Cheers,
Heiko Behrens ([HeikoBehrens.net](http://HeikoBehrens.net), [@HBehrens](https://twitter.com/HBehrens)).