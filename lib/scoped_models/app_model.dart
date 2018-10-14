import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/scoped_models/connected_model.dart';

class AppModel extends Model
    with CoreModel, TodosModel, UserModel, SettingsModel {}
