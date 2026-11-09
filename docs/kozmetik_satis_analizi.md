# Kozmetik Ürün Satış Analizi

Bu doküman, "Güzellik Trendleri" projesinde NovaPerakende satış verisindeki kozmetik ürünlerin analizini özetler.

## Veri

- Kaynak: NovaPerakende satış verisi (`perakende_satis.csv`), 2000 sipariş satırı.
- Dönem: 2024-01-01 → 2024-12-31.
- Kozmetik kategorisi: 275 satır (tüm satışların yaklaşık %13,8'i), 4 ürün: Cilt Bakım Seti, Şampuan, Parfüm, Makyaj Paleti.

## İlgili dbt çıktıları

| Dosya | Açıklama |
|---|---|
| `models/staging/stg_perakende_satis.sql` | Satış verisini temizler ve tiplendirir. |
| `models/marts/mart_kozmetik_satis.sql` | Kozmetik ürünleri için ürün bazında satış adedi, sipariş sayısı, brüt ve net satış tutarı. |
| `tests/test_kozmetik_satis_tutarlilik.sql` | Satış adedi 0 veya negatif olan ya da net tutarı brüt tutardan büyük olan ürünleri yakalar. |
| `tests/test_kozmetik_indirim_orani_araligi.sql` | `indirim_orani` değeri 0–1 aralığı dışında olan kozmetik satırlarını yakalar. |

## Ürün bazında sonuçlar

| Ürün | Satış adedi | Pay | Sipariş | Brüt tutar | Net tutar | İndirim tutarı |
|---|---|---|---|---|---|---|
| Cilt Bakım Seti | 218 | %26,5 | 74 | 105.150,00 | 101.867,00 | 3.283,00 |
| Şampuan | 211 | %25,7 | 74 | 107.100,00 | 96.561,50 | 10.538,50 |
| Parfüm | 198 | %24,1 | 66 | 95.930,00 | 92.391,50 | 3.538,50 |
| Makyaj Paleti | 195 | %23,7 | 61 | 96.530,00 | 91.377,50 | 5.152,50 |
| **Toplam** | **822** | %100 | **275** | **404.710,00** | **382.197,50** | **22.512,50** |

## Yorumlar

- **En çok satılan ürün Cilt Bakım Seti** (218 adet). Ancak ürünler birbirine yakındır: birinci ve son ürün arasında yalnızca 23 adet fark vardır ve her ürün toplam satışın yaklaşık dörtte birini oluşturur.
- **Sipariş sayısı:** Cilt Bakım Seti ve Şampuan 74'er siparişle öndedir. Makyaj Paleti en az siparişe (61) sahiptir, ancak sipariş başına adedi en yüksektir (yaklaşık 3,2 adet). Yani az sipariş, ama sipariş başına daha fazla ürün satılmıştır.
- **İndirim etkisi:** Toplam brüt tutardan net tutara geçişte yaklaşık 22.512 birimlik indirim uygulanmıştır (brüt tutarın yaklaşık %5,6'sı). Kozmetik satırlarının yaklaşık %42'sinde indirim vardır. **Şampuan** diğerlerinden belirgin biçimde fazla indirimle satılmıştır (yaklaşık %9,8), Cilt Bakım Seti ve Parfüm'de bu oran %3–4 civarındadır.
- Şampuan, adet sıralamasında ikinci olmasına rağmen net tutar sıralamasında ilk sırayı Cilt Bakım Seti'ne bırakır. Bunun nedeni indirim farkıdır.

## Veri kalitesi notu

`indirim_orani` kolonu 0–1 arası bir orandır (0,2 = %20). Önceki sürümde `mart_kozmetik_satis.sql` bu değeri 100'e bölüyordu, bu yüzden indirim yaklaşık yüzde 0,1 gibi çok düşük görünüyor ve net tutar brüt tutara neredeyse eşit çıkıyordu. Formül `(1 - indirim_orani)` olarak düzeltilmiştir. `tests/test_kozmetik_indirim_orani_araligi.sql` bu kolonun oran olarak kullanıldığını belgeler.

`mart_kozmetik_kanal_bolge.sql` dosyasında da aynı formül kullanılmaktadır. Bölge ve kanal analizinde net satış tutarı bu nedenle gözden geçirilmelidir (2. kişinin kapsamı).

## Power BI

Rapor: **Kozmetik Satis Urun Rapor** (Power BI Service).
Grafik: **Ürünlere Göre Toplam Satış Adedi (Kozmetik)** (sütun grafik). X ekseni ürün, Y ekseni toplam satış adedi. Kaynak: `mart_kozmetik_satis`.
Link: https://app.powerbi.com/links/DufF0gWJc0?ctid=de24a125-09c4-4916-a8eb-d3d035168252&pbi_source=linkShare

## Sınırlılıklar

- Veri yalnızca 2024 yılını ve dört ürünü kapsar. Ürünler arasındaki farklar küçük olduğundan sıralama tek yıllık veriye göre yorumlanmalıdır.
- Analiz yalnızca Kozmetik kategorisini kapsar. Diğer kategoriler (Giyim, Elektronik vb.) dahil değildir.
- Google Trends verisiyle karşılaştırma 4. kişinin kapsamındadır.
