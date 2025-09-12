import 'url_launcher_service.dart';
import 'navigation_service.dart';
import 'data_service.dart';
import '../viewmodels/main_viewmodel.dart';


/// 서비스 의존성 주입을 관리하는 클래스
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal(); //static final을 통해 클래스수준에서 단 하나만 존재하는 변수를 둔다. 또한 재할당이 불가능하도록함
  //_instance: 싱글턴 인스턴스를 담는 변수
  factory ServiceLocator() => _instance;
  // factory 생성자.: 매번 new호출해도 항상 같은 인스턴스를 반환하게함.
  //즉, ServiceLocator()를 반환해도 이미 만들어진 _instance를 돌려준다.
  ServiceLocator._internal();

  // 서비스 인스턴스들
  late final UrlLauncherService _urlLauncherService;
  late final NavigationService _navigationService;
  late final DataService _dataService;

  // ViewModel 인스턴스들
  late final MainViewModel _mainViewModel;

  /// 서비스 초기화
  void initialize(){  //싱글톤 컨테이너 안에서 의존성을 한 번만 주입해 놓는 함수
  //service 인스턴스 생성
  _urlLauncherService = UrlLauncherService();
  _navigationService = NavigationService();
  _dataService = DataService();

    // ViewModel 인스턴스 생성 (의존성 주입)
  _mainViewModel = MainViewModel(urlService: _urlLauncherService, navService: _navigationService);
  }

  /// service 인스턴스 반환
  //get은 읽기 전용 속성 생성시 사용
  // 즉, get은 외부네서 싱글톤이 가진 인스턴스를 읽을 수 있게하는 인터페이스!!
  UrlLauncherService get urlLauncherService => _urlLauncherService;
  NavigationService get navigationService => _navigationService;
  DataService get dataService => _dataService;

  ///ViewModel 인스턴스 반환
  MainViewModel get mainViewModel => _mainViewModel;

  /// 모든 서비스 정리
  void dispose() {
    _mainViewModel.dispose();
  }
}

/// 전역 서비스 로케이터 인스턴스
final serviceLocator = ServiceLocator();
