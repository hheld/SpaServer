'use strict';

// provide Bootstrap classes
require('../node_modules/bootstrap/dist/css/bootstrap.min.css')

var Elm = require('./Main.elm');
var mountNode = document.getElementById('app-container');

var app = Elm.Main.embed(mountNode, {
    csrfToken: getCookieValue('Csrf-token'),
    pageHeader: pageTitle
});

function getCookieValue(cookie) {
    const re = new RegExp('(?:^' + cookie + '|;\s*' + cookie + ')=(.*?)(?:;|$)', 'g');
    const value = re.exec(document.cookie);
    return value===null ? '' : value[1];
}

app.ports.getCookieValue.subscribe(function(cookie) {
    app.ports.newCookieValue.send([cookie, getCookieValue(cookie)]);
});
