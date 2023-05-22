import 'package:permisos/models/scripts.dart';

class Connection {
  String? nombre;
  String? hostIp;
  String? port;
  String? database;
  String? user;
  String? pass;
  List<Script>? script;

  Connection({this.nombre, this.hostIp, this.port, this.database, this.user, this.pass, this.script});

  Connection.fromJson(Map<String, dynamic> json) {
    nombre = json['Nombre'];
    hostIp = json['HostIp'];
    port = json['Port'];
    database = json['Database'];
    user = json['User'];
    pass = json['Pass'];
    if (json['Script'] != null) {
      script = <Script>[];
      json['Script'].forEach((v) {
        script!.add(new Script.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Nombre'] = this.nombre;
    data['HostIp'] = this.hostIp;
    data['Port'] = this.port;
    data['Database'] = this.database;
    data['User'] = this.user;
    data['Pass'] = this.pass;
    if (this.script != null) {
      data['Script'] = this.script!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
