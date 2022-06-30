// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'data/local/database/objectbox/model/object_box_token.dart';
import 'data/local/database/objectbox/model/object_box_user.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(2, 4461467747026883837),
      name: 'ObjectBoxUser',
      lastPropertyId: const IdUid(4, 1045648510981454082),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4487787075157856590),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5737586196601803560),
            name: 'userId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1508306153113125613),
            name: 'tokenId',
            type: 11,
            flags: 520,
            indexId: const IdUid(1, 6970047395987467947),
            relationTarget: 'ObjectBoxToken')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 8271335877614481830),
      name: 'ObjectBoxToken',
      lastPropertyId: const IdUid(2, 8407047220043060734),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 135479034938686090),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 8407047220043060734),
            name: 'token',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(3, 8271335877614481830),
      lastIndexId: const IdUid(1, 6970047395987467947),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [7163745484534489156],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        3812969659023192963,
        8969398750685921378,
        1045648510981454082
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    ObjectBoxUser: EntityDefinition<ObjectBoxUser>(
        model: _entities[0],
        toOneRelations: (ObjectBoxUser object) => [object.token],
        toManyRelations: (ObjectBoxUser object) => {},
        getId: (ObjectBoxUser object) => object.id,
        setId: (ObjectBoxUser object, int id) {
          object.id = id;
        },
        objectToFB: (ObjectBoxUser object, fb.Builder fbb) {
          final userIdOffset =
              object.userId == null ? null : fbb.writeString(object.userId!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, userIdOffset);
          fbb.addInt64(2, object.token.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ObjectBoxUser(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              userId: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 6));
          object.token.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          object.token.attach(store);
          return object;
        }),
    ObjectBoxToken: EntityDefinition<ObjectBoxToken>(
        model: _entities[1],
        toOneRelations: (ObjectBoxToken object) => [],
        toManyRelations: (ObjectBoxToken object) => {},
        getId: (ObjectBoxToken object) => object.id,
        setId: (ObjectBoxToken object, int id) {
          object.id = id;
        },
        objectToFB: (ObjectBoxToken object, fb.Builder fbb) {
          final tokenOffset =
              object.token == null ? null : fbb.writeString(object.token!);
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, tokenOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ObjectBoxToken(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              token: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 6));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [ObjectBoxUser] entity fields to define ObjectBox queries.
class ObjectBoxUser_ {
  /// see [ObjectBoxUser.id]
  static final id =
      QueryIntegerProperty<ObjectBoxUser>(_entities[0].properties[0]);

  /// see [ObjectBoxUser.userId]
  static final userId =
      QueryStringProperty<ObjectBoxUser>(_entities[0].properties[1]);

  /// see [ObjectBoxUser.token]
  static final token = QueryRelationToOne<ObjectBoxUser, ObjectBoxToken>(
      _entities[0].properties[2]);
}

/// [ObjectBoxToken] entity fields to define ObjectBox queries.
class ObjectBoxToken_ {
  /// see [ObjectBoxToken.id]
  static final id =
      QueryIntegerProperty<ObjectBoxToken>(_entities[1].properties[0]);

  /// see [ObjectBoxToken.token]
  static final token =
      QueryStringProperty<ObjectBoxToken>(_entities[1].properties[1]);
}
