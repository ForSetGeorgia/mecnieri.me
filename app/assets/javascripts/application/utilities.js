
function selectedText($select) {
  return $select.find(":selected").text().trim();
}if (typeof(String.prototype.trim) === 'undefined') {
  String.prototype.trim = function() {
    return String(this).replace(/^\s+|\s+$/g, '');
  };
}

function mergeObjects(obj1, obj2) {
  var obj3 = {};

  for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
  for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }

  return obj3;
}

function selectedText($select) {
  return $select.find(":selected").text().trim();
}

function localeIs(locale) {
  return gon.locale === locale;
}
