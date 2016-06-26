(function () {
  function dictionaryEntry(text) {
    // while (text != (text = text.replace(/\[dictionary-entry\s?(\w*)\]([\s\S]*)\[\/dictionary-entry\]/ig, function (match, p1, p2, offset, string) {
    while (text != (text = text.replace(/\[dictionary-entry\s?(\w*)\]((?:(?!\[dictionary-entry\s?(\w*)\]|\[\/dictionary-entry\])[\S\s])*)\[\/dictionary-entry\]/ig, function (match, p1, p2, offset, string) {
      // if (p1 === 'rtl') {
      //   return '<div class="dictionary-entry dictionary-rtl">' + p2 + '</div>';
      // } else {
      //   return '<div class="dictionary-entry">' + p2 + '</div>';
      // }
      var dictClass = p1 === 'rtl' ? ' dictionary-rtl' : '';
      return '<div class="dictionary-entry' + dictClass + '">' + p2 + '</div>';
    })));
    return text;
  }

  Discourse.Dialect.addPreProcessor(dictionaryEntry);
  Discourse.Markdown.whiteListTag('div', 'class', 'dictionary-entry');
  Discourse.Markdown.whiteListTag('div', 'class', 'dictionary-entry dictionary-rtl');
})();


