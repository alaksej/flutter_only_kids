import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

const String region = 'europe-west1';

class CloudFunctionsService {
  final CloudFunctions instance = CloudFunctions(app: FirebaseApp.instance, region: region);

  Future<dynamic> call(String functionName, [Map<String, dynamic> parameters]) async {
    final HttpsCallable callable = instance.getHttpsCallable(functionName: functionName);

    try {
      final HttpsCallableResult result = await callable.call(parameters);
      return result.data;
    } on CloudFunctionsException catch (e) {
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
