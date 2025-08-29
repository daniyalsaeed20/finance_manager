// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaxPlanCollection on Isar {
  IsarCollection<TaxPlan> get taxPlans => this.collection();
}

const TaxPlanSchema = CollectionSchema(
  name: r'TaxPlan',
  id: -1898764426780594862,
  properties: {
    r'dueDate': PropertySchema(
      id: 0,
      name: r'dueDate',
      type: IsarType.dateTime,
    ),
    r'estimatedRate': PropertySchema(
      id: 1,
      name: r'estimatedRate',
      type: IsarType.double,
    ),
    r'periodKey': PropertySchema(
      id: 2,
      name: r'periodKey',
      type: IsarType.string,
    )
  },
  estimateSize: _taxPlanEstimateSize,
  serialize: _taxPlanSerialize,
  deserialize: _taxPlanDeserialize,
  deserializeProp: _taxPlanDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _taxPlanGetId,
  getLinks: _taxPlanGetLinks,
  attach: _taxPlanAttach,
  version: '3.1.0+1',
);

int _taxPlanEstimateSize(
  TaxPlan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.periodKey.length * 3;
  return bytesCount;
}

void _taxPlanSerialize(
  TaxPlan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dueDate);
  writer.writeDouble(offsets[1], object.estimatedRate);
  writer.writeString(offsets[2], object.periodKey);
}

TaxPlan _taxPlanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaxPlan();
  object.dueDate = reader.readDateTimeOrNull(offsets[0]);
  object.estimatedRate = reader.readDouble(offsets[1]);
  object.id = id;
  object.periodKey = reader.readString(offsets[2]);
  return object;
}

P _taxPlanDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _taxPlanGetId(TaxPlan object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taxPlanGetLinks(TaxPlan object) {
  return [];
}

void _taxPlanAttach(IsarCollection<dynamic> col, Id id, TaxPlan object) {
  object.id = id;
}

extension TaxPlanQueryWhereSort on QueryBuilder<TaxPlan, TaxPlan, QWhere> {
  QueryBuilder<TaxPlan, TaxPlan, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TaxPlanQueryWhere on QueryBuilder<TaxPlan, TaxPlan, QWhereClause> {
  QueryBuilder<TaxPlan, TaxPlan, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TaxPlan, TaxPlan, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterWhereClause> idBetween(
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

extension TaxPlanQueryFilter
    on QueryBuilder<TaxPlan, TaxPlan, QFilterCondition> {
  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> dueDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dueDate',
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> dueDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dueDate',
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> dueDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> dueDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> dueDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> dueDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dueDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> estimatedRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estimatedRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition>
      estimatedRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estimatedRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> estimatedRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estimatedRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> estimatedRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estimatedRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'periodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'periodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'periodKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'periodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'periodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'periodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'periodKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periodKey',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterFilterCondition> periodKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'periodKey',
        value: '',
      ));
    });
  }
}

extension TaxPlanQueryObject
    on QueryBuilder<TaxPlan, TaxPlan, QFilterCondition> {}

extension TaxPlanQueryLinks
    on QueryBuilder<TaxPlan, TaxPlan, QFilterCondition> {}

extension TaxPlanQuerySortBy on QueryBuilder<TaxPlan, TaxPlan, QSortBy> {
  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> sortByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> sortByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> sortByEstimatedRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedRate', Sort.asc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> sortByEstimatedRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedRate', Sort.desc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> sortByPeriodKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodKey', Sort.asc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> sortByPeriodKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodKey', Sort.desc);
    });
  }
}

extension TaxPlanQuerySortThenBy
    on QueryBuilder<TaxPlan, TaxPlan, QSortThenBy> {
  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> thenByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> thenByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> thenByEstimatedRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedRate', Sort.asc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> thenByEstimatedRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedRate', Sort.desc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> thenByPeriodKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodKey', Sort.asc);
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QAfterSortBy> thenByPeriodKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodKey', Sort.desc);
    });
  }
}

extension TaxPlanQueryWhereDistinct
    on QueryBuilder<TaxPlan, TaxPlan, QDistinct> {
  QueryBuilder<TaxPlan, TaxPlan, QDistinct> distinctByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dueDate');
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QDistinct> distinctByEstimatedRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedRate');
    });
  }

  QueryBuilder<TaxPlan, TaxPlan, QDistinct> distinctByPeriodKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodKey', caseSensitive: caseSensitive);
    });
  }
}

