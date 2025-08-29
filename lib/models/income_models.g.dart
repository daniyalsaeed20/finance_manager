// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetServiceTemplateCollection on Isar {
  IsarCollection<ServiceTemplate> get serviceTemplates => this.collection();
}

const ServiceTemplateSchema = CollectionSchema(
  name: r'ServiceTemplate',
  id: 4381736425458434054,
  properties: {
    r'active': PropertySchema(
      id: 0,
      name: r'active',
      type: IsarType.bool,
    ),
    r'defaultPriceMinor': PropertySchema(
      id: 1,
      name: r'defaultPriceMinor',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'sortOrder': PropertySchema(
      id: 3,
      name: r'sortOrder',
      type: IsarType.long,
    )
  },
  estimateSize: _serviceTemplateEstimateSize,
  serialize: _serviceTemplateSerialize,
  deserialize: _serviceTemplateDeserialize,
  deserializeProp: _serviceTemplateDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _serviceTemplateGetId,
  getLinks: _serviceTemplateGetLinks,
  attach: _serviceTemplateAttach,
  version: '3.1.0+1',
);

int _serviceTemplateEstimateSize(
  ServiceTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _serviceTemplateSerialize(
  ServiceTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.active);
  writer.writeLong(offsets[1], object.defaultPriceMinor);
  writer.writeString(offsets[2], object.name);
  writer.writeLong(offsets[3], object.sortOrder);
}

ServiceTemplate _serviceTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ServiceTemplate();
  object.active = reader.readBool(offsets[0]);
  object.defaultPriceMinor = reader.readLong(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  object.sortOrder = reader.readLong(offsets[3]);
  return object;
}

P _serviceTemplateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _serviceTemplateGetId(ServiceTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _serviceTemplateGetLinks(ServiceTemplate object) {
  return [];
}

void _serviceTemplateAttach(
    IsarCollection<dynamic> col, Id id, ServiceTemplate object) {
  object.id = id;
}

extension ServiceTemplateQueryWhereSort
    on QueryBuilder<ServiceTemplate, ServiceTemplate, QWhere> {
  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ServiceTemplateQueryWhere
    on QueryBuilder<ServiceTemplate, ServiceTemplate, QWhereClause> {
  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ServiceTemplateQueryFilter
    on QueryBuilder<ServiceTemplate, ServiceTemplate, QFilterCondition> {
  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      activeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'active',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      defaultPriceMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultPriceMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      defaultPriceMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultPriceMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      defaultPriceMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultPriceMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      defaultPriceMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultPriceMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      sortOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      sortOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      sortOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterFilterCondition>
      sortOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sortOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ServiceTemplateQueryObject
    on QueryBuilder<ServiceTemplate, ServiceTemplate, QFilterCondition> {}

extension ServiceTemplateQueryLinks
    on QueryBuilder<ServiceTemplate, ServiceTemplate, QFilterCondition> {}

extension ServiceTemplateQuerySortBy
    on QueryBuilder<ServiceTemplate, ServiceTemplate, QSortBy> {
  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      sortByDefaultPriceMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPriceMinor', Sort.asc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      sortByDefaultPriceMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPriceMinor', Sort.desc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }
}

extension ServiceTemplateQuerySortThenBy
    on QueryBuilder<ServiceTemplate, ServiceTemplate, QSortThenBy> {
  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      thenByDefaultPriceMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPriceMinor', Sort.asc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      thenByDefaultPriceMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPriceMinor', Sort.desc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QAfterSortBy>
      thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }
}

extension ServiceTemplateQueryWhereDistinct
    on QueryBuilder<ServiceTemplate, ServiceTemplate, QDistinct> {
  QueryBuilder<ServiceTemplate, ServiceTemplate, QDistinct> distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QDistinct>
      distinctByDefaultPriceMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultPriceMinor');
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceTemplate, ServiceTemplate, QDistinct>
      distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }
}

extension ServiceTemplateQueryProperty
    on QueryBuilder<ServiceTemplate, ServiceTemplate, QQueryProperty> {
  QueryBuilder<ServiceTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ServiceTemplate, bool, QQueryOperations> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<ServiceTemplate, int, QQueryOperations>
      defaultPriceMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPriceMinor');
    });
  }

  QueryBuilder<ServiceTemplate, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ServiceTemplate, int, QQueryOperations> sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIncomeRecordCollection on Isar {
  IsarCollection<IncomeRecord> get incomeRecords => this.collection();
}

