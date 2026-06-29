// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserStatsModelCollection on Isar {
  IsarCollection<UserStatsModel> get userStatsModels => this.collection();
}

const UserStatsModelSchema = CollectionSchema(
  name: r'UserStatsModel',
  id: 272209145262056414,
  properties: {
    r'currentStreak': PropertySchema(
      id: 0,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'lastSessionDate': PropertySchema(
      id: 1,
      name: r'lastSessionDate',
      type: IsarType.string,
    ),
    r'profileXp': PropertySchema(
      id: 2,
      name: r'profileXp',
      type: IsarType.long,
    ),
    r'totalMinutes': PropertySchema(
      id: 3,
      name: r'totalMinutes',
      type: IsarType.long,
    ),
    r'totalSessions': PropertySchema(
      id: 4,
      name: r'totalSessions',
      type: IsarType.long,
    ),
  },
  estimateSize: _userStatsModelEstimateSize,
  serialize: _userStatsModelSerialize,
  deserialize: _userStatsModelDeserialize,
  deserializeProp: _userStatsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userStatsModelGetId,
  getLinks: _userStatsModelGetLinks,
  attach: _userStatsModelAttach,
  version: '3.1.0+1',
);

int _userStatsModelEstimateSize(
  UserStatsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lastSessionDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _userStatsModelSerialize(
  UserStatsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentStreak);
  writer.writeString(offsets[1], object.lastSessionDate);
  writer.writeLong(offsets[2], object.profileXp);
  writer.writeLong(offsets[3], object.totalMinutes);
  writer.writeLong(offsets[4], object.totalSessions);
}

UserStatsModel _userStatsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserStatsModel();
  object.currentStreak = reader.readLong(offsets[0]);
  object.id = id;
  object.lastSessionDate = reader.readStringOrNull(offsets[1]);
  object.profileXp = reader.readLong(offsets[2]);
  object.totalMinutes = reader.readLong(offsets[3]);
  object.totalSessions = reader.readLong(offsets[4]);
  return object;
}

P _userStatsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userStatsModelGetId(UserStatsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userStatsModelGetLinks(UserStatsModel object) {
  return [];
}

void _userStatsModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserStatsModel object,
) {
  object.id = id;
}

extension UserStatsModelQueryWhereSort
    on QueryBuilder<UserStatsModel, UserStatsModel, QWhere> {
  QueryBuilder<UserStatsModel, UserStatsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserStatsModelQueryWhere
    on QueryBuilder<UserStatsModel, UserStatsModel, QWhereClause> {
  QueryBuilder<UserStatsModel, UserStatsModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension UserStatsModelQueryFilter
    on QueryBuilder<UserStatsModel, UserStatsModel, QFilterCondition> {
  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentStreak', value: value),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  currentStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  currentStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSessionDate'),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSessionDate'),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastSessionDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSessionDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSessionDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSessionDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastSessionDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastSessionDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastSessionDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastSessionDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSessionDate', value: ''),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  lastSessionDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastSessionDate', value: ''),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  profileXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'profileXp', value: value),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  profileXpGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'profileXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  profileXpLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'profileXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  profileXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'profileXp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  totalMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalMinutes', value: value),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  totalMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  totalMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  totalMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  totalSessionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalSessions', value: value),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  totalSessionsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalSessions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  totalSessionsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalSessions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterFilterCondition>
  totalSessionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalSessions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension UserStatsModelQueryObject
    on QueryBuilder<UserStatsModel, UserStatsModel, QFilterCondition> {}

extension UserStatsModelQueryLinks
    on QueryBuilder<UserStatsModel, UserStatsModel, QFilterCondition> {}

extension UserStatsModelQuerySortBy
    on QueryBuilder<UserStatsModel, UserStatsModel, QSortBy> {
  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  sortByLastSessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSessionDate', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  sortByLastSessionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSessionDate', Sort.desc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy> sortByProfileXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileXp', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  sortByProfileXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileXp', Sort.desc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  sortByTotalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  sortByTotalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  sortByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  sortByTotalSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.desc);
    });
  }
}

extension UserStatsModelQuerySortThenBy
    on QueryBuilder<UserStatsModel, UserStatsModel, QSortThenBy> {
  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  thenByLastSessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSessionDate', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  thenByLastSessionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSessionDate', Sort.desc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy> thenByProfileXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileXp', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  thenByProfileXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileXp', Sort.desc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  thenByTotalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  thenByTotalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  thenByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.asc);
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QAfterSortBy>
  thenByTotalSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.desc);
    });
  }
}

extension UserStatsModelQueryWhereDistinct
    on QueryBuilder<UserStatsModel, UserStatsModel, QDistinct> {
  QueryBuilder<UserStatsModel, UserStatsModel, QDistinct>
  distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QDistinct>
  distinctByLastSessionDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastSessionDate',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QDistinct>
  distinctByProfileXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileXp');
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QDistinct>
  distinctByTotalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalMinutes');
    });
  }

  QueryBuilder<UserStatsModel, UserStatsModel, QDistinct>
  distinctByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSessions');
    });
  }
}

