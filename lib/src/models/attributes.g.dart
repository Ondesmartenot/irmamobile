// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttributeRequest _$AttributeRequestFromJson(Map<String, dynamic> json) {
  return AttributeRequest(
    type: json['Type'] as String,
    value: json['Value'] as String,
    notNull: json['NotNull'] as bool,
  );
}

Map<String, dynamic> _$AttributeRequestToJson(AttributeRequest instance) => <String, dynamic>{
      'Type': instance.type,
      'Value': instance.value,
      'NotNull': instance.notNull,
    };

AttributeIdentifier _$AttributeIdentifierFromJson(Map<String, dynamic> json) {
  return AttributeIdentifier(
    type: json['Type'] as String,
    credentialHash: json['CredentialHash'] as String,
  );
}

Map<String, dynamic> _$AttributeIdentifierToJson(AttributeIdentifier instance) => <String, dynamic>{
      'Type': instance.type,
      'CredentialHash': instance.credentialHash,
    };