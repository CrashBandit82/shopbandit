// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $CatalogItemsTable extends CatalogItems
    with TableInfo<$CatalogItemsTable, CatalogItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdMeta = const VerificationMeta(
    'household',
  );
  @override
  late final GeneratedColumn<String> household = GeneratedColumn<String>(
    'household',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameNormalizedMeta = const VerificationMeta(
    'nameNormalized',
  );
  @override
  late final GeneratedColumn<String> nameNormalized = GeneratedColumn<String>(
    'name_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseCountMeta = const VerificationMeta(
    'purchaseCount',
  );
  @override
  late final GeneratedColumn<int> purchaseCount = GeneratedColumn<int>(
    'purchase_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPurchasedMeta = const VerificationMeta(
    'lastPurchased',
  );
  @override
  late final GeneratedColumn<DateTime> lastPurchased =
      GeneratedColumn<DateTime>(
        'last_purchased',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  @override
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    household,
    name,
    nameNormalized,
    purchaseCount,
    lastPurchased,
    deleted,
    updated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household')) {
      context.handle(
        _householdMeta,
        household.isAcceptableOrUnknown(data['household']!, _householdMeta),
      );
    } else if (isInserting) {
      context.missing(_householdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_normalized')) {
      context.handle(
        _nameNormalizedMeta,
        nameNormalized.isAcceptableOrUnknown(
          data['name_normalized']!,
          _nameNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameNormalizedMeta);
    }
    if (data.containsKey('purchase_count')) {
      context.handle(
        _purchaseCountMeta,
        purchaseCount.isAcceptableOrUnknown(
          data['purchase_count']!,
          _purchaseCountMeta,
        ),
      );
    }
    if (data.containsKey('last_purchased')) {
      context.handle(
        _lastPurchasedMeta,
        lastPurchased.isAcceptableOrUnknown(
          data['last_purchased']!,
          _lastPurchasedMeta,
        ),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      household: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_normalized'],
      )!,
      purchaseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_count'],
      )!,
      lastPurchased: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_purchased'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
    );
  }

  @override
  $CatalogItemsTable createAlias(String alias) {
    return $CatalogItemsTable(attachedDatabase, alias);
  }
}

class CatalogItem extends DataClass implements Insertable<CatalogItem> {
  final String id;
  final String household;
  final String name;
  final String nameNormalized;
  final int purchaseCount;
  final DateTime? lastPurchased;
  final bool deleted;

