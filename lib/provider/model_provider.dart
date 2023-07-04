

import 'package:flutter/cupertino.dart';
import 'package:gpt/model/models.dart';
import 'package:gpt/service/api_service.dart';

class ModelsProvider with ChangeNotifier {
  // String currentModel = "text-davinci-003";
  String currentModel = "gpt-3.5-turbo-0301";
  //  String currentModel = "text-davinci-002";
  //  String currentModel = "GPT-4";
  
  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}