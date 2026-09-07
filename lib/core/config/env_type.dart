enum EnvType {
  development,
  local;

  bool get isDevelopment => this == EnvType.development;
  bool get isLocal => this == EnvType.local;
}
