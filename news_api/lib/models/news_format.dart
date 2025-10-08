//lib/models/news_format.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'news_format.g.dart';

@JsonSerializable()  
class NewsFormat extends Equatable {
  final String? by;
  final int? id;
  final List<int>? kids;
  final int? parent;
  final String? text;
  final int? time;
  final String? type;
  final String? title;
  final int? score;
  final String? url;
  final int? descendants;

  const NewsFormat({
    this.by,
    this.id,
    this.kids,
    this.parent,
    this.text,
    this.time,
    this.type,
    this.title,
    this.score,
    this.url,
    this.descendants,
  });

  
  factory NewsFormat.fromJson(Map<String, dynamic> json) => _$NewsFormatFromJson(json);

  
  Map<String, dynamic> toJson() => _$NewsFormatToJson(this);

  @override
  List<Object?> get props => [by, id, kids, parent, text, time, type, title, score, url, descendants];
}