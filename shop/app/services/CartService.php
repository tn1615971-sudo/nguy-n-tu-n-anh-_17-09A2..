<?php
// app/services/CartService.php
// Doc lai gio hang tu session, doi chieu CSDL va tra ve du lieu SAN SANG hien thi.
// Day la noi DUY NHAT tinh tien gio hang - view KHONG tu tinh toan gi them.

class CartService
{
    /**
     * @return array{lines: array<int,array>, subtotal: float, adjusted: bool, removed: string[]}
     */
    public static function build(): array
    {
        $items = Cart::items();
        if (empty($items)) {
            return ['lines' => [], 'subtotal' => 0.0, 'adjusted' => false, 'removed' => []];
        }

        // MOT truy van duy nhat lay toan bo san pham co trong gio, kem anh dai dien
        $products = Product::findManyWithImage(array_keys($items));

        $lines = [];
        $subtotal = 0.0;
        $adjusted = false;
        $removed = [];

        foreach ($items as $productId => $qty) {
            $productId = (int) $productId;
            $product = $products[$productId] ?? null;

            // San pham khong con ton tai hoac da ngung kinh doanh -> loai khoi gio
            if (!$product || $product['status'] !== 'active') {
                Cart::remove($productId);
                $removed[] = $product['name'] ?? ('#' . $productId);
                continue;
            }

            $qty = (int) $qty;
            $stock = (int) $product['stock'];

            // So luong KHONG duoc vuot ton kho; vuot thi tu dieu chinh ve toi da
            // va cap nhat lai session cho dung voi thuc te, dong thoi ghi nhan de bao cho khach.
            if ($qty > $stock) {
                $adjusted = true;
                if ($stock <= 0) {
                    Cart::remove($productId);
                    $removed[] = $product['name'];
                    continue;
                }
                $qty = $stock;
                Cart::setQuantity($productId, $qty);
            }

            $lineTotal = (float) $product['price'] * $qty;
            $subtotal += $lineTotal;

            $lines[] = [
                'product_id' => $productId,
                'name' => $product['name'],
                'price' => (float) $product['price'],
                'quantity' => $qty,
                'stock' => $stock,
                'line_total' => $lineTotal,
                'image' => $product['image'],
            ];
        }

        return [
            'lines' => $lines,
            'subtotal' => $subtotal,
            'adjusted' => $adjusted,
            'removed' => $removed,
        ];
    }
}
