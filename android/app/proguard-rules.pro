# Flutter 관련 규칙
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Flutter 엔진
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.embedding.engine.** { *; }

# MainActivity 및 앱 클래스
-keep class com.example.math_escape.MainActivity { *; }
-keep class com.bsmath.math_escape.MainActivity { *; }

# AndroidX 및 Google 라이브러리
-keep class androidx.** { *; }
-keep class com.google.** { *; }

# Keep 어노테이션이 있는 클래스 멤버
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# 리플렉션을 사용하는 클래스들
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# 네이티브 메서드
-keepclasseswithmembernames class * {
    native <methods>;
}

# Parcelable 구현
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# Serializable 구현
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# 플러그인 관련 규칙

# Play Core - Flutter가 내부적으로 사용
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Play Core SplitCompat (Flutter deferred components)
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# permission_handler
-keep class com.baseflow.permissionhandler.** { *; }

# mobile_scanner
-keep class dev.steenbakker.mobile_scanner.** { *; }

# just_audio
-keep class com.ryanheise.just_audio.** { *; }

# video_player
-keep class io.flutter.plugins.videoplayer.** { *; }

# lottie
-keep class com.airbnb.lottie.** { *; }

# url_launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# image_gallery_saver_plus
-keep class image_gallery_saver_plus.** { *; }

# gal
-keep class gal.** { *; }

# Gson (사용하는 경우)
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Kotlin 관련
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# 참고: R8은 기본적으로 코드 최적화와 난독화를 수행합니다.
# 특정 클래스만 보호하려면 위의 -keep 규칙을 사용하세요.
