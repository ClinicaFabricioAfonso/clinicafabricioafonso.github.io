---
---

class Insta

    constructor: (el) ->
        return new Insta(el) unless this instanceof Insta
        @container = el
        @url = el.getAttribute 'instagram-url'
        @length = el.getAttribute 'instagram-length'
        @template = el.querySelector('[instagram-item]').cloneNode(true)
        el.innerHTML = ''

    load: (fn) ->

        ajax = (url, fn) ->
            req = new XMLHttpRequest()
            req.open 'get', url, true
            req.onload = -> fn req.responseText if req.status >= 200 and req.status < 400
            req.send()
            return req
        l = @length
        c = @container
        t = @template

        ajax @url, (data) ->
            items = JSON.parse(data).data
            items.length = Math.min(l, items.length) if l
            items.forEach (obj) ->
                c.appendChild fn t.cloneNode(true), obj

Array.prototype.forEach.call document.querySelectorAll('[instagram-url]'), (insta) ->
    Insta(insta).load (el, data) ->
        img = el.querySelector 'img'
        res = img.getAttribute('instagram-src') || 'thumbnail'
        imgData = data.images[res]
        img.src = imgData.url
        el