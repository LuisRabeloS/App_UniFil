// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      id: json['id'] as String? ?? '',
      itemName: json['title'] as String,
      imgUrl: json['picture'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.itemName,
      'picture': instance.imgUrl,
      'price': instance.price,
      'description': instance.description,
      'unit': instance.unit,
    };
