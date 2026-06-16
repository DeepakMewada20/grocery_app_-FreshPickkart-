class InstallReferrerDetails {
  final String installReferrer;
  InstallReferrerDetails(this.installReferrer);
}

class PlayInstallReferrer {
  static Future<InstallReferrerDetails> get installReferrer async {
    throw UnsupportedError('PlayInstallReferrer not available on web');
  }
}
