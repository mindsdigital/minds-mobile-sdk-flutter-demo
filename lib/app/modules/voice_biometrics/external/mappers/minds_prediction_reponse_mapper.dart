import '../../domain/enums/minds_prediction_reponse.dart';

class MindsPredictionResponseMapper {
  MindsPredictionResponse fromEnum(String prediction) {
    switch (prediction) {
      case "match":
        return MindsPredictionResponse.match;
      case "different":
        return MindsPredictionResponse.different;
    }
    throw UnimplementedError("Prediction not implemented");
  }
}
