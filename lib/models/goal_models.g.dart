// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMonthlyGoalCollection on Isar {
  IsarCollection<MonthlyGoal> get monthlyGoals => this.collection();
}

const MonthlyGoalSchema = CollectionSchema(
  name: r'MonthlyGoal',
  id: 8271761936404564288,
  properties: {
    r'monthKey': PropertySchema(
      id: 0,
      name: r'monthKey',
      type: IsarType.string,
    ),
    r'strategies': PropertySchema(
      id: 1,
      name: r'strategies',
      type: IsarType.objectList,
      target: r'GoalStrategyItem',
    ),
    r'targetAmountMinor': PropertySchema(
      id: 2,
      name: r'targetAmountMinor',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 3,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _monthlyGoalEstimateSize,
  serialize: _monthlyGoalSerialize,
  deserialize: _monthlyGoalDeserialize,
  deserializeProp: _monthlyGoalDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'GoalStrategyItem': GoalStrategyItemSchema},
  getId: _monthlyGoalGetId,
  getLinks: _monthlyGoalGetLinks,
  attach: _monthlyGoalAttach,
  version: '3.1.0+1',
);

int _monthlyGoalEstimateSize(
  MonthlyGoal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.monthKey.length * 3;
  bytesCount += 3 + object.strategies.length * 3;
  {
    final offsets = allOffsets[GoalStrategyItem]!;
    for (var i = 0; i < object.strategies.length; i++) {
      final value = object.strategies[i];
      bytesCount +=
          GoalStrategyItemSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _monthlyGoalSerialize(
  MonthlyGoal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.monthKey);
  writer.writeObjectList<GoalStrategyItem>(
    offsets[1],
    allOffsets,
    GoalStrategyItemSchema.serialize,
    object.strategies,
  );
  writer.writeLong(offsets[2], object.targetAmountMinor);
  writer.writeString(offsets[3], object.userId);
}

MonthlyGoal _monthlyGoalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MonthlyGoal();
  object.id = id;
  object.monthKey = reader.readString(offsets[0]);
  object.strategies = reader.readObjectList<GoalStrategyItem>(
        offsets[1],
        GoalStrategyItemSchema.deserialize,
        allOffsets,
        GoalStrategyItem(),
      ) ??
      [];
  object.targetAmountMinor = reader.readLong(offsets[2]);
  object.userId = reader.readString(offsets[3]);
  return object;
}

P _monthlyGoalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readObjectList<GoalStrategyItem>(
            offset,
            GoalStrategyItemSchema.deserialize,
            allOffsets,
            GoalStrategyItem(),
          ) ??
          []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _monthlyGoalGetId(MonthlyGoal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _monthlyGoalGetLinks(MonthlyGoal object) {
  return [];
}

void _monthlyGoalAttach(
    IsarCollection<dynamic> col, Id id, MonthlyGoal object) {
  object.id = id;
}

extension MonthlyGoalQueryWhereSort
    on QueryBuilder<MonthlyGoal, MonthlyGoal, QWhere> {
  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MonthlyGoalQueryWhere
    on QueryBuilder<MonthlyGoal, MonthlyGoal, QWhereClause> {
  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterWhereClause> idBetween(
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

extension MonthlyGoalQueryFilter
    on QueryBuilder<MonthlyGoal, MonthlyGoal, QFilterCondition> {
  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> monthKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      monthKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      monthKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> monthKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      monthKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      monthKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      monthKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> monthKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'monthKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      monthKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      monthKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'monthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      strategiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strategies',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      strategiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strategies',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      strategiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strategies',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      strategiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strategies',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      strategiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strategies',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      strategiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strategies',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      targetAmountMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      targetAmountMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      targetAmountMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      targetAmountMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetAmountMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension MonthlyGoalQueryObject
    on QueryBuilder<MonthlyGoal, MonthlyGoal, QFilterCondition> {
  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterFilterCondition>
      strategiesElement(FilterQuery<GoalStrategyItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'strategies');
    });
  }
}

extension MonthlyGoalQueryLinks
    on QueryBuilder<MonthlyGoal, MonthlyGoal, QFilterCondition> {}

extension MonthlyGoalQuerySortBy
    on QueryBuilder<MonthlyGoal, MonthlyGoal, QSortBy> {
  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> sortByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> sortByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy>
      sortByTargetAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy>
      sortByTargetAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmountMinor', Sort.desc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension MonthlyGoalQuerySortThenBy
    on QueryBuilder<MonthlyGoal, MonthlyGoal, QSortThenBy> {
  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> thenByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> thenByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy>
      thenByTargetAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy>
      thenByTargetAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetAmountMinor', Sort.desc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension MonthlyGoalQueryWhereDistinct
    on QueryBuilder<MonthlyGoal, MonthlyGoal, QDistinct> {
  QueryBuilder<MonthlyGoal, MonthlyGoal, QDistinct> distinctByMonthKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QDistinct>
      distinctByTargetAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetAmountMinor');
    });
  }

  QueryBuilder<MonthlyGoal, MonthlyGoal, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension MonthlyGoalQueryProperty
    on QueryBuilder<MonthlyGoal, MonthlyGoal, QQueryProperty> {
  QueryBuilder<MonthlyGoal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MonthlyGoal, String, QQueryOperations> monthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthKey');
    });
  }

  QueryBuilder<MonthlyGoal, List<GoalStrategyItem>, QQueryOperations>
      strategiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'strategies');
    });
  }

  QueryBuilder<MonthlyGoal, int, QQueryOperations> targetAmountMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetAmountMinor');
    });
  }

  QueryBuilder<MonthlyGoal, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const GoalStrategyItemSchema = Schema(
  name: r'GoalStrategyItem',
  id: 7241312517401992137,
  properties: {
    r'title': PropertySchema(
      id: 0,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _goalStrategyItemEstimateSize,
  serialize: _goalStrategyItemSerialize,
  deserialize: _goalStrategyItemDeserialize,
  deserializeProp: _goalStrategyItemDeserializeProp,
);

int _goalStrategyItemEstimateSize(
  GoalStrategyItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _goalStrategyItemSerialize(
  GoalStrategyItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.title);
}

GoalStrategyItem _goalStrategyItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GoalStrategyItem();
  object.title = reader.readString(offsets[0]);
  return object;
}

P _goalStrategyItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension GoalStrategyItemQueryFilter
    on QueryBuilder<GoalStrategyItem, GoalStrategyItem, QFilterCondition> {
  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<GoalStrategyItem, GoalStrategyItem, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension GoalStrategyItemQueryObject
    on QueryBuilder<GoalStrategyItem, GoalStrategyItem, QFilterCondition> {}
