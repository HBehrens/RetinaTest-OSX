(function(){
    var cachedURLs = {};
    function adjustedImageURL(url, fromPixelRatio, toPixelRatio) {
        if(url.indexOf("file:") != 0)
            return url;

        // extract url without pixelRatio parameter
        var baseURL = url;
        if(baseURL.indexOf("?") >= 0)
            baseURL = baseURL.replace(/\?pixelRatio=\d*/, "");

        // create cache entry if absent
        var entry = cachedURLs[baseURL];
        if(typeof(entry)=="undefined")
            entry = cachedURLs[baseURL] = {};

        // store URL for current ratio
        entry[fromPixelRatio] = url;

        // retrieve or generate and store url for target ratio
        var toURL = entry[toPixelRatio];
        if(typeof(toURL)=="undefined")
            toURL = entry[toPixelRatio] = baseURL + "?pixelRatio=" + toPixelRatio;

        return toURL;
    }

    function reloadAllImages(fromPixelRatio, toPixelRatio) {
        var all = document.getElementsByTagName("img");
        for (var i=0, max=all.length; i < max; i++) {
            var img = all[i];
            img.src = adjustedImageURL(img.src, fromPixelRatio, toPixelRatio);
        }
    }

    function callIfPixelRatioChanged(func, previousPixelRatio) {
        var currentPixelRatio = window.devicePixelRatio;
        if(currentPixelRatio != previousPixelRatio) {
            func(previousPixelRatio, currentPixelRatio);
        }
        setTimeout(function(){callIfPixelRatioChanged(func, currentPixelRatio)}, 100);
    }

    callIfPixelRatioChanged(reloadAllImages, window.devicePixelRatio);

})();