import '../network/api_client.dart';
import '../network/api_config.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/services/auth_api_service.dart';
import '../../features/chat_list/data/datasources/chat_list_remote_datasource.dart';
import '../../features/chat_list/data/repositories/chat_list_repository_impl.dart';
import '../../features/chat_list/domain/services/chat_list_api_service.dart';
import '../../features/explore/data/datasources/explore_remote_datasource.dart';
import '../../features/explore/data/repositories/explore_repository_impl.dart';
import '../../features/explore/domain/services/explore_api_service.dart';
import '../../features/guides/data/datasources/guides_remote_datasource.dart';
import '../../features/guides/data/repositories/guides_repository_impl.dart';
import '../../features/guides/domain/services/guides_api_service.dart';
import '../../features/my_trips/data/datasources/my_trips_remote_datasource.dart';
import '../../features/my_trips/data/repositories/my_trips_repository_impl.dart';
import '../../features/my_trips/domain/services/my_trips_api_service.dart';
import '../../features/notifications/data/datasources/notifications_remote_datasource.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/services/notifications_api_service.dart';
import '../../features/post_write/data/datasources/post_write_remote_datasource.dart';
import '../../features/post_write/data/repositories/post_write_repository_impl.dart';
import '../../features/post_write/domain/services/post_write_api_service.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/services/profile_api_service.dart';
import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/services/search_api_service.dart';
import '../../features/tour_detail/data/datasources/tour_detail_remote_datasource.dart';
import '../../features/tour_detail/data/repositories/tour_detail_repository_impl.dart';
import '../../features/tour_detail/domain/services/tour_detail_api_service.dart';
import '../../features/trip_detail/data/datasources/trip_detail_remote_datasource.dart';
import '../../features/trip_detail/data/repositories/trip_detail_repository_impl.dart';
import '../../features/trip_detail/domain/services/trip_detail_api_service.dart';

/// Đăng ký [ApiClient] và các service REST. Gọi [initialize] một lần ở `main`.
class ApiModule {
  ApiModule._();
  static final ApiModule instance = ApiModule._();

  late final ApiClient jsonPlaceholderClient;
  late final ApiClient reqResClient;

  late final ExploreApiService explore;
  late final TourDetailApiService tourDetail;
  late final MyTripsApiService myTrips;
  late final TripDetailApiService tripDetail;
  late final ChatListApiService chatList;
  late final NotificationsApiService notifications;
  late final ProfileApiService profile;
  late final SearchApiService search;
  late final GuidesApiService guides;
  late final AuthApiService auth;
  late final PostWriteApiService postWrite;

  void initialize({bool enableLogging = true}) {
    jsonPlaceholderClient = ApiClient(
      ApiConfig.jsonPlaceholder(enableLogging: enableLogging),
    );
    reqResClient = ApiClient(ApiConfig.reqRes(enableLogging: enableLogging));

    final jp = jsonPlaceholderClient.dio;
    final rr = reqResClient.dio;

    explore = ExploreApiService(
      ExploreRepositoryImpl(ExploreRemoteDatasource(jp)),
    );
    tourDetail = TourDetailApiService(
      TourDetailRepositoryImpl(TourDetailRemoteDatasource(jp)),
    );
    myTrips = MyTripsApiService(
      MyTripsRepositoryImpl(MyTripsRemoteDatasource(jp)),
    );
    tripDetail = TripDetailApiService(
      TripDetailRepositoryImpl(TripDetailRemoteDatasource(jp)),
    );
    chatList = ChatListApiService(
      ChatListRepositoryImpl(ChatListRemoteDatasource(jp)),
    );
    notifications = NotificationsApiService(
      NotificationsRepositoryImpl(NotificationsRemoteDatasource(jp)),
    );
    profile = ProfileApiService(
      ProfileRepositoryImpl(ProfileRemoteDatasource(jp)),
    );
    search = SearchApiService(
      SearchRepositoryImpl(SearchRemoteDatasource(jp)),
    );
    guides = GuidesApiService(
      GuidesRepositoryImpl(GuidesRemoteDatasource(jp)),
    );
    auth = AuthApiService(
      AuthRepositoryImpl(AuthRemoteDatasource(rr)),
    );
    postWrite = PostWriteApiService(
      PostWriteRepositoryImpl(PostWriteRemoteDatasource(jp)),
    );
  }
}
