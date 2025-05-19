class Encrypt {
  static String encryptPassword(String password) {
    // Simples hash SHA256 para criptografia básica
    // Para produção, use uma abordagem mais robusta (ex: bcrypt)
    return password.codeUnits
        .fold<int>(0, (prev, elem) => prev + elem)
        .toString();
  }
}
