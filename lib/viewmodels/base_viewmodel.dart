import 'package:flutter/foundation.dart';

/// 모든 ViewModel의 기본 클래스
/// ChangeNotifier를 상속하여 UI 상태 변경을 알림
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  /// 로딩 상태
  bool get isLoading => _isLoading;

  /// 에러 메시지
  String? get error => _error;

  /// ViewModel이 dispose되었는지 확인
  bool get isDisposed => _isDisposed;

  /// 로딩 상태 설정
  void setLoading(bool loading) {
    if (_isDisposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  /// 에러 상태 설정
  void setError(String? error) {
    if (_isDisposed) return;
    _error = error;
    notifyListeners();
  }

  /// 에러 상태 초기화
  void clearError() {
    if (_isDisposed) return;
    _error = null;
    notifyListeners();
  }

  /// 로딩과 에러 상태를 모두 초기화
  void resetState() {
    if (_isDisposed) return;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  /// ViewModel이 dispose될 때 호출
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// 안전한 상태 업데이트 (dispose 체크 후)
  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }
}
