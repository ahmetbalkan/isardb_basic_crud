import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isarproject/models/user.dart';

class IsarService {
  late Future<Isar> db;
  //işlem yapacağımız db classımızı late olarak tanımlıyoruz.
  IsarService() {
    db = openDB();
    //contractor içinde örnekleyerek kullanıma açıyoruz.
  }

  Future<void> saveUser(User newUser) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.users.putSync(newUser));
  }

  Stream<List<User>> listenUser() async* {
    final isar = await db;
    yield* isar.users.where().watch(fireImmediately: true);
  }

  Future<List<User>> getAllUser() async {
    final isar = await db;
    return await isar.users.where().findAll();
  }

  Future<void> UpdateUser(User user) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
  }

  Future<void> deleteUser(int userid) async {
    final isar = await db;
    isar.writeTxn(() => isar.users.delete(userid));
  }

  Future<User?> filterName() async {
    final isar = await db;
    final favouires = await isar.users
        .filter()
        .nameContains("hatice")
        .ageEqualTo(45)
        .findFirst();
    return favouires;
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        //ısarın açılmasını sağlıyoruz.
        [UserSchema],
        //bu bölüm size belirttiğim kodu yazdıktan sonra dosya içerisinde oluşmaktadır.
        // user.g.dart içinden ne olduğuna bakıp buraya yazmanız gerekir.
        //Eğer birden fazla isar local db kullanıyorsanız bütün şemaları buraya tanımlamalısınız.
      );
    }
    return Future.value(Isar.getInstance());
    // geriye Isar Instance donduruyoruz ki ekleme cıkarma işlemlerinde kullanılabilir hale gelsin.
  }
}
