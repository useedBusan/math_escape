import 'url_launcher_service.dart';
import 'navigation_service.dart';
import 'data_service.dart';
import '../viewmodels/main_viewmodel.dart';

/// 서비스 의존성 주입을 관리하는 클래스
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // 서비스 인스턴스들
  late final UrlLauncherService _urlLauncherService;
  late final NavigationService _navigationService;
  late final DataService _dataService;

  // ViewModel 인스턴스들
  late final MainViewModel _mainViewModel;

  /// 서비스 초기화
  void initialize() {
    // 서비스 인스턴스 생성
    _urlLauncherService = UrlLauncherService();
    _navigationService = NavigationService();
    _dataService = DataService();

    // ViewModel 인스턴스 생성 (의존성 주입)
    _mainViewModel = MainViewModel(
      urlService: _urlLauncherService,
      navService: _navigationService,
    );
  }

  /// 서비스 인스턴스 반환
  UrlLauncherService get urlLauncherService => _urlLauncherService;
  NavigationService get navigationService => _navigationService;
  DataService get dataService => _dataService;

  /// ViewModel 인스턴스 반환
  MainViewModel get mainViewModel => _mainViewModel;

  /// 모든 서비스 정리
  void dispose() {
    _mainViewModel.dispose();
  }
}

/// 전역 서비스 로케이터 인스턴스
final serviceLocator = ServiceLocator();
