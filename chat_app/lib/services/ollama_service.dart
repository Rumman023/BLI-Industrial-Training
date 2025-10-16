// lib/services/ollama_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/chat_models.dart';

class OllamaService {
  final String baseUrl;
  final String model;
  String? _resolvedBaseUrl;

  OllamaService({
    this.baseUrl = 'http://localhost:11434',
    this.model = 'qwen2.5:0.5b',
  });

  /// Check if Ollama is running and accessible
  Future<bool> checkConnection() async {
    if (_resolvedBaseUrl != null) return true;

    final candidates = <String>{};

    // Always try the configured baseUrl first
    candidates.add(baseUrl);

    // Common localhost addresses
    candidates.add('http://localhost:11434');
    candidates.add('http://127.0.0.1:11434');
    candidates.add('http://localhost:32874');
    candidates.add('http://127.0.0.1:32874');

    // If running on Android emulator, the host machine is reachable at 10.0.2.2
    try {
      if (Platform.isAndroid) {
        candidates.add('http://10.0.2.2:11434');
        candidates.add('http://10.0.3.2:11434');
        candidates.add('http://10.0.2.2:32874');
        candidates.add('http://10.0.3.2:32874');
      }
    } catch (_) {}

    // Try enumerating local network interfaces
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          final ip = addr.address;
          candidates.add('http://$ip:11434');
          candidates.add('http://$ip:32874');
        }
      }
    } catch (e) {
      print('NetworkInterface list failed: $e');
    }

    for (final candidate in candidates) {
      try {
        final url = Uri.parse('$candidate/api/tags');
        print('Trying Ollama ping: $url');
        final response =
            await http.get(url).timeout(const Duration(seconds: 5));
        print('Ping ${url} -> ${response.statusCode}');
        if (response.statusCode == 200) {
          _resolvedBaseUrl = candidate;
          print('Resolved Ollama base URL: $_resolvedBaseUrl');
          return true;
        }
      } on SocketException catch (e) {
        print('SocketException trying $candidate: $e');
        continue;
      } on TimeoutException catch (e) {
        print('Timeout trying $candidate: $e');
        continue;
      } catch (e) {
        print('Error trying $candidate: $e');
        continue;
      }
    }

    print(
        'No Ollama server detected on candidates. Last baseUrl was: $baseUrl');
    return false;
  }

  /// List available models
  Future<List<String>> listModels() async {
    final host = _resolvedBaseUrl ?? baseUrl;
    try {
      final url = Uri.parse('$host/api/tags');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['models'] is List) {
          return (decoded['models'] as List)
              .map((m) => m['name'].toString())
              .toList();
        }
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      }
    } catch (e) {
      print('Error listing models from $host: $e');
    }
    return [];
  }

  /// Generate a streaming response from Ollama
  Stream<String> generateResponseStream(List<ChatMessage> context) async* {
    final prompt = _buildPrompt(context);
    final host = _resolvedBaseUrl ?? baseUrl;
    final url = Uri.parse('$host/api/generate');

    final payload = {
      'model': model,
      'prompt': prompt,
      'stream': true,
      'options': {
        'temperature': 0.7,
        'top_p': 0.9,
        'num_predict': 1000,
        'stop': ['</s>', 'User:', 'Assistant:'],
      }
    };

    final client = http.Client();
    try {
      final req = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode(payload);

      final streamed =
          await client.send(req).timeout(const Duration(seconds: 120));

      await for (final chunk in streamed.stream.transform(utf8.decoder)) {
        final lines = chunk.split('\n');

        for (final line in lines) {
          if (line.trim().isEmpty) continue;

          try {
            final jsonData = jsonDecode(line);

            // Extract response text from Ollama's format
            if (jsonData is Map<String, dynamic>) {
              if (jsonData['done'] == true) break;

              final response = jsonData['response'];
              if (response is String && response.isNotEmpty) {
                // Yield the raw response - do not remove spaces
                yield response;
              }
            }
          } catch (e) {
            // Skip invalid JSON lines
            continue;
          }
        }
      }
    } finally {
      client.close();
    }
  }

  String _buildPrompt(List<ChatMessage> context) {
    if (context.isEmpty) return '';

    final buffer = StringBuffer();

    // Add system prompt to ensure plain English responses
    buffer.writeln('''You are a helpful AI assistant. Please follow these guidelines:
- Respond in clear, natural English
- Avoid JSON formatting or code blocks unless specifically requested
- Keep responses conversational and easy to understand
- Be concise but thorough
- Use proper grammar and punctuation

Current conversation:''');

    // Take only last 10 messages for context
    final recentContext = context.length > 10
        ? context.sublist(context.length - 10)
        : context;

    for (final message in recentContext) {
      if (message.isUser) {
        buffer.writeln('User: ${message.content}');
      } else {
        buffer.writeln('Assistant: ${message.content}');
      }
    }

    // Add final instruction
    buffer.write('Assistant:');
    return buffer.toString();
  }
}