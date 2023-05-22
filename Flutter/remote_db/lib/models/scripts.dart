class Script {
  String? nombre;
  String? descripcion;
  String? scriptString;
  String? idPadre;

  Script({this.nombre, this.descripcion, this.scriptString, this.idPadre});

  Script.fromJson(Map<String, dynamic> json) {
    nombre = json['Nombre'];
    descripcion = json['Descripcion'];
    scriptString = json['ScriptString'];
    idPadre = json['IdPadre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Nombre'] = this.nombre;
    data['Descripcion'] = this.descripcion;
    data['ScriptString'] = this.scriptString;
    data['IdPadre'] = this.idPadre;
    return data;
  }
}
