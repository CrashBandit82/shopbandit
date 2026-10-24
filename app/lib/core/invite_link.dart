import 'constants.dart';

/// QR payload: `shopbandit://join?server=<url>&token=<token>`
String buildInviteLink(String serverUrl, String token) => Uri(
      scheme: AppInfo.inviteScheme,
      host: 'join',
      queryParameters: {'server': serverUrl, 'token': token},
    ).toString();

/// Accepts a full invite link or a bare token (manual entry).
/// Returns null when [input] is neither.
({String? server, String token})? parseInvite(String input) {
  final s = input.trim();
  final uri = Uri.tryParse(s);
  if (uri != null && uri.scheme == AppInfo.inviteScheme && uri.host == 'join') {
    final token = uri.queryParameters['token'];
    if (token == null || token.isEmpty) return null;
    return (server: uri.queryParameters['server'], token: token.toUpperCase());
  }
  final token = s.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  if (RegExp(r'^[A-Z0-9]{24}$').hasMatch(token)) return (server: null, token: token);
  return null;
}
