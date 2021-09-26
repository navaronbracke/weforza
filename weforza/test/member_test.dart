
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/model/member.dart';

import 'test_cipher.dart';

void main(){
  group("Member encryption tests", (){
    final cipher = TestCipher();

    test("Member encrypt test", (){
      final lastUpdated = DateTime.now();
      final uuid = "1";
      final firstName = "John";
      final lastName = "Doe";
      final alias = "JohnDoeAlias";

      final Member memberToEncrypt = Member(
        uuid: uuid,
        firstname: firstName,
        lastname: lastName,
        alias: alias,
        lastUpdated: lastUpdated,
        isActiveMember: true,
        profileImageFilePath: null,
      );

      final Member encryptedMember = memberToEncrypt.encrypt(cipher);

      expect(encryptedMember.firstname, cipher.encrypt(firstName));
      expect(encryptedMember.lastname, cipher.encrypt(lastName));
      expect(encryptedMember.alias, cipher.encrypt(alias));
      expect(encryptedMember.profileImageFilePath, null);
      expect(encryptedMember.isActiveMember, true);
      expect(encryptedMember.lastUpdated, lastUpdated);
      expect(encryptedMember.uuid, uuid);
    });

    test("Member decrypt test", (){
      final lastUpdated = DateTime.now();
      final uuid = "1";
      final firstName = "John";
      final lastName = "Doe";
      final alias = "JohnDoeAlias";

      final encryptedMember = Member(
        uuid: uuid,
        firstname: cipher.encrypt(firstName),
        lastname: cipher.encrypt(lastName),
        alias: cipher.encrypt(alias),
        profileImageFilePath: null,
        isActiveMember: true,
        lastUpdated: lastUpdated
      );

      final decryptedMember = encryptedMember.decrypt(cipher);

      expect(decryptedMember.firstname, firstName);
      expect(decryptedMember.lastname, lastName);
      expect(decryptedMember.alias, alias);
      expect(decryptedMember.profileImageFilePath, null);
      expect(decryptedMember.isActiveMember, true);
      expect(decryptedMember.lastUpdated, lastUpdated);
      expect(decryptedMember.uuid, uuid);
    });

    test("Member without alias encrypt test", (){
      final lastUpdated = DateTime.now();
      final uuid = "1";
      final firstName = "John";
      final lastName = "Doe";

      final Member memberToEncrypt = Member(
        uuid: uuid,
        firstname: firstName,
        lastname: lastName,
        alias: "",
        lastUpdated: lastUpdated,
        isActiveMember: true,
        profileImageFilePath: null,
      );

      final Member encryptedMember = memberToEncrypt.encrypt(cipher);

      expect(encryptedMember.firstname, cipher.encrypt(firstName));
      expect(encryptedMember.lastname, cipher.encrypt(lastName));
      expect(encryptedMember.alias, "");
      expect(encryptedMember.profileImageFilePath, null);
      expect(encryptedMember.isActiveMember, true);
      expect(encryptedMember.lastUpdated, lastUpdated);
      expect(encryptedMember.uuid, uuid);
    });

    test("Member without alias decrypt test", (){
      final lastUpdated = DateTime.now();
      final uuid = "1";
      final firstName = "John";
      final lastName = "Doe";

      final encryptedMember = Member(
          uuid: uuid,
          firstname: cipher.encrypt(firstName),
          lastname: cipher.encrypt(lastName),
          alias: cipher.encrypt(""),
          profileImageFilePath: null,
          isActiveMember: true,
          lastUpdated: lastUpdated
      );

      final decryptedMember = encryptedMember.decrypt(cipher);

      expect(decryptedMember.firstname, firstName);
      expect(decryptedMember.lastname, lastName);
      expect(decryptedMember.alias, "");
      expect(decryptedMember.profileImageFilePath, null);
      expect(decryptedMember.isActiveMember, true);
      expect(decryptedMember.lastUpdated, lastUpdated);
      expect(decryptedMember.uuid, uuid);
    });
  });
}