extension UserStatsModelQueryProperty
    on QueryBuilder<UserStatsModel, UserStatsModel, QQueryProperty> {
  QueryBuilder<UserStatsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserStatsModel, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<UserStatsModel, String?, QQueryOperations>
  lastSessionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSessionDate');
    });
  }

  QueryBuilder<UserStatsModel, int, QQueryOperations> profileXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileXp');
    });
  }

  QueryBuilder<UserStatsModel, int, QQueryOperations> totalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalMinutes');
    });
  }

  QueryBuilder<UserStatsModel, int, QQueryOperations> totalSessionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSessions');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTimelineRecordModelCollection on Isar {
  IsarCollection<TimelineRecordModel> get timelineRecordModels =>
      this.collection();
}

const TimelineRecordModelSchema = CollectionSchema(
  name: r'TimelineRecordModel',
  id: -8318120593155282803,
  properties: {
    r'duration': PropertySchema(
      id: 0,
      name: r'duration',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 1,
      name: r'timestamp',
      type: IsarType.long,
    ),
    r'title': PropertySchema(id: 2, name: r'title', type: IsarType.string),
    r'type': PropertySchema(id: 3, name: r'type', type: IsarType.string),
  },
  estimateSize: _timelineRecordModelEstimateSize,
  serialize: _timelineRecordModelSerialize,
  deserialize: _timelineRecordModelDeserialize,
  deserializeProp: _timelineRecordModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _timelineRecordModelGetId,
  getLinks: _timelineRecordModelGetLinks,
  attach: _timelineRecordModelAttach,
  version: '3.1.0+1',
);

int _timelineRecordModelEstimateSize(
  TimelineRecordModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.duration.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _timelineRecordModelSerialize(
  TimelineRecordModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.duration);
  writer.writeLong(offsets[1], object.timestamp);
  writer.writeString(offsets[2], object.title);
  writer.writeString(offsets[3], object.type);
}

TimelineRecordModel _timelineRecordModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TimelineRecordModel();
  object.duration = reader.readString(offsets[0]);
  object.id = id;
  object.timestamp = reader.readLong(offsets[1]);
  object.title = reader.readString(offsets[2]);
  object.type = reader.readString(offsets[3]);
  return object;
}

P _timelineRecordModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _timelineRecordModelGetId(TimelineRecordModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _timelineRecordModelGetLinks(
  TimelineRecordModel object,
) {
  return [];
}

void _timelineRecordModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  TimelineRecordModel object,
) {
  object.id = id;
}

extension TimelineRecordModelQueryWhereSort
    on QueryBuilder<TimelineRecordModel, TimelineRecordModel, QWhere> {
  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TimelineRecordModelQueryWhere
    on QueryBuilder<TimelineRecordModel, TimelineRecordModel, QWhereClause> {
  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterWhereClause>
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

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TimelineRecordModelQueryFilter
    on
        QueryBuilder<
          TimelineRecordModel,
          TimelineRecordModel,
          QFilterCondition
        > {
  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'duration',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'duration',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'duration',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'duration',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'duration',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'duration',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'duration',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'duration',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'duration', value: ''),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  durationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'duration', value: ''),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  timestampEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestamp', value: value),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  timestampGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  timestampLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  timestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timestamp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterFilterCondition>
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }
}

extension TimelineRecordModelQueryObject
    on
        QueryBuilder<
          TimelineRecordModel,
          TimelineRecordModel,
          QFilterCondition
        > {}

extension TimelineRecordModelQueryLinks
    on
        QueryBuilder<
          TimelineRecordModel,
          TimelineRecordModel,
          QFilterCondition
        > {}

extension TimelineRecordModelQuerySortBy
    on QueryBuilder<TimelineRecordModel, TimelineRecordModel, QSortBy> {
  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TimelineRecordModelQuerySortThenBy
    on QueryBuilder<TimelineRecordModel, TimelineRecordModel, QSortThenBy> {
  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TimelineRecordModelQueryWhereDistinct
    on QueryBuilder<TimelineRecordModel, TimelineRecordModel, QDistinct> {
  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QDistinct>
  distinctByDuration({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QDistinct>
  distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TimelineRecordModel, TimelineRecordModel, QDistinct>
  distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension TimelineRecordModelQueryProperty
    on QueryBuilder<TimelineRecordModel, TimelineRecordModel, QQueryProperty> {
  QueryBuilder<TimelineRecordModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TimelineRecordModel, String, QQueryOperations>
  durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<TimelineRecordModel, int, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<TimelineRecordModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<TimelineRecordModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
