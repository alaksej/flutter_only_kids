import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String region = 'europe-west1';

class CloudFunctionsService {
  final FirebaseFunctions instance = FirebaseFunctions.instanceFor(app: FirebaseFirestore.instance.app, region: region);

  Future<dynamic> call(String functionName, [Map<String, dynamic>? parameters]) async {
    final HttpsCallable callable = instance.httpsCallable(functionName);

    try {
      final HttpsCallableResult result = await callable.call(parameters);
      return result.data;
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
      throw e;
    } catch (e) {
      print('caught generic exception');
      print(e);
      throw e;
    }
  }
}
