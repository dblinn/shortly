var Shortly = Shortly || {};

Shortly.urlRegex = new RegExp('^http[s]?://');
Shortly.urlMatcherRegex = new RegExp('^http[s]?://(.*)');

Shortly.validatedUrl = function(url) {
  withScheme = Shortly.urlWithScheme(url);
  if (re_weburl.exec(withScheme)) {
    return withScheme;
  }
  return url;
}

Shortly.urlWithScheme = function(url) {
  if (Shortly.urlRegex.test(url)) {
    return url;
  }
  else {
    return 'http://' + url;
  }
};

Shortly.urlWithoutScheme = function(url) {
  var match = Shortly.urlMatcherRegex.exec(url);
  if (match !== null) {
    return match[1];
  }
  else {
    return url;
  }
};