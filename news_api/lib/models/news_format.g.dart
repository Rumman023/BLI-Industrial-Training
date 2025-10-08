// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsFormat _$NewsFormatFromJson(Map<String, dynamic> json) => NewsFormat(
      by: json['by'] as String?,
      id: (json['id'] as num?)?.toInt(),
      kids: (json['kids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      parent: (json['parent'] as num?)?.toInt(),
      text: json['text'] as String?,
      time: (json['time'] as num?)?.toInt(),
      type: json['type'] as String?,
      title: json['title'] as String?,
      score: (json['score'] as num?)?.toInt(),
      url: json['url'] as String?,
      descendants: (json['descendants'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NewsFormatToJson(NewsFormat instance) =>
    <String, dynamic>{
      'by': instance.by,
      'id': instance.id,
      'kids': instance.kids,
      'parent': instance.parent,
      'text': instance.text,
      'time': instance.time,
      'type': instance.type,
      'title': instance.title,
      'score': instance.score,
      'url': instance.url,
      'descendants': instance.descendants,
    };
