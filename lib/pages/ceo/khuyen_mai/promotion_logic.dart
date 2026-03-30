// Model định nghĩa một chương trình Khuyến Mãi
class KhuyenMai {
  final String id;
  final String tenChuongTrinh;
  final double phanTramGiam; // Ví dụ: 0.1 là giảm 10%
  final double tienGiamTrucTiep; // Ví dụ: 20000 là giảm thẳng 20k
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;

  KhuyenMai({
    required this.id,
    required this.tenChuongTrinh,
    this.phanTramGiam = 0.0,
    this.tienGiamTrucTiep = 0.0,
    required this.ngayBatDau,
    required this.ngayKetThuc,
  });

  // Hàm kiểm tra xem KM này có đang trong thời gian hiệu lực không
  bool get dangHopLe {
    final now = DateTime.now();
    return now.isAfter(ngayBatDau) && now.isBefore(ngayKetThuc);
  }
}

// BỘ NÃO TÍNH TIỀN LÚC THANH TOÁN
class CheckoutLogic {
  static double tinhGiaThanhToan(double giaNiemYet, KhuyenMai? khuyenMaiApDung) {
    // 1. Nếu không có KM hoặc KM đã hết hạn -> Trả về nguyên giá niêm yết
    if (khuyenMaiApDung == null || !khuyenMaiApDung.dangHopLe) {
      return giaNiemYet;
    }

    // 2. Logic tính giá: Giá cuối = Giá gốc * (1 - Hệ số giảm) - Tiền giảm thẳng
    // Ví dụ: Giá 100k, giảm 10% (0.1) -> 100k * (1 - 0.1) = 90k
    double giaCuoi = giaNiemYet * (1 - khuyenMaiApDung.phanTramGiam) - khuyenMaiApDung.tienGiamTrucTiep;

    // 3. Chặn lỗi logic (Giá không bao giờ được âm)
    return giaCuoi > 0 ? giaCuoi : 0;
  }
}