class ModelSolarPowerPlants {
  String? name;
  String? address;
  String? capacityKW;
  String? locationOfPlant;
  String? division;
  String? district;
  String? latitude;
  String? longitude;

  ModelSolarPowerPlants(
      {this.name,
        this.address,
        this.capacityKW,
        this.locationOfPlant,
        this.division,
        this.district,
        this.latitude,
        this.longitude}
      );

  ModelSolarPowerPlants.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    address = json['Address'];
    capacityKW = json['Capacity (kW)'];
    locationOfPlant = json['Location of Plant'];
    division = json['Division'];
    district = json['District'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Address'] = this.address;
    data['Capacity (kW)'] = this.capacityKW;
    data['Location of Plant'] = this.locationOfPlant;
    data['Division'] = this.division;
    data['District'] = this.district;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    return data;
  }
}