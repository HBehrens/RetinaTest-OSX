(function(){
    //http://javascript.nwbox.com/ContentLoaded by Diego Perini with modifications
    function contentLoaded(n,t){var l="complete",s="readystatechange",u=!1,h=u,c=!0,i=n.document,a=i.documentElement,e=i.addEventListener?"addEventListener":"attachEvent",v=i.addEventListener?"removeEventListener":"detachEvent",f=i.addEventListener?"":"on",r=function(e){(e.type!=s||i.readyState==l)&&((e.type=="load"?n:i)[v](f+e.type,r,u),!h&&(h=!0)&&t.call(n,null))},o=function(){try{a.doScroll("left")}catch(n){setTimeout(o,50);return}r("poll")};if(i.readyState==l)t.call(n,"lazy");else{if(i.createEventObject&&a.doScroll){try{c=!n.frameElement}catch(y){}c&&o()}i[e](f+"DOMContentLoaded",r,u),i[e](f+s,r,u),n[e](f+"load",r,u)}};

    var cacheBusterValue;
    function adjustedImageURL(url) {
        if(url.indexOf("file:") != 0)
            return url;

        // just a cache buster, magic lies in request handler
        if(url.indexOf("?") >= 0)
            url = url.replace(/\?cacheBuster=\d*/, "");

        return url + "?cacheBuster=" + cacheBusterValue;
    }

    function reloadAllImages() {
        cacheBusterValue = new Date().getTime().toString();

        // reload images in img tags
        var all = document.getElementsByTagName("img");
        for (var i=0, max=all.length; i < max; i++) {
            var img = all[i];
            img.src = adjustedImageURL(img.src);
        }

        // reload css background images
        // known issue: this logic overrides dynamic css selector based rule
        //              it might destroy dynamic graphics based on changing classes
        all = document.getElementsByTagName("*");
        for (i=0, max=all.length; i < max; i++) {
            var elem = all[i];
            // Don't set styles on text and comment nodes
            if ( elem.nodeType === 3 || elem.nodeType === 8 || !elem.style ) {
                return;
            }

            var bg = getComputedStyle(elem, null)["background-image"];
            if(bg != "none") {
                var url = /url\((.*)\)/i.exec(bg);
                if (url) {
                    url = "url(" + adjustedImageURL(url[1]) + ")";
                    elem.style["background-image"] = url;
                }
            }
        }

    }

    function callIfPixelRatioChanged(func, previous) {
        var ratio = window.devicePixelRatio;
        if(ratio != previous) {
            func(ratio);
        }
        setTimeout(function(){callIfPixelRatioChanged(func, ratio)}, 100);
    }

    contentLoaded(window, function(){
        callIfPixelRatioChanged(reloadAllImages, window.devicePixelRatio);
    });


})();