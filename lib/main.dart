// Flutter imports:
import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';

// Project imports:
import '';
import 'objectbox.g.dart';
import 'src/app.dart';
import 'src/features/account/data/account_repository.dart';
import 'src/features/account/domain/account.dart';
import 'src/features/budget/domain/budget.dart';
import 'src/features/category/domain/category.dart';
import 'src/features/goal/domain/goal.dart';
import 'src/features/payment/domain/payment.dart';
import 'src/features/record/domain/record.dart';
import 'src/utils/object_box.dart';

// late ObjectBox objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DartPluginRegistrant.ensureInitialized();
  final objectBox = await ObjectBox.create();
//   if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
// if (Platform.isIOS) SharedPreferencesIOS.registerWith();
  final sharedPreferences = await SharedPreferences.getInstance();

  final accountRepo = LocalAccountRepository(store: objectBox.store);
  //final accountBloc = AccountBloc(accountRepository: accountRepo);
  runApp(MyApp(objectBox: objectBox, sharedPreferences: sharedPreferences));

  final accountBox = objectBox.store.box<Account>();
  try {
    accountBox.put(Account(name: 'test', balance: '90.99'));
    accountBox.put(Account(name: 'test', balance: '90.99'));
  } on UniqueViolationException catch (e) {
    print(e.message);
  }
  final test = accountBox.getAll();
  // for (var element in test) {
  //   await Future.delayed(
  //       const Duration(seconds: 3), () => accountBox.remove(element.id));
  // }
  cleanMockupDatbase(objectBox.store);
  createMockupDatabase(objectBox.store);
  for (var i = 0; i < 10; i++) {
    // await Future.delayed(
    //     const Duration(seconds: 1),
    //     () => accountBox
    //         .put(Account(name: Faker().person.name(), balance: '90.99')));
    //accountBox.put(Account(name: Faker().person.name(), balance: '90.99'));
  }
}

void createMockupDatabase(Store store) {
  final accountBox = store.box<Account>();
  final recordBox = store.box<Record>();
  final budgetBox = store.box<Budget>();
  final goalBox = store.box<Goal>();
  final paymentBox = store.box<Payment>();
  final categoryBox = store.box<Category>();

  final categories = [
    Category(name: 'Food & Drinks', nature: 'Need'),
    Category(name: 'Shopping', nature: 'Want'),
    Category(name: 'Housing', nature: 'Must'),
    Category(name: 'Transportation', nature: 'Need'),
    Category(name: 'Vehicle', nature: 'Need'),
    Category(name: 'Life & Entertainment', nature: 'Want'),
    Category(name: 'Communication, PC', nature: 'Need'),
    Category(name: 'Financial', nature: 'Must'),
    Category(name: 'Investments', nature: 'Want'),
    Category(name: 'Income', nature: 'Want'),
    Category(name: 'Other', nature: 'Want'),
  ];
  categoryBox.putMany(categories);

  final accounts = [
    Account(name: 'Account 1', balance: '1.11'),
    Account(name: 'Account 2', balance: '2.22'),
    Account(name: 'Account 3', balance: '3.33'),
  ];
  accountBox.putMany(accounts);

  final records = [
    Record(
        type: 'Expense',
        amount: '45',
        note: 'for test 1',
        date: DateTime(2022, 12, 11))
      ..account.target = accounts[0]
      ..category.target = categories[0],
    Record(
        type: 'Income',
        amount: '9000',
        note: 'for test 2',
        date: DateTime(2022, 11, 26))
      ..account.target = accounts[1]
      ..category.target = categories[2],
    Record(
        type: 'Expense',
        amount: '65',
        note: 'for test 3',
        date: DateTime(2022, 12, 11))
      ..account.target = accounts[0]
      ..category.target = categories[1],
    // Record(type: 'Income', amount: '0.4', date: DateTime.now()),
    // Record(type: 'Expense', amount: '0.5', date: DateTime.now()),
  ];
  recordBox.putMany(records);

  final goals = [
    Goal(
      name: 'Test Goal 1',
      targetAmount: '111',
      currentAmount: '11',
      endDate: DateTime(2022, 12, 15),
    ),
    Goal(
      name: 'Test Goal 2',
      targetAmount: '222',
      currentAmount: '22',
      endDate: DateTime.now(),
    ),
    Goal(
      name: 'Test Goal 3',
      targetAmount: '333',
      currentAmount: '33',
      endDate: DateTime.now(),
    ),
  ];
  goalBox.putMany(goals);

  // accountBox.get(1)!.records.forEach((element) {
  //   print(
  //       'Record: amount-${element.amount} category-${element.category.target?.name}');
  // });
}

void cleanMockupDatbase(Store store) async {
  await Directory(store.directoryPath).delete(recursive: true);
}