const IncomeRecordSchema = CollectionSchema(
  name: r'IncomeRecord',
  id: 4973069917103113377,
  properties: {
    r'clientCount': PropertySchema(
      id: 0,
      name: r'clientCount',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'note': PropertySchema(
      id: 2,
      name: r'note',
      type: IsarType.string,
    ),
    r'services': PropertySchema(
      id: 3,
      name: r'services',
      type: IsarType.objectList,
      target: r'IncomeServiceItem',
    ),
    r'tipMinor': PropertySchema(
      id: 4,
      name: r'tipMinor',
      type: IsarType.long,
    ),
    r'totalMinor': PropertySchema(
      id: 5,
      name: r'totalMinor',
      type: IsarType.long,
    )
  },
  estimateSize: _incomeRecordEstimateSize,
  serialize: _incomeRecordSerialize,
  deserialize: _incomeRecordDeserialize,
  deserializeProp: _incomeRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'IncomeServiceItem': IncomeServiceItemSchema},
  getId: _incomeRecordGetId,
  getLinks: _incomeRecordGetLinks,
  attach: _incomeRecordAttach,
  version: '3.1.0+1',
);

int _incomeRecordEstimateSize(
  IncomeRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.services.length * 3;
  {
    final offsets = allOffsets[IncomeServiceItem]!;
    for (var i = 0; i < object.services.length; i++) {
      final value = object.services[i];
      bytesCount +=
          IncomeServiceItemSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _incomeRecordSerialize(
  IncomeRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.clientCount);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.note);
  writer.writeObjectList<IncomeServiceItem>(
    offsets[3],
    allOffsets,
    IncomeServiceItemSchema.serialize,
    object.services,
  );
  writer.writeLong(offsets[4], object.tipMinor);
  writer.writeLong(offsets[5], object.totalMinor);
}

IncomeRecord _incomeRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IncomeRecord();
  object.clientCount = reader.readLongOrNull(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.id = id;
  object.note = reader.readStringOrNull(offsets[2]);
  object.services = reader.readObjectList<IncomeServiceItem>(
        offsets[3],
        IncomeServiceItemSchema.deserialize,
        allOffsets,
        IncomeServiceItem(),
      ) ??
      [];
  object.tipMinor = reader.readLong(offsets[4]);
  object.totalMinor = reader.readLong(offsets[5]);
  return object;
}

P _incomeRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readObjectList<IncomeServiceItem>(
            offset,
            IncomeServiceItemSchema.deserialize,
            allOffsets,
            IncomeServiceItem(),
          ) ??
          []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _incomeRecordGetId(IncomeRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _incomeRecordGetLinks(IncomeRecord object) {
  return [];
}

void _incomeRecordAttach(
    IsarCollection<dynamic> col, Id id, IncomeRecord object) {
  object.id = id;
}

extension IncomeRecordQueryWhereSort
    on QueryBuilder<IncomeRecord, IncomeRecord, QWhere> {
  QueryBuilder<IncomeRecord, IncomeRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IncomeRecordQueryWhere
    on QueryBuilder<IncomeRecord, IncomeRecord, QWhereClause> {
  QueryBuilder<IncomeRecord, IncomeRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IncomeRecordQueryFilter
    on QueryBuilder<IncomeRecord, IncomeRecord, QFilterCondition> {
  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      clientCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clientCount',
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      clientCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clientCount',
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      clientCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      clientCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      clientCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      clientCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      servicesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'services',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      servicesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'services',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      servicesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'services',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      servicesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'services',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      servicesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'services',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      servicesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'services',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      tipMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      tipMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      tipMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      tipMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      totalMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      totalMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      totalMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      totalMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IncomeRecordQueryObject
    on QueryBuilder<IncomeRecord, IncomeRecord, QFilterCondition> {
  QueryBuilder<IncomeRecord, IncomeRecord, QAfterFilterCondition>
      servicesElement(FilterQuery<IncomeServiceItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'services');
    });
  }
}

extension IncomeRecordQueryLinks
    on QueryBuilder<IncomeRecord, IncomeRecord, QFilterCondition> {}

extension IncomeRecordQuerySortBy
    on QueryBuilder<IncomeRecord, IncomeRecord, QSortBy> {
  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> sortByClientCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientCount', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy>
      sortByClientCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientCount', Sort.desc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> sortByTipMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipMinor', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> sortByTipMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipMinor', Sort.desc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> sortByTotalMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinor', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy>
      sortByTotalMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinor', Sort.desc);
    });
  }
}