extension TaxPlanQueryProperty
    on QueryBuilder<TaxPlan, TaxPlan, QQueryProperty> {
  QueryBuilder<TaxPlan, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaxPlan, DateTime?, QQueryOperations> dueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dueDate');
    });
  }

  QueryBuilder<TaxPlan, double, QQueryOperations> estimatedRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedRate');
    });
  }

  QueryBuilder<TaxPlan, String, QQueryOperations> periodKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaxPaymentCollection on Isar {
  IsarCollection<TaxPayment> get taxPayments => this.collection();
}

const TaxPaymentSchema = CollectionSchema(
  name: r'TaxPayment',
  id: -1202849520184125480,
  properties: {
    r'amountMinor': PropertySchema(
      id: 0,
      name: r'amountMinor',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'method': PropertySchema(
      id: 2,
      name: r'method',
      type: IsarType.string,
    ),
    r'note': PropertySchema(
      id: 3,
      name: r'note',
      type: IsarType.string,
    )
  },
  estimateSize: _taxPaymentEstimateSize,
  serialize: _taxPaymentSerialize,
  deserialize: _taxPaymentDeserialize,
  deserializeProp: _taxPaymentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _taxPaymentGetId,
  getLinks: _taxPaymentGetLinks,
  attach: _taxPaymentAttach,
  version: '3.1.0+1',
);

int _taxPaymentEstimateSize(
  TaxPayment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.method;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _taxPaymentSerialize(
  TaxPayment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amountMinor);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.method);
  writer.writeString(offsets[3], object.note);
}

TaxPayment _taxPaymentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaxPayment();
  object.amountMinor = reader.readLong(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.id = id;
  object.method = reader.readStringOrNull(offsets[2]);
  object.note = reader.readStringOrNull(offsets[3]);
  return object;
}

P _taxPaymentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _taxPaymentGetId(TaxPayment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taxPaymentGetLinks(TaxPayment object) {
  return [];
}

void _taxPaymentAttach(IsarCollection<dynamic> col, Id id, TaxPayment object) {
  object.id = id;
}

extension TaxPaymentQueryWhereSort
    on QueryBuilder<TaxPayment, TaxPayment, QWhere> {
  QueryBuilder<TaxPayment, TaxPayment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TaxPaymentQueryWhere
    on QueryBuilder<TaxPayment, TaxPayment, QWhereClause> {
  QueryBuilder<TaxPayment, TaxPayment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterWhereClause> idBetween(
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

extension TaxPaymentQueryFilter
    on QueryBuilder<TaxPayment, TaxPayment, QFilterCondition> {
  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition>
      amountMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition>
      amountMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition>
      amountMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition>
      amountMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'method',
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition>
      methodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'method',
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'method',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'method',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> methodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'method',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition>
      methodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'method',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteEqualTo(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteGreaterThan(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteLessThan(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteBetween(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteStartsWith(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteEndsWith(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteContains(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteMatches(
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

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }
}

extension TaxPaymentQueryObject
    on QueryBuilder<TaxPayment, TaxPayment, QFilterCondition> {}

extension TaxPaymentQueryLinks
    on QueryBuilder<TaxPayment, TaxPayment, QFilterCondition> {}

extension TaxPaymentQuerySortBy
    on QueryBuilder<TaxPayment, TaxPayment, QSortBy> {
  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> sortByAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.asc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> sortByAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.desc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> sortByMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.asc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> sortByMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.desc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension TaxPaymentQuerySortThenBy
    on QueryBuilder<TaxPayment, TaxPayment, QSortThenBy> {
  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenByAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.asc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenByAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.desc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenByMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.asc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenByMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.desc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension TaxPaymentQueryWhereDistinct
    on QueryBuilder<TaxPayment, TaxPayment, QDistinct> {
  QueryBuilder<TaxPayment, TaxPayment, QDistinct> distinctByAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountMinor');
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QDistinct> distinctByMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'method', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxPayment, TaxPayment, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }
}

extension TaxPaymentQueryProperty
    on QueryBuilder<TaxPayment, TaxPayment, QQueryProperty> {
  QueryBuilder<TaxPayment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaxPayment, int, QQueryOperations> amountMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountMinor');
    });
  }

  QueryBuilder<TaxPayment, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<TaxPayment, String?, QQueryOperations> methodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'method');
    });
  }

  QueryBuilder<TaxPayment, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }
}
