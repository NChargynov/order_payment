enum EnvType {
  development,
  local;

  bool get isDevelopment => this == EnvType.development;
}
