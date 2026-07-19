/// حالة عامة تُستخدم كأساس لأي Bloc/Cubit لاحقاً عند ربط الواجهات
/// بالباك ايند (بدل تعريف enum مشابه في كل Bloc على حدة).
enum RequestStatus { initial, loading, success, failure }
