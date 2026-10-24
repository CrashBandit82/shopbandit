import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'ShopBandit'**
  String get appTitle;

  /// No description provided for @about.
  ///
  /// In de, this message translates to:
  /// **'Über'**
  String get about;

  /// No description provided for @account.
  ///
  /// In de, this message translates to:
  /// **'Konto'**
  String get account;

  /// No description provided for @add.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get add;

  /// No description provided for @addItemHint.
  ///
  /// In de, this message translates to:
  /// **'Was fehlt?'**
  String get addItemHint;

  /// No description provided for @addNamed.
  ///
  /// In de, this message translates to:
  /// **'{name} hinzufügen'**
  String addNamed(String name);

  /// No description provided for @addedBy.
  ///
  /// In de, this message translates to:
  /// **'von {name}'**
  String addedBy(String name);

  /// No description provided for @admin.
  ///
  /// In de, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @backToLogin.
  ///
  /// In de, this message translates to:
  /// **'Zurück zur Anmeldung'**
  String get backToLogin;

  /// No description provided for @boughtTimes.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =0{noch nie gekauft} =1{1× gekauft} other{{count}× gekauft}}'**
  String boughtTimes(int count);

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @catalogEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Artikel'**
  String get catalogEmptyTitle;

  /// No description provided for @catalogEmptyMessage.
  ///
  /// In de, this message translates to:
  /// **'Alles, was du einmal auf die Liste setzt, landet hier.'**
  String get catalogEmptyMessage;

  /// No description provided for @changeServer.
  ///
  /// In de, this message translates to:
  /// **'Server wechseln'**
  String get changeServer;

  /// No description provided for @changeServerHint.
  ///
  /// In de, this message translates to:
  /// **'Tippen zum Wechseln (meldet dich ab)'**
  String get changeServerHint;

  /// No description provided for @changeServerMessage.
  ///
  /// In de, this message translates to:
  /// **'Du wirst abgemeldet. Noch nicht übertragene Änderungen gehen verloren.'**
  String get changeServerMessage;

  /// No description provided for @checkedOff.
  ///
  /// In de, this message translates to:
  /// **'{name} gekauft'**
  String checkedOff(String name);

  /// No description provided for @chooseDistributor.
  ///
  /// In de, this message translates to:
  /// **'Push-Dienst wählen'**
  String get chooseDistributor;

  /// No description provided for @createAccount.
  ///
  /// In de, this message translates to:
  /// **'Konto erstellen'**
  String get createAccount;

  /// No description provided for @delete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get delete;

  /// No description provided for @deleteNamed.
  ///
  /// In de, this message translates to:
  /// **'{name} löschen'**
  String deleteNamed(String name);

  /// No description provided for @deleteCatalogMessage.
  ///
  /// In de, this message translates to:
  /// **'Der Artikel verschwindet aus Vorschlägen und „Häufig gekauft“. Steht er auf der Liste, wird er dort auch entfernt.'**
  String get deleteCatalogMessage;

  /// No description provided for @deleted.
  ///
  /// In de, this message translates to:
  /// **'{name} gelöscht'**
  String deleted(String name);

  /// No description provided for @displayName.
  ///
  /// In de, this message translates to:
  /// **'Anzeigename'**
  String get displayName;

  /// No description provided for @displayNameHelp.
  ///
  /// In de, this message translates to:
  /// **'Sehen die anderen in deinem Haushalt'**
  String get displayNameHelp;

  /// No description provided for @email.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get email;

  /// No description provided for @emailInvalid.
  ///
  /// In de, this message translates to:
  /// **'Bitte eine gültige E-Mail-Adresse eingeben'**
  String get emailInvalid;

  /// No description provided for @emailNotVerified.
  ///
  /// In de, this message translates to:
  /// **'E-Mail noch nicht bestätigt'**
  String get emailNotVerified;

  /// No description provided for @emptyListTitle.
  ///
  /// In de, this message translates to:
  /// **'Alles erledigt!'**
  String get emptyListTitle;

  /// No description provided for @emptyListMessage.
  ///
  /// In de, this message translates to:
  /// **'Die Liste ist leer. Tipp oben ein, was fehlt – oder wähle aus „Häufig gekauft“.'**
  String get emptyListMessage;

  /// No description provided for @enterCode.
  ///
  /// In de, this message translates to:
  /// **'Einladungscode eingeben'**
  String get enterCode;

  /// No description provided for @errorAlreadyMember.
  ///
  /// In de, this message translates to:
  /// **'Du bist bereits in diesem Haushalt.'**
  String get errorAlreadyMember;

  /// No description provided for @errorEmailTaken.
  ///
  /// In de, this message translates to:
  /// **'Diese E-Mail-Adresse kann nicht verwendet werden.'**
  String get errorEmailTaken;

  /// No description provided for @errorForbidden.
  ///
  /// In de, this message translates to:
  /// **'Dafür fehlt dir die Berechtigung.'**
  String get errorForbidden;

  /// No description provided for @errorGeneric.
  ///
  /// In de, this message translates to:
  /// **'Das hat nicht geklappt. Bitte später erneut versuchen.'**
  String get errorGeneric;

  /// No description provided for @errorInviteExpired.
  ///
  /// In de, this message translates to:
  /// **'Diese Einladung ist abgelaufen.'**
  String get errorInviteExpired;

  /// No description provided for @errorInviteInvalid.
  ///
  /// In de, this message translates to:
  /// **'Ungültige oder bereits verwendete Einladung.'**
  String get errorInviteInvalid;

  /// No description provided for @errorLoginFailed.
  ///
  /// In de, this message translates to:
  /// **'E-Mail oder Passwort falsch.'**
  String get errorLoginFailed;

  /// No description provided for @errorOffline.
  ///
  /// In de, this message translates to:
  /// **'Keine Verbindung zum Server.'**
  String get errorOffline;

  /// No description provided for @errorOnlyMember.
  ///
  /// In de, this message translates to:
  /// **'Du bist das einzige Mitglied.'**
  String get errorOnlyMember;

  /// No description provided for @errorPasswordRules.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort erfüllt die Regeln nicht.'**
  String get errorPasswordRules;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In de, this message translates to:
  /// **'Zu viele Versuche. Bitte kurz warten.'**
  String get errorTooManyRequests;

  /// No description provided for @forgotPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort vergessen?'**
  String get forgotPassword;

  /// No description provided for @frequentlyBought.
  ///
  /// In de, this message translates to:
  /// **'Häufig gekauft'**
  String get frequentlyBought;

  /// No description provided for @hidePassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort verbergen'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort anzeigen'**
  String get showPassword;

  /// No description provided for @household.
  ///
  /// In de, this message translates to:
  /// **'Haushalt'**
  String get household;

  /// No description provided for @inviteCodeHint.
  ///
  /// In de, this message translates to:
  /// **'z. B. ABCD-EFGH-…'**
  String get inviteCodeHint;

  /// No description provided for @inviteExplain.
  ///
  /// In de, this message translates to:
  /// **'Lass den QR-Code in der ShopBandit-App scannen oder gib den Code weiter. Gültig 24 Stunden, nur einmal verwendbar.'**
  String get inviteExplain;

  /// No description provided for @inviteMember.
  ///
  /// In de, this message translates to:
  /// **'Mitglied einladen'**
  String get inviteMember;

  /// No description provided for @inviteOtherServer.
  ///
  /// In de, this message translates to:
  /// **'Die Einladung gehört zu einem anderen Server ({server}).'**
  String inviteOtherServer(String server);

  /// No description provided for @inviteQrLabel.
  ///
  /// In de, this message translates to:
  /// **'QR-Code der Einladung'**
  String get inviteQrLabel;

  /// No description provided for @inviteRevoked.
  ///
  /// In de, this message translates to:
  /// **'Einladung widerrufen.'**
  String get inviteRevoked;

  /// No description provided for @inviteValidUntil.
  ///
  /// In de, this message translates to:
  /// **'Gültig bis {date}'**
  String inviteValidUntil(String date);

  /// No description provided for @join.
  ///
  /// In de, this message translates to:
  /// **'Beitreten'**
  String get join;

  /// No description provided for @joinDiscardsOwn.
  ///
  /// In de, this message translates to:
  /// **'Deine bisherige Liste und dein Artikelkatalog werden dabei gelöscht.'**
  String get joinDiscardsOwn;

  /// No description provided for @joinHousehold.
  ///
  /// In de, this message translates to:
  /// **'Haushalt beitreten'**
  String get joinHousehold;

  /// No description provided for @joinMessage.
  ///
  /// In de, this message translates to:
  /// **'Haushalt „{name}“ mit {count, plural, =1{1 Mitglied} other{{count} Mitgliedern}} beitreten?'**
  String joinMessage(String name, int count);

  /// No description provided for @joined.
  ///
  /// In de, this message translates to:
  /// **'Willkommen in „{name}“!'**
  String joined(String name);

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In de, this message translates to:
  /// **'Systemsprache'**
  String get languageSystem;

  /// No description provided for @leave.
  ///
  /// In de, this message translates to:
  /// **'Verlassen'**
  String get leave;

  /// No description provided for @leaveHousehold.
  ///
  /// In de, this message translates to:
  /// **'Haushalt verlassen'**
  String get leaveHousehold;

  /// No description provided for @leaveHouseholdMessage.
  ///
  /// In de, this message translates to:
  /// **'Du bekommst wieder eine eigene, leere Liste.'**
  String get leaveHouseholdMessage;

  /// No description provided for @list.
  ///
  /// In de, this message translates to:
  /// **'Liste'**
  String get list;

  /// No description provided for @listCount.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Artikel} other{{count} Artikel}}'**
  String listCount(int count);

  /// No description provided for @login.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Eure Einkaufsliste – gemeinsam und offline.'**
  String get loginSubtitle;

  /// No description provided for @logout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get logout;

  /// No description provided for @logoutMessage.
  ///
  /// In de, this message translates to:
  /// **'Lokale Daten werden von diesem Gerät entfernt.'**
  String get logoutMessage;

  /// No description provided for @manageCatalog.
  ///
  /// In de, this message translates to:
  /// **'Artikelkatalog'**
  String get manageCatalog;

  /// No description provided for @manageCatalogHint.
  ///
  /// In de, this message translates to:
  /// **'Gespeicherte Artikel ansehen und löschen'**
  String get manageCatalogHint;

  /// No description provided for @markBought.
  ///
  /// In de, this message translates to:
  /// **'{name} als gekauft markieren'**
  String markBought(String name);

  /// No description provided for @memberCount.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Mitglied} other{{count} Mitglieder}}'**
  String memberCount(int count);

  /// No description provided for @nameRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte einen Namen eingeben'**
  String get nameRequired;

  /// No description provided for @next.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get next;

  /// No description provided for @notifications.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen'**
  String get notifications;

  /// No description provided for @notifyChannelName.
  ///
  /// In de, this message translates to:
  /// **'Änderungen an der Liste'**
  String get notifyChannelName;

  /// No description provided for @notifyChannelDescription.
  ///
  /// In de, this message translates to:
  /// **'Wenn andere Mitglieder Artikel hinzufügen'**
  String get notifyChannelDescription;

  /// No description provided for @notifyItemsAdded.
  ///
  /// In de, this message translates to:
  /// **'{who} {count, plural, =1{hat 1 Artikel hinzugefügt} other{hat {count} Artikel hinzugefügt}}'**
  String notifyItemsAdded(String who, int count);

  /// No description provided for @notifyOnAdd.
  ///
  /// In de, this message translates to:
  /// **'Bei neuen Artikeln benachrichtigen'**
  String get notifyOnAdd;

  /// No description provided for @password.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get password;

  /// No description provided for @passwordConfirm.
  ///
  /// In de, this message translates to:
  /// **'Passwort wiederholen'**
  String get passwordConfirm;

  /// No description provided for @passwordMismatch.
  ///
  /// In de, this message translates to:
  /// **'Passwörter stimmen nicht überein'**
  String get passwordMismatch;

  /// No description provided for @passwordRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte Passwort eingeben'**
  String get passwordRequired;

  /// No description provided for @pushModeOff.
  ///
  /// In de, this message translates to:
  /// **'Aus'**
  String get pushModeOff;

  /// No description provided for @pushModePolling.
  ///
  /// In de, this message translates to:
  /// **'Ohne Push-App: Abfrage etwa alle 15 Minuten'**
  String get pushModePolling;

  /// No description provided for @pushModeUnifiedPush.
  ///
  /// In de, this message translates to:
  /// **'Sofort über UnifiedPush'**
  String get pushModeUnifiedPush;

  /// No description provided for @pushPollingHint.
  ///
  /// In de, this message translates to:
  /// **'Für sofortige Benachrichtigungen die App „ntfy“ (F-Droid) installieren und hier erneut einschalten.'**
  String get pushPollingHint;

  /// No description provided for @pwRuleLength.
  ///
  /// In de, this message translates to:
  /// **'Mindestens {count} Zeichen'**
  String pwRuleLength(int count);

  /// No description provided for @pwRuleUpper.
  ///
  /// In de, this message translates to:
  /// **'Ein Großbuchstabe'**
  String get pwRuleUpper;

  /// No description provided for @pwRuleLower.
  ///
  /// In de, this message translates to:
  /// **'Ein Kleinbuchstabe'**
  String get pwRuleLower;

  /// No description provided for @pwRuleDigit.
  ///
  /// In de, this message translates to:
  /// **'Eine Ziffer'**
  String get pwRuleDigit;

  /// No description provided for @pwRuleSpecial.
  ///
  /// In de, this message translates to:
  /// **'Ein Sonderzeichen'**
  String get pwRuleSpecial;

  /// No description provided for @pwRuleOk.
  ///
  /// In de, this message translates to:
  /// **'erfüllt'**
  String get pwRuleOk;

  /// No description provided for @pwRuleMissing.
  ///
  /// In de, this message translates to:
  /// **'fehlt'**
  String get pwRuleMissing;

  /// No description provided for @quantity.
  ///
  /// In de, this message translates to:
  /// **'Menge'**
  String get quantity;

  /// No description provided for @quantityExample.
  ///
  /// In de, this message translates to:
  /// **'z. B. 2 oder 500 g'**
  String get quantityExample;

  /// No description provided for @quantityHint.
  ///
  /// In de, this message translates to:
  /// **'Menge'**
  String get quantityHint;

  /// No description provided for @remove.
  ///
  /// In de, this message translates to:
  /// **'Entfernen'**
  String get remove;

  /// No description provided for @removeMember.
  ///
  /// In de, this message translates to:
  /// **'{name} entfernen'**
  String removeMember(String name);

  /// No description provided for @removeMemberMessage.
  ///
  /// In de, this message translates to:
  /// **'{name} verliert den Zugriff auf die Liste und bekommt einen eigenen Haushalt.'**
  String removeMemberMessage(String name);

  /// No description provided for @renameHousehold.
  ///
  /// In de, this message translates to:
  /// **'Haushalt umbenennen'**
  String get renameHousehold;

  /// No description provided for @resendVerification.
  ///
  /// In de, this message translates to:
  /// **'Bestätigungs-Mail erneut senden'**
  String get resendVerification;

  /// No description provided for @resetExplain.
  ///
  /// In de, this message translates to:
  /// **'Gib deine E-Mail-Adresse ein. Du bekommst einen Link zum Zurücksetzen des Passworts.'**
  String get resetExplain;

  /// No description provided for @resetSent.
  ///
  /// In de, this message translates to:
  /// **'Falls ein Konto existiert, ist die E-Mail unterwegs. Bitte auch den Spam-Ordner prüfen.'**
  String get resetSent;

  /// No description provided for @revokeInvite.
  ///
  /// In de, this message translates to:
  /// **'Einladung widerrufen'**
  String get revokeInvite;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get save;

  /// No description provided for @scanInvite.
  ///
  /// In de, this message translates to:
  /// **'Einladung scannen'**
  String get scanInvite;

  /// No description provided for @sendResetLink.
  ///
  /// In de, this message translates to:
  /// **'Link senden'**
  String get sendResetLink;

  /// No description provided for @server.
  ///
  /// In de, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @serverExplain.
  ///
  /// In de, this message translates to:
  /// **'ShopBandit speichert eure Liste auf einem eigenen Server. Nutze den voreingestellten oder trage deinen ein.'**
  String get serverExplain;

  /// No description provided for @serverLabel.
  ///
  /// In de, this message translates to:
  /// **'Server: {host}'**
  String serverLabel(String host);

  /// No description provided for @serverSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Mit welchem Server verbinden?'**
  String get serverSubtitle;

  /// No description provided for @serverUnreachable.
  ///
  /// In de, this message translates to:
  /// **'Server nicht erreichbar oder kein ShopBandit-Server.'**
  String get serverUnreachable;

  /// No description provided for @serverUrl.
  ///
  /// In de, this message translates to:
  /// **'Server-Adresse'**
  String get serverUrl;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @someone.
  ///
  /// In de, this message translates to:
  /// **'Jemand'**
  String get someone;

  /// No description provided for @syncDone.
  ///
  /// In de, this message translates to:
  /// **'Synchronisiert'**
  String get syncDone;

  /// No description provided for @syncError.
  ///
  /// In de, this message translates to:
  /// **'Synchronisierung fehlgeschlagen'**
  String get syncError;

  /// No description provided for @syncOffline.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =0{Offline} =1{Offline – 1 Änderung ausstehend} other{Offline – {count} Änderungen ausstehend}}'**
  String syncOffline(int count);

  /// No description provided for @syncPending.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Änderung ausstehend} other{{count} Änderungen ausstehend}}'**
  String syncPending(int count);

  /// No description provided for @syncRunning.
  ///
  /// In de, this message translates to:
  /// **'Synchronisiere …'**
  String get syncRunning;

  /// No description provided for @undo.
  ///
  /// In de, this message translates to:
  /// **'Rückgängig'**
  String get undo;

  /// No description provided for @verificationSent.
  ///
  /// In de, this message translates to:
  /// **'Bestätigungs-Mail wurde gesendet.'**
  String get verificationSent;

  /// No description provided for @youSuffix.
  ///
  /// In de, this message translates to:
  /// **'{name} (du)'**
  String youSuffix(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
