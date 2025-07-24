class ScannerQrResponseEntity {
  final String message;
  final ScannerQrResponseStatus status;

  ScannerQrResponseEntity({required this.message, required this.status});
}

enum ScannerQrResponseStatus {
  error,
  success,
}
