// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ShopBandit';

  @override
  String get about => 'About';

  @override
  String get account => 'Account';

  @override
  String get add => 'Add';

  @override
  String get addItemHint => 'What do you need?';

  @override
  String addNamed(String name) {
    return 'Add $name';
  }

  @override
  String addedBy(String name) {
    return 'by $name';
  }

  @override
  String get admin => 'Admin';

  @override
  String get backToLogin => 'Back to login';

  @override
  String boughtTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bought $count times',
      one: 'bought once',
      zero: 'never bought',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get catalogEmptyTitle => 'No items yet';

  @override
  String get catalogEmptyMessage =>
      'Everything you ever put on the list shows up here.';

  @override
  String get changeServer => 'Change server';

  @override
  String get changeServerHint => 'Tap to change (logs you out)';

  @override
  String get changeServerMessage =>
      'You will be logged out. Changes not yet uploaded will be lost.';

  @override
  String checkedOff(String name) {
    return '$name bought';
  }

  @override
  String get chooseDistributor => 'Choose push distributor';

  @override
  String get createAccount => 'Create account';

  @override
  String get delete => 'Delete';

  @override
  String deleteNamed(String name) {
    return 'Delete $name';
  }

  @override
  String get deleteCatalogMessage =>
      'The item disappears from suggestions and “Frequently bought”. If it is on the list, it is removed there too.';

  @override
  String deleted(String name) {
    return '$name deleted';
  }

  @override
  String get displayName => 'Display name';

  @override
  String get displayNameHelp => 'Visible to the others in your household';

  @override
  String get email => 'Email';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get emailNotVerified => 'Email not verified yet';

  @override
  String get emptyListTitle => 'All done!';

  @override
  String get emptyListMessage =>
      'The list is empty. Type what you need above – or pick from “Frequently bought”.';

  @override
  String get enterCode => 'Enter invite code';

  @override
  String get errorAlreadyMember => 'You are already in this household.';

  @override
  String get errorEmailTaken => 'This email address cannot be used.';

  @override
  String get errorForbidden => 'You are not allowed to do that.';

  @override
  String get errorGeneric => 'That did not work. Please try again later.';

  @override
  String get errorInviteExpired => 'This invite has expired.';

  @override
  String get errorInviteInvalid => 'Invalid or already used invite.';

  @override
  String get errorLoginFailed => 'Wrong email or password.';

  @override
  String get errorOffline => 'No connection to the server.';

  @override
  String get errorOnlyMember => 'You are the only member.';

  @override
  String get errorPasswordRules => 'The password does not meet the rules.';

  @override
  String get errorTooManyRequests => 'Too many attempts. Please wait a moment.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get frequentlyBought => 'Frequently bought';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get showPassword => 'Show password';

  @override
  String get household => 'Household';

  @override
  String get inviteCodeHint => 'e.g. ABCD-EFGH-…';

  @override
  String get inviteExplain =>
      'Let the QR code be scanned in the ShopBandit app or share the code. Valid for 24 hours, single use.';

  @override
  String get inviteMember => 'Invite member';

  @override
  String inviteOtherServer(String server) {
    return 'The invite belongs to another server ($server).';
  }

  @override
  String get inviteQrLabel => 'Invite QR code';

  @override
  String get inviteRevoked => 'Invite revoked.';

  @override
  String inviteValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get join => 'Join';

  @override
  String get joinDiscardsOwn =>
      'Your current list and item catalog will be deleted.';

  @override
  String get joinHousehold => 'Join household';

  @override
  String joinMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return 'Join household “$name” with $_temp0?';
  }

  @override
  String joined(String name) {
    return 'Welcome to “$name”!';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System language';

  @override
  String get leave => 'Leave';

  @override
  String get leaveHousehold => 'Leave household';

  @override
  String get leaveHouseholdMessage => 'You will get your own empty list again.';

  @override
  String get list => 'List';

  @override
  String listCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get login => 'Log in';

  @override
  String get loginSubtitle => 'Your shopping list – shared and offline.';

  @override
  String get logout => 'Log out';

  @override
  String get logoutMessage => 'Local data will be removed from this device.';

  @override
  String get manageCatalog => 'Item catalog';

  @override
  String get manageCatalogHint => 'View and delete saved items';

  @override
  String markBought(String name) {
    return 'Mark $name as bought';
  }

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get nameRequired => 'Please enter a name';

  @override
  String get next => 'Next';

  @override
  String get notifications => 'Notifications';

  @override
  String get notifyChannelName => 'List changes';

  @override
  String get notifyChannelDescription => 'When other members add items';

  @override
  String notifyItemsAdded(String who, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'added $count items',
      one: 'added 1 item',
    );
    return '$who $_temp0';
  }

  @override
  String get notifyOnAdd => 'Notify about new items';

  @override
  String get password => 'Password';

  @override
  String get passwordConfirm => 'Repeat password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get pushModeOff => 'Off';

  @override
  String get pushModePolling =>
      'Without push app: checks about every 15 minutes';

  @override
  String get pushModeUnifiedPush => 'Instant via UnifiedPush';

  @override
  String get pushPollingHint =>
      'For instant notifications install the “ntfy” app (F-Droid) and switch this on again.';

  @override
  String pwRuleLength(int count) {
    return 'At least $count characters';
  }

  @override
  String get pwRuleUpper => 'One uppercase letter';

  @override
  String get pwRuleLower => 'One lowercase letter';

  @override
  String get pwRuleDigit => 'One digit';

  @override
  String get pwRuleSpecial => 'One special character';

  @override
  String get pwRuleOk => 'met';

  @override
  String get pwRuleMissing => 'missing';

  @override
  String get quantity => 'Quantity';

  @override
  String get quantityExample => 'e.g. 2 or 500 g';

  @override
  String get quantityHint => 'Qty';

  @override
  String get remove => 'Remove';

  @override
  String removeMember(String name) {
    return 'Remove $name';
  }

  @override
  String removeMemberMessage(String name) {
    return '$name loses access to the list and gets an own household.';
  }

  @override
  String get renameHousehold => 'Rename household';

  @override
  String get resendVerification => 'Resend verification email';

  @override
  String get resetExplain =>
      'Enter your email address. You will receive a link to reset your password.';

  @override
  String get resetSent =>
      'If an account exists, the email is on its way. Please check your spam folder too.';

  @override
  String get revokeInvite => 'Revoke invite';

  @override
  String get save => 'Save';

  @override
  String get scanInvite => 'Scan invite';

  @override
  String get sendResetLink => 'Send link';

  @override
  String get server => 'Server';

  @override
  String get serverExplain =>
      'ShopBandit stores your list on a self-hosted server. Use the preset one or enter your own.';

  @override
  String serverLabel(String host) {
    return 'Server: $host';
  }

  @override
  String get serverSubtitle => 'Which server do you want to use?';

  @override
  String get serverUnreachable =>
      'Server unreachable or not a ShopBandit server.';

  @override
  String get serverUrl => 'Server address';

  @override
  String get settings => 'Settings';

  @override
  String get someone => 'Someone';

  @override
  String get syncDone => 'Synchronized';

  @override
  String get syncError => 'Sync failed';

  @override
  String syncOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Offline – $count changes pending',
      one: 'Offline – 1 change pending',
      zero: 'Offline',
    );
    return '$_temp0';
  }

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes pending',
      one: '1 change pending',
    );
    return '$_temp0';
  }

  @override
  String get syncRunning => 'Syncing …';

  @override
  String get undo => 'Undo';

  @override
  String get verificationSent => 'Verification email sent.';

  @override
  String youSuffix(String name) {
    return '$name (you)';
  }
}
