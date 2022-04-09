class TrelloClient {
  late String _key;
  late String _secret;
  TrelloClient({required String key, required String secret}) {
    this._key = key;
    this._secret = secret;
  }
}
