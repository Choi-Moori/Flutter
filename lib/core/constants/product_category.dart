/// 공통으로 사용하는 상품 카테고리 열거형
enum ProductCategory {
  outer,
  top,
  bottom,
  shoes,
}

String categoryToKorean(ProductCategory category) {
  switch (category) {
    case ProductCategory.outer: return '아우터';
    case ProductCategory.top: return '상의';
    case ProductCategory.bottom: return '하의';
    case ProductCategory.shoes: return '신발';
  }
}
