// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FeedData.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class FavoriteFeedData extends DataClass
    implements Insertable<FavoriteFeedData> {
  final int id;
  final String title;
  final String link;
  final String cover;
  final String content;
  final double sentiment;
  final DateTime postedTime;
  final String publiser;
  FavoriteFeedData(
      {@required this.id,
      this.title,
      @required this.link,
      this.cover,
      @required this.content,
      this.sentiment,
      @required this.postedTime,
      @required this.publiser});
  factory FavoriteFeedData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return FavoriteFeedData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      link: stringType.mapFromDatabaseResponse(data['${effectivePrefix}link']),
      cover:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}cover']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      sentiment: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}sentiment']),
      postedTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}posted_time']),
      publiser: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}publiser']),
    );
  }
  factory FavoriteFeedData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return FavoriteFeedData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      link: serializer.fromJson<String>(json['link']),
      cover: serializer.fromJson<String>(json['cover']),
      content: serializer.fromJson<String>(json['content']),
      sentiment: serializer.fromJson<double>(json['sentiment']),
      postedTime: serializer.fromJson<DateTime>(json['postedTime']),
      publiser: serializer.fromJson<String>(json['publiser']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'link': serializer.toJson<String>(link),
      'cover': serializer.toJson<String>(cover),
      'content': serializer.toJson<String>(content),
      'sentiment': serializer.toJson<double>(sentiment),
      'postedTime': serializer.toJson<DateTime>(postedTime),
      'publiser': serializer.toJson<String>(publiser),
    };
  }

  @override
  FavoriteFeedCompanion createCompanion(bool nullToAbsent) {
    return FavoriteFeedCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      sentiment: sentiment == null && nullToAbsent
          ? const Value.absent()
          : Value(sentiment),
      postedTime: postedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(postedTime),
      publiser: publiser == null && nullToAbsent
          ? const Value.absent()
          : Value(publiser),
    );
  }

  FavoriteFeedData copyWith(
          {int id,
          String title,
          String link,
          String cover,
          String content,
          double sentiment,
          DateTime postedTime,
          String publiser}) =>
      FavoriteFeedData(
        id: id ?? this.id,
        title: title ?? this.title,
        link: link ?? this.link,
        cover: cover ?? this.cover,
        content: content ?? this.content,
        sentiment: sentiment ?? this.sentiment,
        postedTime: postedTime ?? this.postedTime,
        publiser: publiser ?? this.publiser,
      );
  @override
  String toString() {
    return (StringBuffer('FavoriteFeedData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('link: $link, ')
          ..write('cover: $cover, ')
          ..write('content: $content, ')
          ..write('sentiment: $sentiment, ')
          ..write('postedTime: $postedTime, ')
          ..write('publiser: $publiser')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              link.hashCode,
              $mrjc(
                  cover.hashCode,
                  $mrjc(
                      content.hashCode,
                      $mrjc(sentiment.hashCode,
                          $mrjc(postedTime.hashCode, publiser.hashCode))))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is FavoriteFeedData &&
          other.id == this.id &&
          other.title == this.title &&
          other.link == this.link &&
          other.cover == this.cover &&
          other.content == this.content &&
          other.sentiment == this.sentiment &&
          other.postedTime == this.postedTime &&
          other.publiser == this.publiser);
}

class FavoriteFeedCompanion extends UpdateCompanion<FavoriteFeedData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> link;
  final Value<String> cover;
  final Value<String> content;
  final Value<double> sentiment;
  final Value<DateTime> postedTime;
  final Value<String> publiser;
  const FavoriteFeedCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.link = const Value.absent(),
    this.cover = const Value.absent(),
    this.content = const Value.absent(),
    this.sentiment = const Value.absent(),
    this.postedTime = const Value.absent(),
    this.publiser = const Value.absent(),
  });
  FavoriteFeedCompanion.insert({
    @required int id,
    this.title = const Value.absent(),
    @required String link,
    this.cover = const Value.absent(),
    @required String content,
    this.sentiment = const Value.absent(),
    @required DateTime postedTime,
    @required String publiser,
  })  : id = Value(id),
        link = Value(link),
        content = Value(content),
        postedTime = Value(postedTime),
        publiser = Value(publiser);
  FavoriteFeedCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<String> link,
      Value<String> cover,
      Value<String> content,
      Value<double> sentiment,
      Value<DateTime> postedTime,
      Value<String> publiser}) {
    return FavoriteFeedCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      cover: cover ?? this.cover,
      content: content ?? this.content,
      sentiment: sentiment ?? this.sentiment,
      postedTime: postedTime ?? this.postedTime,
      publiser: publiser ?? this.publiser,
    );
  }
}