extension IncomeRecordQuerySortThenBy
    on QueryBuilder<IncomeRecord, IncomeRecord, QSortThenBy> {
  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenByClientCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientCount', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy>
      thenByClientCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientCount', Sort.desc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenByTipMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipMinor', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenByTipMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipMinor', Sort.desc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy> thenByTotalMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinor', Sort.asc);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QAfterSortBy>
      thenByTotalMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinor', Sort.desc);
    });
  }
}

extension IncomeRecordQueryWhereDistinct
    on QueryBuilder<IncomeRecord, IncomeRecord, QDistinct> {
  QueryBuilder<IncomeRecord, IncomeRecord, QDistinct> distinctByClientCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientCount');
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QDistinct> distinctByTipMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipMinor');
    });
  }

  QueryBuilder<IncomeRecord, IncomeRecord, QDistinct> distinctByTotalMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalMinor');
    });
  }
}

extension IncomeRecordQueryProperty
    on QueryBuilder<IncomeRecord, IncomeRecord, QQueryProperty> {
  QueryBuilder<IncomeRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IncomeRecord, int?, QQueryOperations> clientCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientCount');
    });
  }

  QueryBuilder<IncomeRecord, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<IncomeRecord, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<IncomeRecord, List<IncomeServiceItem>, QQueryOperations>
      servicesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'services');
    });
  }

  QueryBuilder<IncomeRecord, int, QQueryOperations> tipMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipMinor');
    });
  }

  QueryBuilder<IncomeRecord, int, QQueryOperations> totalMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalMinor');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IncomeServiceItemSchema = Schema(
  name: r'IncomeServiceItem',
  id: 6193245509195291664,
  properties: {
    r'priceMinor': PropertySchema(
      id: 0,
      name: r'priceMinor',
      type: IsarType.long,
    ),
    r'serviceName': PropertySchema(
      id: 1,
      name: r'serviceName',
      type: IsarType.string,
    )
  },
  estimateSize: _incomeServiceItemEstimateSize,
  serialize: _incomeServiceItemSerialize,
  deserialize: _incomeServiceItemDeserialize,
  deserializeProp: _incomeServiceItemDeserializeProp,
);

int _incomeServiceItemEstimateSize(
  IncomeServiceItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.serviceName.length * 3;
  return bytesCount;
}

void _incomeServiceItemSerialize(
  IncomeServiceItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.priceMinor);
  writer.writeString(offsets[1], object.serviceName);
}

IncomeServiceItem _incomeServiceItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IncomeServiceItem();
  object.priceMinor = reader.readLong(offsets[0]);
  object.serviceName = reader.readString(offsets[1]);
  return object;
}

P _incomeServiceItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IncomeServiceItemQueryFilter
    on QueryBuilder<IncomeServiceItem, IncomeServiceItem, QFilterCondition> {
  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      priceMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      priceMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      priceMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      priceMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serviceName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceName',
        value: '',
      ));
    });
  }

  QueryBuilder<IncomeServiceItem, IncomeServiceItem, QAfterFilterCondition>
      serviceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serviceName',
        value: '',
      ));
    });
  }
}

extension IncomeServiceItemQueryObject
    on QueryBuilder<IncomeServiceItem, IncomeServiceItem, QFilterCondition> {}
