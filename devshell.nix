{ pkgs }:

with pkgs;

devshell.mkShell {
  name = "android-project";
  motd = ''
    Entered the Android app development environment.
  '';
  env = [
    {
      name = "ANDROID_HOME";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name = "ANDROID_SDK_ROOT";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name = "JAVA_HOME";
      value = jdk11.home;
    }
  ];
  packages = [
    android-studio
    android-sdk
    gradle
    jdk11
    gcc
    wget
  ];
}