  /// Server `updated` (PocketBase date string), empty until first sync.
  final String updated;
  const CatalogItem({
    required this.id,
    required this.household,
    required this.name,
    required this.nameNormalized,
    required this.purchaseCount,
    this.lastPurchased,
    required this.deleted,
    required this.updated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household'] = Variable<String>(household);
    map['name'] = Variable<String>(name);
    map['name_normalized'] = Variable<String>(nameNormalized);
    map['purchase_count'] = Variable<int>(purchaseCount);
    if (!nullToAbsent || lastPurchased != null) {
      map['last_purchased'] = Variable<DateTime>(lastPurchased);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['updated'] = Variable<String>(updated);
    return map;
  }

  CatalogItemsCompanion toCompanion(bool nullToAbsent) {
    return CatalogItemsCompanion(
      id: Value(id),
      household: Value(household),
      name: Value(name),
      nameNormalized: Value(nameNormalized),
      purchaseCount: Value(purchaseCount),
      lastPurchased: lastPurchased == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPurchased),
      deleted: Value(deleted),
      updated: Value(updated),
    );
  }

  factory CatalogItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogItem(
      id: serializer.fromJson<String>(json['id']),
      household: serializer.fromJson<String>(json['household']),
      name: serializer.fromJson<String>(json['name']),
      nameNormalized: serializer.fromJson<String>(json['nameNormalized']),
      purchaseCount: serializer.fromJson<int>(json['purchaseCount']),
      lastPurchased: serializer.fromJson<DateTime?>(json['lastPurchased']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updated: serializer.fromJson<String>(json['updated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'household': serializer.toJson<String>(household),
      'name': serializer.toJson<String>(name),
      'nameNormalized': serializer.toJson<String>(nameNormalized),
      'purchaseCount': serializer.toJson<int>(purchaseCount),
      'lastPurchased': serializer.toJson<DateTime?>(lastPurchased),
      'deleted': serializer.toJson<bool>(deleted),
      'updated': serializer.toJson<String>(updated),
    };
  }

  CatalogItem copyWith({
    String? id,
    String? household,
    String? name,
    String? nameNormalized,
    int? purchaseCount,
    Value<DateTime?> lastPurchased = const Value.absent(),
    bool? deleted,
    String? updated,
  }) => CatalogItem(
    id: id ?? this.id,
    household: household ?? this.household,
    name: name ?? this.name,
    nameNormalized: nameNormalized ?? this.nameNormalized,
    purchaseCount: purchaseCount ?? this.purchaseCount,
    lastPurchased: lastPurchased.present
        ? lastPurchased.value
        : this.lastPurchased,
    deleted: deleted ?? this.deleted,
    updated: updated ?? this.updated,
  );
  CatalogItem copyWithCompanion(CatalogItemsCompanion data) {
    return CatalogItem(
      id: data.id.present ? data.id.value : this.id,
      household: data.household.present ? data.household.value : this.household,
      name: data.name.present ? data.name.value : this.name,
      nameNormalized: data.nameNormalized.present
          ? data.nameNormalized.value
          : this.nameNormalized,
      purchaseCount: data.purchaseCount.present
          ? data.purchaseCount.value
          : this.purchaseCount,
      lastPurchased: data.lastPurchased.present
          ? data.lastPurchased.value
          : this.lastPurchased,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updated: data.updated.present ? data.updated.value : this.updated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogItem(')
          ..write('id: $id, ')
          ..write('household: $household, ')
          ..write('name: $name, ')
          ..write('nameNormalized: $nameNormalized, ')
          ..write('purchaseCount: $purchaseCount, ')
          ..write('lastPurchased: $lastPurchased, ')
          ..write('deleted: $deleted, ')
          ..write('updated: $updated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    household,
    name,
    nameNormalized,
    purchaseCount,
    lastPurchased,
    deleted,
    updated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogItem &&
          other.id == this.id &&
          other.household == this.household &&
          other.name == this.name &&
          other.nameNormalized == this.nameNormalized &&
          other.purchaseCount == this.purchaseCount &&
          other.lastPurchased == this.lastPurchased &&
          other.deleted == this.deleted &&
          other.updated == this.updated);
}

class CatalogItemsCompanion extends UpdateCompanion<CatalogItem> {
  final Value<String> id;
  final Value<String> household;
  final Value<String> name;
  final Value<String> nameNormalized;
  final Value<int> purchaseCount;
  final Value<DateTime?> lastPurchased;
  final Value<bool> deleted;
  final Value<String> updated;
  final Value<int> rowid;
  const CatalogItemsCompanion({
    this.id = const Value.absent(),
    this.household = const Value.absent(),
    this.name = const Value.absent(),
    this.nameNormalized = const Value.absent(),
    this.purchaseCount = const Value.absent(),
    this.lastPurchased = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogItemsCompanion.insert({
    required String id,
    required String household,
    required String name,
    required String nameNormalized,
    this.purchaseCount = const Value.absent(),
    this.lastPurchased = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       household = Value(household),
       name = Value(name),
       nameNormalized = Value(nameNormalized);
  static Insertable<CatalogItem> custom({
    Expression<String>? id,
    Expression<String>? household,
    Expression<String>? name,
    Expression<String>? nameNormalized,
    Expression<int>? purchaseCount,
    Expression<DateTime>? lastPurchased,
    Expression<bool>? deleted,
    Expression<String>? updated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (household != null) 'household': household,
      if (name != null) 'name': name,
      if (nameNormalized != null) 'name_normalized': nameNormalized,
      if (purchaseCount != null) 'purchase_count': purchaseCount,
      if (lastPurchased != null) 'last_purchased': lastPurchased,
      if (deleted != null) 'deleted': deleted,
      if (updated != null) 'updated': updated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? household,
    Value<String>? name,
    Value<String>? nameNormalized,
    Value<int>? purchaseCount,
    Value<DateTime?>? lastPurchased,
    Value<bool>? deleted,
    Value<String>? updated,
    Value<int>? rowid,
  }) {
    return CatalogItemsCompanion(
      id: id ?? this.id,
      household: household ?? this.household,
      name: name ?? this.name,
      nameNormalized: nameNormalized ?? this.nameNormalized,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      lastPurchased: lastPurchased ?? this.lastPurchased,
      deleted: deleted ?? this.deleted,
      updated: updated ?? this.updated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (household.present) {
      map['household'] = Variable<String>(household.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameNormalized.present) {
      map['name_normalized'] = Variable<String>(nameNormalized.value);
    }
    if (purchaseCount.present) {
      map['purchase_count'] = Variable<int>(purchaseCount.value);
    }
    if (lastPurchased.present) {
      map['last_purchased'] = Variable<DateTime>(lastPurchased.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogItemsCompanion(')
          ..write('id: $id, ')
          ..write('household: $household, ')
          ..write('name: $name, ')
          ..write('nameNormalized: $nameNormalized, ')
          ..write('purchaseCount: $purchaseCount, ')
          ..write('lastPurchased: $lastPurchased, ')
          ..write('deleted: $deleted, ')
          ..write('updated: $updated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListEntriesTable extends ListEntries
    with TableInfo<$ListEntriesTable, ListEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdMeta = const VerificationMeta(
    'household',
  );
  @override
  late final GeneratedColumn<String> household = GeneratedColumn<String>(
    'household',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogItemMeta = const VerificationMeta(
    'catalogItem',
  );
  @override
  late final GeneratedColumn<String> catalogItem = GeneratedColumn<String>(
    'catalog_item',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<String> quantity = GeneratedColumn<String>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addedByMeta = const VerificationMeta(
    'addedBy',
  );
  @override
  late final GeneratedColumn<String> addedBy = GeneratedColumn<String>(
    'added_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _checkedMeta = const VerificationMeta(
    'checked',
  );
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
    'checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  @override
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    household,
    catalogItem,
    quantity,
    addedBy,
    checked,
    checkedAt,
    deleted,
    createdAt,
    updated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'list_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household')) {
      context.handle(
        _householdMeta,
        household.isAcceptableOrUnknown(data['household']!, _householdMeta),
      );
    } else if (isInserting) {
      context.missing(_householdMeta);
    }
    if (data.containsKey('catalog_item')) {
      context.handle(
        _catalogItemMeta,
        catalogItem.isAcceptableOrUnknown(
          data['catalog_item']!,
          _catalogItemMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_catalogItemMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('added_by')) {
      context.handle(
        _addedByMeta,
        addedBy.isAcceptableOrUnknown(data['added_by']!, _addedByMeta),
      );
    }
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      household: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household'],
      )!,
      catalogItem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_item'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantity'],
      )!,
      addedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}added_by'],
      )!,
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
    );
  }

  @override
  $ListEntriesTable createAlias(String alias) {
    return $ListEntriesTable(attachedDatabase, alias);
  }
}

class ListEntry extends DataClass implements Insertable<ListEntry> {
  final String id;
  final String household;
  final String catalogItem;
  final String quantity;
  final String addedBy;
  final bool checked;
  final DateTime? checkedAt;
  final bool deleted;
  final DateTime createdAt;
  final String updated;
  const ListEntry({
    required this.id,
    required this.household,
    required this.catalogItem,
    required this.quantity,
    required this.addedBy,
    required this.checked,
    this.checkedAt,
    required this.deleted,
    required this.createdAt,
    required this.updated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household'] = Variable<String>(household);
    map['catalog_item'] = Variable<String>(catalogItem);
    map['quantity'] = Variable<String>(quantity);
    map['added_by'] = Variable<String>(addedBy);
    map['checked'] = Variable<bool>(checked);
    if (!nullToAbsent || checkedAt != null) {
      map['checked_at'] = Variable<DateTime>(checkedAt);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated'] = Variable<String>(updated);
    return map;
  }

  ListEntriesCompanion toCompanion(bool nullToAbsent) {
    return ListEntriesCompanion(
      id: Value(id),
      household: Value(household),
      catalogItem: Value(catalogItem),
      quantity: Value(quantity),
      addedBy: Value(addedBy),
      checked: Value(checked),
      checkedAt: checkedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedAt),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updated: Value(updated),
    );
  }

  factory ListEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListEntry(
      id: serializer.fromJson<String>(json['id']),
      household: serializer.fromJson<String>(json['household']),
      catalogItem: serializer.fromJson<String>(json['catalogItem']),
      quantity: serializer.fromJson<String>(json['quantity']),
      addedBy: serializer.fromJson<String>(json['addedBy']),
      checked: serializer.fromJson<bool>(json['checked']),
      checkedAt: serializer.fromJson<DateTime?>(json['checkedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updated: serializer.fromJson<String>(json['updated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'household': serializer.toJson<String>(household),
      'catalogItem': serializer.toJson<String>(catalogItem),
      'quantity': serializer.toJson<String>(quantity),
      'addedBy': serializer.toJson<String>(addedBy),
      'checked': serializer.toJson<bool>(checked),
      'checkedAt': serializer.toJson<DateTime?>(checkedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updated': serializer.toJson<String>(updated),
    };
  }

  ListEntry copyWith({
    String? id,
    String? household,
    String? catalogItem,
    String? quantity,
    String? addedBy,
    bool? checked,
    Value<DateTime?> checkedAt = const Value.absent(),
    bool? deleted,
    DateTime? createdAt,
    String? updated,
  }) => ListEntry(
    id: id ?? this.id,
    household: household ?? this.household,
    catalogItem: catalogItem ?? this.catalogItem,
    quantity: quantity ?? this.quantity,
    addedBy: addedBy ?? this.addedBy,
    checked: checked ?? this.checked,
    checkedAt: checkedAt.present ? checkedAt.value : this.checkedAt,
    deleted: deleted ?? this.deleted,
    createdAt: createdAt ?? this.createdAt,
    updated: updated ?? this.updated,
  );
  ListEntry copyWithCompanion(ListEntriesCompanion data) {
    return ListEntry(
      id: data.id.present ? data.id.value : this.id,
      household: data.household.present ? data.household.value : this.household,
      catalogItem: data.catalogItem.present
          ? data.catalogItem.value
          : this.catalogItem,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      addedBy: data.addedBy.present ? data.addedBy.value : this.addedBy,
      checked: data.checked.present ? data.checked.value : this.checked,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updated: data.updated.present ? data.updated.value : this.updated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListEntry(')
          ..write('id: $id, ')
          ..write('household: $household, ')
          ..write('catalogItem: $catalogItem, ')
          ..write('quantity: $quantity, ')
          ..write('addedBy: $addedBy, ')
          ..write('checked: $checked, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updated: $updated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    household,
    catalogItem,
    quantity,
    addedBy,
    checked,
    checkedAt,
    deleted,
    createdAt,
    updated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListEntry &&
          other.id == this.id &&
          other.household == this.household &&
          other.catalogItem == this.catalogItem &&
          other.quantity == this.quantity &&
          other.addedBy == this.addedBy &&
          other.checked == this.checked &&
          other.checkedAt == this.checkedAt &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updated == this.updated);
}

class ListEntriesCompanion extends UpdateCompanion<ListEntry> {
  final Value<String> id;
  final Value<String> household;
  final Value<String> catalogItem;
  final Value<String> quantity;
  final Value<String> addedBy;
  final Value<bool> checked;
  final Value<DateTime?> checkedAt;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<String> updated;
  final Value<int> rowid;
  const ListEntriesCompanion({
    this.id = const Value.absent(),
    this.household = const Value.absent(),
    this.catalogItem = const Value.absent(),
    this.quantity = const Value.absent(),
    this.addedBy = const Value.absent(),
    this.checked = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListEntriesCompanion.insert({
    required String id,
    required String household,
    required String catalogItem,
    this.quantity = const Value.absent(),
    this.addedBy = const Value.absent(),
    this.checked = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    required DateTime createdAt,
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       household = Value(household),
       catalogItem = Value(catalogItem),
       createdAt = Value(createdAt);
  static Insertable<ListEntry> custom({
    Expression<String>? id,
    Expression<String>? household,
    Expression<String>? catalogItem,
    Expression<String>? quantity,
    Expression<String>? addedBy,
    Expression<bool>? checked,
    Expression<DateTime>? checkedAt,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<String>? updated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (household != null) 'household': household,
      if (catalogItem != null) 'catalog_item': catalogItem,
      if (quantity != null) 'quantity': quantity,
      if (addedBy != null) 'added_by': addedBy,
      if (checked != null) 'checked': checked,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updated != null) 'updated': updated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? household,
    Value<String>? catalogItem,
    Value<String>? quantity,
    Value<String>? addedBy,
    Value<bool>? checked,
    Value<DateTime?>? checkedAt,
    Value<bool>? deleted,
    Value<DateTime>? createdAt,
    Value<String>? updated,
    Value<int>? rowid,
  }) {
    return ListEntriesCompanion(
      id: id ?? this.id,
      household: household ?? this.household,
      catalogItem: catalogItem ?? this.catalogItem,
      quantity: quantity ?? this.quantity,
      addedBy: addedBy ?? this.addedBy,
      checked: checked ?? this.checked,
      checkedAt: checkedAt ?? this.checkedAt,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updated: updated ?? this.updated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (household.present) {
      map['household'] = Variable<String>(household.value);
    }
    if (catalogItem.present) {
      map['catalog_item'] = Variable<String>(catalogItem.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(quantity.value);
    }
    if (addedBy.present) {
      map['added_by'] = Variable<String>(addedBy.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListEntriesCompanion(')
          ..write('id: $id, ')
          ..write('household: $household, ')
          ..write('catalogItem: $catalogItem, ')
          ..write('quantity: $quantity, ')
          ..write('addedBy: $addedBy, ')
          ..write('checked: $checked, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updated: $updated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MembersTable extends Members with TableInfo<$MembersTable, Member> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdMeta = const VerificationMeta(
    'household',
  );
  @override
  late final GeneratedColumn<String> household = GeneratedColumn<String>(
    'household',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, household];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<Member> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('household')) {
      context.handle(
        _householdMeta,
        household.isAcceptableOrUnknown(data['household']!, _householdMeta),
      );
    } else if (isInserting) {
      context.missing(_householdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Member map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Member(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      household: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household'],
      )!,
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }
}

class Member extends DataClass implements Insertable<Member> {
  final String id;
  final String name;
  final String household;
  const Member({required this.id, required this.name, required this.household});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['household'] = Variable<String>(household);
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      name: Value(name),
      household: Value(household),
    );
  }

  factory Member.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Member(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      household: serializer.fromJson<String>(json['household']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'household': serializer.toJson<String>(household),
    };
  }

  Member copyWith({String? id, String? name, String? household}) => Member(
    id: id ?? this.id,
    name: name ?? this.name,
    household: household ?? this.household,
  );
  Member copyWithCompanion(MembersCompanion data) {
    return Member(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      household: data.household.present ? data.household.value : this.household,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Member(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('household: $household')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, household);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          other.id == this.id &&
          other.name == this.name &&
          other.household == this.household);
}

class MembersCompanion extends UpdateCompanion<Member> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> household;
  final Value<int> rowid;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.household = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String id,
    required String name,
    required String household,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       household = Value(household);
  static Insertable<Member> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? household,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (household != null) 'household': household,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? household,
    Value<int>? rowid,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      household: household ?? this.household,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (household.present) {
      map['household'] = Variable<String>(household.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('household: $household, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _collectionMeta = const VerificationMeta(
    'collection',
  );
  @override
  late final GeneratedColumn<String> collection = GeneratedColumn<String>(
    'collection',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notBeforeMeta = const VerificationMeta(
    'notBefore',
  );
  @override
  late final GeneratedColumn<DateTime> notBefore = GeneratedColumn<DateTime>(
    'not_before',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    collection,
    recordId,
    op,
    payload,
    attempts,
    notBefore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('collection')) {
      context.handle(
        _collectionMeta,
        collection.isAcceptableOrUnknown(data['collection']!, _collectionMeta),
      );
    } else if (isInserting) {
      context.missing(_collectionMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('not_before')) {
      context.handle(
        _notBeforeMeta,
        notBefore.isAcceptableOrUnknown(data['not_before']!, _notBeforeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  OutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxData(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      collection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      notBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}not_before'],
      ),
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxData extends DataClass implements Insertable<OutboxData> {
  final int seq;
  final String collection;
  final String recordId;

  /// `create` or `update`
  final String op;

  /// JSON body for the PocketBase request.
  final String payload;
  final int attempts;
  final DateTime? notBefore;
  const OutboxData({
    required this.seq,
    required this.collection,
    required this.recordId,
    required this.op,
    required this.payload,
    required this.attempts,
    this.notBefore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['collection'] = Variable<String>(collection);
    map['record_id'] = Variable<String>(recordId);
    map['op'] = Variable<String>(op);
    map['payload'] = Variable<String>(payload);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || notBefore != null) {
      map['not_before'] = Variable<DateTime>(notBefore);
    }
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      seq: Value(seq),
      collection: Value(collection),
      recordId: Value(recordId),
      op: Value(op),
      payload: Value(payload),
      attempts: Value(attempts),
      notBefore: notBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(notBefore),
    );
  }

  factory OutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxData(
      seq: serializer.fromJson<int>(json['seq']),
      collection: serializer.fromJson<String>(json['collection']),
      recordId: serializer.fromJson<String>(json['recordId']),
      op: serializer.fromJson<String>(json['op']),
      payload: serializer.fromJson<String>(json['payload']),
      attempts: serializer.fromJson<int>(json['attempts']),
      notBefore: serializer.fromJson<DateTime?>(json['notBefore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'collection': serializer.toJson<String>(collection),
      'recordId': serializer.toJson<String>(recordId),
      'op': serializer.toJson<String>(op),
      'payload': serializer.toJson<String>(payload),
      'attempts': serializer.toJson<int>(attempts),
      'notBefore': serializer.toJson<DateTime?>(notBefore),
    };
  }

  OutboxData copyWith({
    int? seq,
    String? collection,
    String? recordId,
    String? op,
    String? payload,
    int? attempts,
    Value<DateTime?> notBefore = const Value.absent(),
  }) => OutboxData(
    seq: seq ?? this.seq,
    collection: collection ?? this.collection,
    recordId: recordId ?? this.recordId,
    op: op ?? this.op,
    payload: payload ?? this.payload,
    attempts: attempts ?? this.attempts,
    notBefore: notBefore.present ? notBefore.value : this.notBefore,
  );
  OutboxData copyWithCompanion(OutboxCompanion data) {
    return OutboxData(
      seq: data.seq.present ? data.seq.value : this.seq,
      collection: data.collection.present
          ? data.collection.value
          : this.collection,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      op: data.op.present ? data.op.value : this.op,
      payload: data.payload.present ? data.payload.value : this.payload,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      notBefore: data.notBefore.present ? data.notBefore.value : this.notBefore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxData(')
          ..write('seq: $seq, ')
          ..write('collection: $collection, ')
          ..write('recordId: $recordId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('notBefore: $notBefore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(seq, collection, recordId, op, payload, attempts, notBefore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxData &&
          other.seq == this.seq &&
          other.collection == this.collection &&
          other.recordId == this.recordId &&
          other.op == this.op &&
          other.payload == this.payload &&
          other.attempts == this.attempts &&
          other.notBefore == this.notBefore);
}

class OutboxCompanion extends UpdateCompanion<OutboxData> {
  final Value<int> seq;
  final Value<String> collection;
  final Value<String> recordId;
  final Value<String> op;
  final Value<String> payload;
  final Value<int> attempts;
  final Value<DateTime?> notBefore;
  const OutboxCompanion({
    this.seq = const Value.absent(),
    this.collection = const Value.absent(),
    this.recordId = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.attempts = const Value.absent(),
    this.notBefore = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.seq = const Value.absent(),
    required String collection,
    required String recordId,
    required String op,
    required String payload,
    this.attempts = const Value.absent(),
    this.notBefore = const Value.absent(),
  }) : collection = Value(collection),
       recordId = Value(recordId),
       op = Value(op),
       payload = Value(payload);
  static Insertable<OutboxData> custom({
    Expression<int>? seq,
    Expression<String>? collection,
    Expression<String>? recordId,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<int>? attempts,
    Expression<DateTime>? notBefore,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (collection != null) 'collection': collection,
      if (recordId != null) 'record_id': recordId,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (attempts != null) 'attempts': attempts,
      if (notBefore != null) 'not_before': notBefore,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? seq,
    Value<String>? collection,
    Value<String>? recordId,
    Value<String>? op,
    Value<String>? payload,
    Value<int>? attempts,
    Value<DateTime?>? notBefore,
  }) {
    return OutboxCompanion(
      seq: seq ?? this.seq,
      collection: collection ?? this.collection,
      recordId: recordId ?? this.recordId,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      attempts: attempts ?? this.attempts,
      notBefore: notBefore ?? this.notBefore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (collection.present) {
      map['collection'] = Variable<String>(collection.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (notBefore.present) {
      map['not_before'] = Variable<DateTime>(notBefore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('seq: $seq, ')
          ..write('collection: $collection, ')
          ..write('recordId: $recordId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('notBefore: $notBefore')
          ..write(')'))
        .toString();
  }
}

class $MetaTable extends Meta with TableInfo<$MetaTable, MetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $MetaTable createAlias(String alias) {
    return $MetaTable(attachedDatabase, alias);
  }
}

class MetaData extends DataClass implements Insertable<MetaData> {
  final String key;
  final String value;
  const MetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetaCompanion toCompanion(bool nullToAbsent) {
    return MetaCompanion(key: Value(key), value: Value(value));
  }

  factory MetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetaData copyWith({String? key, String? value}) =>
      MetaData(key: key ?? this.key, value: value ?? this.value);
  MetaData copyWithCompanion(MetaCompanion data) {
    return MetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaData && other.key == this.key && other.value == this.value);
}

class MetaCompanion extends UpdateCompanion<MetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatalogItemsTable catalogItems = $CatalogItemsTable(this);
  late final $ListEntriesTable listEntries = $ListEntriesTable(this);
  late final $MembersTable members = $MembersTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $MetaTable meta = $MetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogItems,
    listEntries,
    members,
    outbox,
    meta,
  ];
}

typedef $$CatalogItemsTableCreateCompanionBuilder =
    CatalogItemsCompanion Function({
      required String id,
      required String household,
      required String name,
      required String nameNormalized,
      Value<int> purchaseCount,
      Value<DateTime?> lastPurchased,
      Value<bool> deleted,
      Value<String> updated,
      Value<int> rowid,
    });
typedef $$CatalogItemsTableUpdateCompanionBuilder =
    CatalogItemsCompanion Function({
      Value<String> id,
      Value<String> household,
      Value<String> name,
      Value<String> nameNormalized,
      Value<int> purchaseCount,
      Value<DateTime?> lastPurchased,
      Value<bool> deleted,
      Value<String> updated,
      Value<int> rowid,
    });

class $$CatalogItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogItemsTable> {
  $$CatalogItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get household => $composableBuilder(
    column: $table.household,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchaseCount => $composableBuilder(
    column: $table.purchaseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPurchased => $composableBuilder(
    column: $table.lastPurchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogItemsTable> {
  $$CatalogItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get household => $composableBuilder(
    column: $table.household,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchaseCount => $composableBuilder(
    column: $table.purchaseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPurchased => $composableBuilder(
    column: $table.lastPurchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogItemsTable> {
  $$CatalogItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get household =>
      $composableBuilder(column: $table.household, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameNormalized => $composableBuilder(
    column: $table.nameNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<int> get purchaseCount => $composableBuilder(
    column: $table.purchaseCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPurchased => $composableBuilder(
    column: $table.lastPurchased,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);
}

class $$CatalogItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogItemsTable,
          CatalogItem,
          $$CatalogItemsTableFilterComposer,
          $$CatalogItemsTableOrderingComposer,
          $$CatalogItemsTableAnnotationComposer,
          $$CatalogItemsTableCreateCompanionBuilder,
          $$CatalogItemsTableUpdateCompanionBuilder,
          (
            CatalogItem,
            BaseReferences<_$AppDatabase, $CatalogItemsTable, CatalogItem>,
          ),
          CatalogItem,
          PrefetchHooks Function()
        > {
  $$CatalogItemsTableTableManager(_$AppDatabase db, $CatalogItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> household = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameNormalized = const Value.absent(),
                Value<int> purchaseCount = const Value.absent(),
                Value<DateTime?> lastPurchased = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogItemsCompanion(
                id: id,
                household: household,
                name: name,
                nameNormalized: nameNormalized,
                purchaseCount: purchaseCount,
                lastPurchased: lastPurchased,
                deleted: deleted,
                updated: updated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String household,
                required String name,
                required String nameNormalized,
                Value<int> purchaseCount = const Value.absent(),
                Value<DateTime?> lastPurchased = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogItemsCompanion.insert(
                id: id,
                household: household,
                name: name,
                nameNormalized: nameNormalized,
                purchaseCount: purchaseCount,
                lastPurchased: lastPurchased,
                deleted: deleted,
                updated: updated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CatalogItemsTable, CatalogItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CatalogItemsTable,
                    CatalogItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogItemsTable,
      CatalogItem,
      $$CatalogItemsTableFilterComposer,
      $$CatalogItemsTableOrderingComposer,
      $$CatalogItemsTableAnnotationComposer,
      $$CatalogItemsTableCreateCompanionBuilder,
      $$CatalogItemsTableUpdateCompanionBuilder,
      (
        CatalogItem,
        BaseReferences<_$AppDatabase, $CatalogItemsTable, CatalogItem>,
      ),
      CatalogItem,
      PrefetchHooks Function()
    >;
typedef $$ListEntriesTableCreateCompanionBuilder =
    ListEntriesCompanion Function({
      required String id,
      required String household,
      required String catalogItem,
      Value<String> quantity,
      Value<String> addedBy,
      Value<bool> checked,
      Value<DateTime?> checkedAt,
      Value<bool> deleted,
      required DateTime createdAt,
      Value<String> updated,
      Value<int> rowid,
    });
typedef $$ListEntriesTableUpdateCompanionBuilder =
    ListEntriesCompanion Function({
      Value<String> id,
      Value<String> household,
      Value<String> catalogItem,
      Value<String> quantity,
      Value<String> addedBy,
      Value<bool> checked,
      Value<DateTime?> checkedAt,
      Value<bool> deleted,
      Value<DateTime> createdAt,
      Value<String> updated,
      Value<int> rowid,
    });

class $$ListEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ListEntriesTable> {
  $$ListEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get household => $composableBuilder(
    column: $table.household,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogItem => $composableBuilder(
    column: $table.catalogItem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addedBy => $composableBuilder(
    column: $table.addedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ListEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ListEntriesTable> {
  $$ListEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get household => $composableBuilder(
    column: $table.household,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogItem => $composableBuilder(
    column: $table.catalogItem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addedBy => $composableBuilder(
    column: $table.addedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListEntriesTable> {
  $$ListEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get household =>
      $composableBuilder(column: $table.household, builder: (column) => column);

  GeneratedColumn<String> get catalogItem => $composableBuilder(
    column: $table.catalogItem,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get addedBy =>
      $composableBuilder(column: $table.addedBy, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);
}

class $$ListEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListEntriesTable,
          ListEntry,
          $$ListEntriesTableFilterComposer,
          $$ListEntriesTableOrderingComposer,
          $$ListEntriesTableAnnotationComposer,
          $$ListEntriesTableCreateCompanionBuilder,
          $$ListEntriesTableUpdateCompanionBuilder,
          (
            ListEntry,
            BaseReferences<_$AppDatabase, $ListEntriesTable, ListEntry>,
          ),
          ListEntry,
          PrefetchHooks Function()
        > {
  $$ListEntriesTableTableManager(_$AppDatabase db, $ListEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> household = const Value.absent(),
                Value<String> catalogItem = const Value.absent(),
                Value<String> quantity = const Value.absent(),
                Value<String> addedBy = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<DateTime?> checkedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListEntriesCompanion(
                id: id,
                household: household,
                catalogItem: catalogItem,
                quantity: quantity,
                addedBy: addedBy,
                checked: checked,
                checkedAt: checkedAt,
                deleted: deleted,
                createdAt: createdAt,
                updated: updated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String household,
                required String catalogItem,
                Value<String> quantity = const Value.absent(),
                Value<String> addedBy = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<DateTime?> checkedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                required DateTime createdAt,
                Value<String> updated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListEntriesCompanion.insert(
                id: id,
                household: household,
                catalogItem: catalogItem,
                quantity: quantity,
                addedBy: addedBy,
                checked: checked,
                checkedAt: checkedAt,
                deleted: deleted,
                createdAt: createdAt,
                updated: updated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ListEntriesTable, ListEntry>(table),
                  BaseReferences<_$AppDatabase, $ListEntriesTable, ListEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ListEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListEntriesTable,
      ListEntry,
      $$ListEntriesTableFilterComposer,
      $$ListEntriesTableOrderingComposer,
      $$ListEntriesTableAnnotationComposer,
      $$ListEntriesTableCreateCompanionBuilder,
      $$ListEntriesTableUpdateCompanionBuilder,
      (ListEntry, BaseReferences<_$AppDatabase, $ListEntriesTable, ListEntry>),
      ListEntry,
      PrefetchHooks Function()
    >;
typedef $$MembersTableCreateCompanionBuilder = MembersCompanion Function({
  required String id,
  required String name,
  required String household,
  Value<int> rowid,
});
typedef $$MembersTableUpdateCompanionBuilder = MembersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> household,
  Value<int> rowid,
});

class $$MembersTableFilterComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get household => $composableBuilder(
    column: $table.household,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MembersTableOrderingComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get household => $composableBuilder(
    column: $table.household,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get household =>
      $composableBuilder(column: $table.household, builder: (column) => column);
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembersTable,
          Member,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (Member, BaseReferences<_$AppDatabase, $MembersTable, Member>),
          Member,
          PrefetchHooks Function()
        > {
  $$MembersTableTableManager(_$AppDatabase db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> household = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                name: name,
                household: household,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String household,
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                name: name,
                household: household,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MembersTable, Member>(table),
                  BaseReferences<_$AppDatabase, $MembersTable, Member>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembersTable,
      Member,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (Member, BaseReferences<_$AppDatabase, $MembersTable, Member>),
      Member,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder = OutboxCompanion Function({
  Value<int> seq,
  required String collection,
  required String recordId,
  required String op,
  required String payload,
  Value<int> attempts,
  Value<DateTime?> notBefore,
});
typedef $$OutboxTableUpdateCompanionBuilder = OutboxCompanion Function({
  Value<int> seq,
  Value<String> collection,
  Value<String> recordId,
  Value<String> op,
  Value<String> payload,
  Value<int> attempts,
  Value<DateTime?> notBefore,
});

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get notBefore => $composableBuilder(
    column: $table.notBefore,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get notBefore => $composableBuilder(
    column: $table.notBefore,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get notBefore =>
      $composableBuilder(column: $table.notBefore, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxData,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
          OutboxData,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> collection = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> notBefore = const Value.absent(),
              }) => OutboxCompanion(
                seq: seq,
                collection: collection,
                recordId: recordId,
                op: op,
                payload: payload,
                attempts: attempts,
                notBefore: notBefore,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String collection,
                required String recordId,
                required String op,
                required String payload,
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> notBefore = const Value.absent(),
              }) => OutboxCompanion.insert(
                seq: seq,
                collection: collection,
                recordId: recordId,
                op: op,
                payload: payload,
                attempts: attempts,
                notBefore: notBefore,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxData>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxData,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
      OutboxData,
      PrefetchHooks Function()
    >;
typedef $$MetaTableCreateCompanionBuilder = MetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$MetaTableUpdateCompanionBuilder = MetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$MetaTableFilterComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetaTableOrderingComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetaTable,
          MetaData,
          $$MetaTableFilterComposer,
          $$MetaTableOrderingComposer,
          $$MetaTableAnnotationComposer,
          $$MetaTableCreateCompanionBuilder,
          $$MetaTableUpdateCompanionBuilder,
          (MetaData, BaseReferences<_$AppDatabase, $MetaTable, MetaData>),
          MetaData,
          PrefetchHooks Function()
        > {
  $$MetaTableTableManager(_$AppDatabase db, $MetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MetaTable, MetaData>(table),
                  BaseReferences<_$AppDatabase, $MetaTable, MetaData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetaTable,
      MetaData,
      $$MetaTableFilterComposer,
      $$MetaTableOrderingComposer,
      $$MetaTableAnnotationComposer,
      $$MetaTableCreateCompanionBuilder,
      $$MetaTableUpdateCompanionBuilder,
      (MetaData, BaseReferences<_$AppDatabase, $MetaTable, MetaData>),
      MetaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatalogItemsTableTableManager get catalogItems =>
      $$CatalogItemsTableTableManager(_db, _db.catalogItems);
  $$ListEntriesTableTableManager get listEntries =>
      $$ListEntriesTableTableManager(_db, _db.listEntries);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$MetaTableTableManager get meta => $$MetaTableTableManager(_db, _db.meta);
}
