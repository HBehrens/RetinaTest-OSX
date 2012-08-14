RetinaTest-OSX
==============

This Cocoa app has been tested on OSX Lion and OSX Mountain Lion.
It demonstrates various techniques to render a sample image according to the display's pixel density.
The given sample image comes in two flavours "LoDPI" at 50x50px and "HiDPI" 100x100px so you can easily tell them apart.

Currently, these techniques are tested:

 * PNG-suffix `@2x` on an `NSImage`
 * Multi-Resolution TIFF on an `NSImage`
 * Media queries on a CSS background to swap PNG versions
 * Ordinary HTML image tag with PNG (while @2x-version exists) and multi-resolution TIFF 
 * CSS background with multi-resolution tiff as described in this [blog post by Jacob Gorban](http://gorban.org/post/27478047050/using-multi-resolution-tiff-files-with-webkit-on-mac?c8885330)

**Please note:** Not all techniques do work as expected (e.g. a multi-resoltion tiff on a webview *should* work).

Setup
=====
If you do not have access to a Mac with a Retina display you can use [this approach to enable HiDPI graphic modes](http://developer.apple.com/library/mac/#documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Testing/Testing.html).

To produce multi-resolution tiffs run `tiffutil -cathidpicheck sample.png sample@2x.png -out sample.tiff` as described in the [High Resolution Guidelines for OS X](http://developer.apple.com/library/mac/#documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html#//apple_ref/doc/uid/TP40012302-CH7-SW13).


Future Plans
============

I'd like to demonstrate another approach where the webview's delegate hooks into the loading of image resources and picks the right content.

Please let my know if you find any other techniques or workarounds to make the tiff work.

Cheers,
Heiko Behrens.