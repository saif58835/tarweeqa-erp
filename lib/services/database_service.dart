import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveInvoiceSecurly(String storeId, Map<String, dynamic> invoice) async {
    try {
      await _db.runTransaction((transaction) async {
        final invRef = _db.collection('stores').doc(storeId).collection('invoices').doc();
        transaction.set(invRef, {
          ...invoice,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'finalized',
        });
      });
    } catch (e) {
      Get.snackbar("خطأ", "فشلت عملية الحفظ: $e");
    }
  }

  Future<void> requestDelete(String storeId, String invoiceId, String empName) async {
    try {
      await _db.collection('stores').doc(storeId).collection('invoices').doc(invoiceId).update({
        'status': 'pending_delete',
        'requestedBy': empName,
      });
      Get.snackbar("تم", "تم إرسال طلب حذف الفاتورة للمراجعة");
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء طلب الحذف: $e");
    }
  }
}
