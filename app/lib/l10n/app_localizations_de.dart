// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ShopBandit';

  @override
  String get about => 'Über';

  @override
  String get account => 'Konto';

  @override
  String get add => 'Hinzufügen';

  @override
  String get addItemHint => 'Was fehlt?';

  @override
  String addNamed(String name) {
    return '$name hinzufügen';
  }

  @override
  String addedBy(String name) {
    return 'von $name';
  }

  @override
  String get admin => 'Admin';

  @override
  String get backToLogin => 'Zurück zur Anmeldung';

  @override
  String boughtTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count× gekauft',
      one: '1× gekauft',
      zero: 'noch nie gekauft',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get catalogEmptyTitle => 'Noch keine Artikel';

  @override
  String get catalogEmptyMessage =>
      'Alles, was du einmal auf die Liste setzt, landet hier.';

  @override
  String get changeServer => 'Server wechseln';

  @override
  String get changeServerHint => 'Tippen zum Wechseln (meldet dich ab)';

  @override
  String get changeServerMessage =>
      'Du wirst abgemeldet. Noch nicht übertragene Änderungen gehen verloren.';

  @override
  String checkedOff(String name) {
    return '$name gekauft';
  }

  @override
  String get chooseDistributor => 'Push-Dienst wählen';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get delete => 'Löschen';

  @override
  String deleteNamed(String name) {
    return '$name löschen';
  }

  @override
  String get deleteCatalogMessage =>
      'Der Artikel verschwindet aus Vorschlägen und „Häufig gekauft“. Steht er auf der Liste, wird er dort auch entfernt.';

  @override
  String deleted(String name) {
    return '$name gelöscht';
  }

  @override
  String get displayName => 'Anzeigename';

  @override
  String get displayNameHelp => 'Sehen die anderen in deinem Haushalt';

  @override
  String get email => 'E-Mail';

  @override
  String get emailInvalid => 'Bitte eine gültige E-Mail-Adresse eingeben';

  @override
  String get emailNotVerified => 'E-Mail noch nicht bestätigt';

  @override
  String get emptyListTitle => 'Alles erledigt!';

  @override
  String get emptyListMessage =>
      'Die Liste ist leer. Tipp oben ein, was fehlt – oder wähle aus „Häufig gekauft“.';

  @override
  String get enterCode => 'Einladungscode eingeben';

  @override
  String get errorAlreadyMember => 'Du bist bereits in diesem Haushalt.';

  @override
  String get errorEmailTaken =>
      'Diese E-Mail-Adresse kann nicht verwendet werden.';

  @override
  String get errorForbidden => 'Dafür fehlt dir die Berechtigung.';

  @override
  String get errorGeneric =>
      'Das hat nicht geklappt. Bitte später erneut versuchen.';

  @override
  String get errorInviteExpired => 'Diese Einladung ist abgelaufen.';

  @override
  String get errorInviteInvalid =>
      'Ungültige oder bereits verwendete Einladung.';

  @override
  String get errorLoginFailed => 'E-Mail oder Passwort falsch.';

  @override
  String get errorOffline => 'Keine Verbindung zum Server.';

  @override
  String get errorOnlyMember => 'Du bist das einzige Mitglied.';

  @override
  String get errorPasswordRules => 'Das Passwort erfüllt die Regeln nicht.';

  @override
  String get errorTooManyRequests => 'Zu viele Versuche. Bitte kurz warten.';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get frequentlyBought => 'Häufig gekauft';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get household => 'Haushalt';

  @override
  String get inviteCodeHint => 'z. B. ABCD-EFGH-…';

  @override
  String get inviteExplain =>
      'Lass den QR-Code in der ShopBandit-App scannen oder gib den Code weiter. Gültig 24 Stunden, nur einmal verwendbar.';

  @override
  String get inviteMember => 'Mitglied einladen';

  @override
  String inviteOtherServer(String server) {
    return 'Die Einladung gehört zu einem anderen Server ($server).';
  }

  @override
  String get inviteQrLabel => 'QR-Code der Einladung';

  @override
  String get inviteRevoked => 'Einladung widerrufen.';

  @override
  String inviteValidUntil(String date) {
    return 'Gültig bis $date';
  }

  @override
  String get join => 'Beitreten';

  @override
  String get joinDiscardsOwn =>
      'Deine bisherige Liste und dein Artikelkatalog werden dabei gelöscht.';

  @override
  String get joinHousehold => 'Haushalt beitreten';

  @override
  String joinMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitgliedern',
      one: '1 Mitglied',
    );
    return 'Haushalt „$name“ mit $_temp0 beitreten?';
  }

  @override
  String joined(String name) {
    return 'Willkommen in „$name“!';
  }

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Systemsprache';

  @override
  String get leave => 'Verlassen';

  @override
  String get leaveHousehold => 'Haushalt verlassen';

  @override
  String get leaveHouseholdMessage =>
      'Du bekommst wieder eine eigene, leere Liste.';

  @override
  String get list => 'Liste';

  @override
  String listCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '1 Artikel',
    );
    return '$_temp0';
  }

  @override
  String get login => 'Anmelden';

  @override
  String get loginSubtitle => 'Eure Einkaufsliste – gemeinsam und offline.';

  @override
  String get logout => 'Abmelden';

  @override
  String get logoutMessage => 'Lokale Daten werden von diesem Gerät entfernt.';

  @override
  String get manageCatalog => 'Artikelkatalog';

  @override
  String get manageCatalogHint => 'Gespeicherte Artikel ansehen und löschen';

  @override
  String markBought(String name) {
    return '$name als gekauft markieren';
  }

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0';
  }

  @override
  String get nameRequired => 'Bitte einen Namen eingeben';

  @override
  String get next => 'Weiter';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notifyChannelName => 'Änderungen an der Liste';

  @override
  String get notifyChannelDescription =>
      'Wenn andere Mitglieder Artikel hinzufügen';

  @override
  String notifyItemsAdded(String who, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat $count Artikel hinzugefügt',
      one: 'hat 1 Artikel hinzugefügt',
    );
    return '$who $_temp0';
  }

  @override
  String get notifyOnAdd => 'Bei neuen Artikeln benachrichtigen';

  @override
  String get password => 'Passwort';

  @override
  String get passwordConfirm => 'Passwort wiederholen';

  @override
  String get passwordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get passwordRequired => 'Bitte Passwort eingeben';

  @override
  String get pushModeOff => 'Aus';

  @override
  String get pushModePolling => 'Ohne Push-App: Abfrage etwa alle 15 Minuten';

  @override
  String get pushModeUnifiedPush => 'Sofort über UnifiedPush';

  @override
  String get pushPollingHint =>
      'Für sofortige Benachrichtigungen die App „ntfy“ (F-Droid) installieren und hier erneut einschalten.';

  @override
  String pwRuleLength(int count) {
    return 'Mindestens $count Zeichen';
  }

  @override
  String get pwRuleUpper => 'Ein Großbuchstabe';

  @override
  String get pwRuleLower => 'Ein Kleinbuchstabe';

  @override
  String get pwRuleDigit => 'Eine Ziffer';

  @override
  String get pwRuleSpecial => 'Ein Sonderzeichen';

  @override
  String get pwRuleOk => 'erfüllt';

  @override
  String get pwRuleMissing => 'fehlt';

  @override
  String get quantity => 'Menge';

  @override
  String get quantityExample => 'z. B. 2 oder 500 g';

  @override
  String get quantityHint => 'Menge';

  @override
  String get remove => 'Entfernen';

  @override
  String removeMember(String name) {
    return '$name entfernen';
  }

  @override
  String removeMemberMessage(String name) {
    return '$name verliert den Zugriff auf die Liste und bekommt einen eigenen Haushalt.';
  }

  @override
  String get renameHousehold => 'Haushalt umbenennen';

  @override
  String get resendVerification => 'Bestätigungs-Mail erneut senden';

  @override
  String get resetExplain =>
      'Gib deine E-Mail-Adresse ein. Du bekommst einen Link zum Zurücksetzen des Passworts.';

  @override
  String get resetSent =>
      'Falls ein Konto existiert, ist die E-Mail unterwegs. Bitte auch den Spam-Ordner prüfen.';

  @override
  String get revokeInvite => 'Einladung widerrufen';

  @override
  String get save => 'Speichern';

  @override
  String get scanInvite => 'Einladung scannen';

  @override
  String get sendResetLink => 'Link senden';

  @override
  String get server => 'Server';

  @override
  String get serverExplain =>
      'ShopBandit speichert eure Liste auf einem eigenen Server. Nutze den voreingestellten oder trage deinen ein.';

  @override
  String serverLabel(String host) {
    return 'Server: $host';
  }

  @override
  String get serverSubtitle => 'Mit welchem Server verbinden?';

  @override
  String get serverUnreachable =>
      'Server nicht erreichbar oder kein ShopBandit-Server.';

  @override
  String get serverUrl => 'Server-Adresse';

  @override
  String get settings => 'Einstellungen';

  @override
  String get someone => 'Jemand';

  @override
  String get syncDone => 'Synchronisiert';

  @override
  String get syncError => 'Synchronisierung fehlgeschlagen';

  @override
  String syncOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Offline – $count Änderungen ausstehend',
      one: 'Offline – 1 Änderung ausstehend',
      zero: 'Offline',
    );
    return '$_temp0';
  }

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Änderungen ausstehend',
      one: '1 Änderung ausstehend',
    );
    return '$_temp0';
  }

  @override
  String get syncRunning => 'Synchronisiere …';

  @override
  String get undo => 'Rückgängig';

  @override
  String get verificationSent => 'Bestätigungs-Mail wurde gesendet.';

  @override
  String youSuffix(String name) {
    return '$name (du)';
  }
}
