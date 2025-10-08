import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class WebContentService {
  final Dio _dio;

  WebContentService()
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 300),
            receiveTimeout: const Duration(seconds: 300),
            headers: {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            },
          ),
        );

  Future<String> fetchArticleContent(String url) async {
    try {
      print('[WEB] Fetching content from: $url');
      
      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
        final content = _extractMainContent(response.data);
        print('[WEB] Successfully extracted content (${content.length} chars)');
        return content;
      } else {
        throw Exception('Failed to fetch content: HTTP ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('[WEB] Error fetching content: ${e.message}');
      throw Exception('Failed to fetch article content: ${e.message}');
    } catch (e) {
      print('[WEB] Unexpected error: $e');
      throw Exception('Failed to fetch article content: $e');
    }
  }

  String _extractMainContent(String htmlString) {
    final document = html_parser.parse(htmlString);
    
    final contentSelectors = [
      'article',
      '[role="main"]',
      '.content',
      '.article-content',
      '.post-content',
      '.entry-content', 
      '.story-body',
      '.article-body',
      'main',
      '#content',
      '#main-content',
    ];

    Element? mainElement;
    
    for (final selector in contentSelectors) {
      mainElement = document.querySelector(selector);
      if (mainElement != null) {
        final text = _cleanText(mainElement.text);
        if (text.length > 200) { break;}
      }
    }


    if (mainElement == null || _cleanText(mainElement.text).length < 200) {
      final paragraphs = document.querySelectorAll('p');
      final allText = paragraphs.map((p) => p.text).join('\n\n');
      
      if (allText.length > 200) {
        return _cleanText(allText);
      }
      
      final bodyText = document.body?.text ?? '';
      return _cleanText(bodyText);
    }

    return _cleanText(mainElement.text);
  }

  String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'\s+'), ' ') 
        .replaceAll(RegExp(r'\n\s*\n'), '\n\n')
        .trim();
  }

}