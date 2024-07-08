class WrapProjection {
  int? id;
  final double pedestrianHeightCG;
  final double pedestrianFrictionCoefficientMin;
  final double pedestrianFrictionCoefficientMax;
  final double pedestrianProjectionSpeedMin;
  final double pedestrianProjectionSpeedMax;
  final double pedestrianProjectionDistance;
  final double vehicleHeightFront;
  final double vehicleFrictionCoefficientMin;
  final double vehicleFrictionCoefficientMax;
  final double vehicleSpeedSearleMin;
  final double vehicleSpeedSearleMax;
  final double vehicleSpeedLimpertMin;
  final double vehicleSpeedLimpertMax;

  WrapProjection({
    this.id,
    required this.pedestrianHeightCG,
    required this.pedestrianFrictionCoefficientMin,
    required this.pedestrianFrictionCoefficientMax,
    required this.pedestrianProjectionSpeedMin,
    required this.pedestrianProjectionSpeedMax,
    required this.pedestrianProjectionDistance,
    required this.vehicleHeightFront,
    required this.vehicleFrictionCoefficientMin,
    required this.vehicleFrictionCoefficientMax,
    required this.vehicleSpeedSearleMin,
    required this.vehicleSpeedSearleMax,
    required this.vehicleSpeedLimpertMin,
    required this.vehicleSpeedLimpertMax,
  });

  factory WrapProjection.fromJson(Map<String, dynamic> json) {
    return WrapProjection(
      id: json['id'],
      pedestrianHeightCG: json['pedestrianHeightCG'],
      pedestrianFrictionCoefficientMin:
          json['pedestrianFrictionCoefficientMin'],
      pedestrianFrictionCoefficientMax:
          json['pedestrianFrictionCoefficientMax'],
      pedestrianProjectionSpeedMin: json['pedestrianProjectionSpeedMin'],
      pedestrianProjectionSpeedMax: json['pedestrianProjectionSpeedMax'],
      pedestrianProjectionDistance: json['pedestrianProjectionDistance'],
      vehicleHeightFront: json['vehicleHeightFront'],
      vehicleFrictionCoefficientMin: json['vehicleFrictionCoefficientMin'],
      vehicleFrictionCoefficientMax: json['vehicleFrictionCoefficientMax'],
      vehicleSpeedSearleMin: json['vehicleSpeedSearleMin'],
      vehicleSpeedSearleMax: json['vehicleSpeedSearleMax'],
      vehicleSpeedLimpertMin: json['vehicleSpeedLimpertMin'],
      vehicleSpeedLimpertMax: json['vehicleSpeedLimpertMax'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedestrianHeightCG': pedestrianHeightCG,
      'pedestrianFrictionCoefficientMin': pedestrianFrictionCoefficientMin,
      'pedestrianFrictionCoefficientMax': pedestrianFrictionCoefficientMax,
      'pedestrianProjectionSpeedMin': pedestrianProjectionSpeedMin,
      'pedestrianProjectionSpeedMax': pedestrianProjectionSpeedMax,
      'pedestrianProjectionDistance': pedestrianProjectionDistance,
      'vehicleHeightFront': vehicleHeightFront,
      'vehicleFrictionCoefficientMin': vehicleFrictionCoefficientMin,
      'vehicleFrictionCoefficientMax': vehicleFrictionCoefficientMax,
      'vehicleSpeedSearleMin': vehicleSpeedSearleMin,
      'vehicleSpeedSearleMax': vehicleSpeedSearleMax,
      'vehicleSpeedLimpertMin': vehicleSpeedLimpertMin,
      'vehicleSpeedLimpertMax': vehicleSpeedLimpertMax,
    };
  }
}
