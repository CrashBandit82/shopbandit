/// Password rule shared with the server hook (server/pb_hooks/shopbandit.js).
enum PasswordRule { minLength, uppercase, lowercase, digit, special }

const passwordMinLength = 8;

/// Returns the rules [password] does not satisfy (empty = valid).
Set<PasswordRule> passwordProblems(String password) {
  return {
    if (password.length < passwordMinLength) PasswordRule.minLength,
    if (!RegExp('[A-Z]').hasMatch(password)) PasswordRule.uppercase,
    if (!RegExp('[a-z]').hasMatch(password)) PasswordRule.lowercase,
    if (!RegExp('[0-9]').hasMatch(password)) PasswordRule.digit,
    if (!RegExp('[^A-Za-z0-9]').hasMatch(password)) PasswordRule.special,
  };
}

bool isValidPassword(String password) => passwordProblems(password).isEmpty;