class $FavoriteFeedTable extends FavoriteFeed
    with TableInfo<$FavoriteFeedTable, FavoriteFeedData> {
  final GeneratedDatabase _db;
  final String _alias;
  $FavoriteFeedTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      true,
    );
  }

  final VerificationMeta _linkMeta = const VerificationMeta('link');
  GeneratedTextColumn _link;
  @override
  GeneratedTextColumn get link => _link ??= _constructLink();
  GeneratedTextColumn _constructLink() {
    return GeneratedTextColumn(
      'link',
      $tableName,
      false,
    );
  }

  final VerificationMeta _coverMeta = const VerificationMeta('cover');
  GeneratedTextColumn _cover;
  @override
  GeneratedTextColumn get cover => _cover ??= _constructCover();
  GeneratedTextColumn _constructCover() {
    return GeneratedTextColumn(
      'cover',
      $tableName,
      true,
    );
  }

  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedTextColumn _content;
  @override
  GeneratedTextColumn get content => _content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      false,
    );
  }

  final VerificationMeta _sentimentMeta = const VerificationMeta('sentiment');
  GeneratedRealColumn _sentiment;
  @override
  GeneratedRealColumn get sentiment => _sentiment ??= _constructSentiment();
  GeneratedRealColumn _constructSentiment() {
    return GeneratedRealColumn(
      'sentiment',
      $tableName,
      true,
    );
  }

  final VerificationMeta _postedTimeMeta = const VerificationMeta('postedTime');
  GeneratedDateTimeColumn _postedTime;
  @override
  GeneratedDateTimeColumn get postedTime =>
      _postedTime ??= _constructPostedTime();
  GeneratedDateTimeColumn _constructPostedTime() {
    return GeneratedDateTimeColumn(
      'posted_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _publiserMeta = const VerificationMeta('publiser');
  GeneratedTextColumn _publiser;
  @override
  GeneratedTextColumn get publiser => _publiser ??= _constructPubliser();
  GeneratedTextColumn _constructPubliser() {
    return GeneratedTextColumn(
      'publiser',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, title, link, cover, content, sentiment, postedTime, publiser];
  @override
  $FavoriteFeedTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'favorite_feed';
  @override
  final String actualTableName = 'favorite_feed';
  @override
  VerificationContext validateIntegrity(FavoriteFeedCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (title.isRequired && isInserting) {
      context.missing(_titleMeta);
    }
    if (d.link.present) {
      context.handle(
          _linkMeta, link.isAcceptableValue(d.link.value, _linkMeta));
    } else if (link.isRequired && isInserting) {
      context.missing(_linkMeta);
    }
    if (d.cover.present) {
      context.handle(
          _coverMeta, cover.isAcceptableValue(d.cover.value, _coverMeta));
    } else if (cover.isRequired && isInserting) {
      context.missing(_coverMeta);
    }
    if (d.content.present) {
      context.handle(_contentMeta,
          content.isAcceptableValue(d.content.value, _contentMeta));
    } else if (content.isRequired && isInserting) {
      context.missing(_contentMeta);
    }
    if (d.sentiment.present) {
      context.handle(_sentimentMeta,
          sentiment.isAcceptableValue(d.sentiment.value, _sentimentMeta));
    } else if (sentiment.isRequired && isInserting) {
      context.missing(_sentimentMeta);
    }
    if (d.postedTime.present) {
      context.handle(_postedTimeMeta,
          postedTime.isAcceptableValue(d.postedTime.value, _postedTimeMeta));
    } else if (postedTime.isRequired && isInserting) {
      context.missing(_postedTimeMeta);
    }
    if (d.publiser.present) {
      context.handle(_publiserMeta,
          publiser.isAcceptableValue(d.publiser.value, _publiserMeta));
    } else if (publiser.isRequired && isInserting) {
      context.missing(_publiserMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoriteFeedData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return FavoriteFeedData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(FavoriteFeedCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.link.present) {
      map['link'] = Variable<String, StringType>(d.link.value);
    }
    if (d.cover.present) {
      map['cover'] = Variable<String, StringType>(d.cover.value);
    }
    if (d.content.present) {
      map['content'] = Variable<String, StringType>(d.content.value);
    }
    if (d.sentiment.present) {
      map['sentiment'] = Variable<double, RealType>(d.sentiment.value);
    }
    if (d.postedTime.present) {
      map['posted_time'] = Variable<DateTime, DateTimeType>(d.postedTime.value);
    }
    if (d.publiser.present) {
      map['publiser'] = Variable<String, StringType>(d.publiser.value);
    }
    return map;
  }

  @override
  $FavoriteFeedTable createAlias(String alias) {
    return $FavoriteFeedTable(_db, alias);
  }
}

class FeedSourceData extends DataClass implements Insertable<FeedSourceData> {
  final int id;
  final String name;
  final String link;
  FeedSourceData({@required this.id, @required this.name, @required this.link});
  factory FeedSourceData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return FeedSourceData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      link: stringType.mapFromDatabaseResponse(data['${effectivePrefix}link']),
    );
  }
  factory FeedSourceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return FeedSourceData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      link: serializer.fromJson<String>(json['link']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'link': serializer.toJson<String>(link),
    };
  }

  @override
  FeedSourceCompanion createCompanion(bool nullToAbsent) {
    return FeedSourceCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
    );
  }

  FeedSourceData copyWith({int id, String name, String link}) => FeedSourceData(
        id: id ?? this.id,
        name: name ?? this.name,
        link: link ?? this.link,
      );
  @override
  String toString() {
    return (StringBuffer('FeedSourceData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('link: $link')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, link.hashCode)));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is FeedSourceData &&
          other.id == this.id &&
          other.name == this.name &&
          other.link == this.link);
}

class FeedSourceCompanion extends UpdateCompanion<FeedSourceData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> link;
  const FeedSourceCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.link = const Value.absent(),
  });
  FeedSourceCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String link,
  })  : name = Value(name),
        link = Value(link);
  FeedSourceCompanion copyWith(
      {Value<int> id, Value<String> name, Value<String> link}) {
    return FeedSourceCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }
}

