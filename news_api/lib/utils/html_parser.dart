class HtmlParser {
  static String parse(String html) {
    String text = html;

    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    text = _decodeHtmlEntities(text);

    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  static String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
  }
}