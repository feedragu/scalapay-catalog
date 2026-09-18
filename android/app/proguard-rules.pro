# The Flutter Gradle plugin already keeps io.flutter.** and the embedding.
# Dart code is compiled ahead of time and obfuscated separately
# (--obfuscate --split-debug-info), so no rules are needed for Dart packages.

# Kotlin metadata is not used at runtime by this app.
-dontwarn kotlin.**

# Keep line numbers for readable native stack traces in crash reports.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
