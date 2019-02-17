abstract class ApiConnectionService {
  Future checkConnection(String url);
}

class MockConnectionService implements ApiConnectionService{
  final num delay;

  MockConnectionService(this.delay);

  @override
  Future checkConnection(String url) async {
    return Future.delayed(Duration(milliseconds: delay), () => {});
  }

}