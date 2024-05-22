class BusinessRating {
  int id;
  int businessId;
  int reportBy;
  double business_rating;
  int rated_by_count;
  int status;

  BusinessRating({
    this.id = 0,
    this.rated_by_count = 0,
    this.businessId = 0,
    this.reportBy = 0,
    this.business_rating = 0.0,
    this.status = 0,
  });

  factory BusinessRating.fromJson(Map<String, dynamic> json) => BusinessRating(
        id: json['id'] ?? 0,
        rated_by_count: json['rated_by_count'] ?? 0,
        businessId: json['business_id'] ?? 0,
        reportBy: json['report_by'] ?? 0,
        business_rating:
            double.tryParse((json['business_rating'] ?? '').toString()) ?? 0.0,
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        'business_id': businessId,
        'report_by': reportBy,
        'business_rating': business_rating,
        'status': status,
        'rated_by_count': rated_by_count,
      };
}