class $FeedSourceTable extends FeedSource
    with TableInfo<$FeedSourceTable, FeedSourceData> {
  final GeneratedDatabase _db;
  final String _alias;
  $FeedSourceTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  final VerificationMeta _linkMeta = const VerificationMeta('link');
  GeneratedTextColumn _link;
  @override
  GeneratedTextColumn get link => _link ??= _constructLink();
  GeneratedTextColumn _constructLink() {
    return GeneratedTextColumn(
      'link',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, link];
  @override
  $FeedSourceTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'feed_source';
  @override
  final String actualTableName = 'feed_source';
  @override
  VerificationContext validateIntegrity(FeedSourceCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.link.present) {
      context.handle(
          _linkMeta, link.isAcceptableValue(d.link.value, _linkMeta));
    } else if (link.isRequired && isInserting) {
      context.missing(_linkMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedSourceData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return FeedSourceData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(FeedSourceCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.link.present) {
      map['link'] = Variable<String, StringType>(d.link.value);
    }
    return map;
  }

  @override
  $FeedSourceTable createAlias(String alias) {
    return $FeedSourceTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $FavoriteFeedTable _favoriteFeed;
  $FavoriteFeedTable get favoriteFeed =>
      _favoriteFeed ??= $FavoriteFeedTable(this);
  $FeedSourceTable _feedSource;
  $FeedSourceTable get feedSource => _feedSource ??= $FeedSourceTable(this);
  @override
  List<TableInfo> get allTables => [favoriteFeed, feedSource];
}
