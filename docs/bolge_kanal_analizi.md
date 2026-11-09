**Bölge ve Satış Kanalı Analizi**  
Bu doküman, "Güzellik Trendleri" projesinde kozmetik satışlarının bölge ve satış kanalı (online / mağaza) kırılımındaki analizini özetler.  
**Veri**  
- Kaynak: NovaPerakende satış verisi (`perakende_satis.csv`), dönem 2024-01-01 → 2024-12-31.  
- Kapsam: yalnızca Kozmetik kategorisi (275 sipariş satırı, 822 adet).  
- Kanallar: Online, Mağaza. Bölgeler: Marmara, İç Anadolu, Akdeniz, Ege, Güneydoğu, Karadeniz.  
- Net satış tutarı = miktar × birim fiyat × (1 − indirim oranı).  
**İlgili dbt çıktıları**  
  
|  |  |  
| - | - |  
| **Dosya** |  **Açıklama** |  
| `models/staging/stg_perakende_satis.sql` |  Satış verisini temizler ve tiplendirir. |  
| `models/marts/mart_kozmetik_kanal_bolge.sql` |  Kanal ve bölge bazında sipariş sayısı, satış adedi ve net satış tutarı. |  
| `tests/test_kanal_bolge_gecerli_degerler.sql` |  Kanal 'Online' veya 'Mağaza' dışında ya da bölge boşsa satır döndürür. |  
| `tests/test_kanal_bolge_tutarlilik.sql` |  Sipariş sayısı, adet ve net tutar pozitif olmalı. Martın adet toplamı staging'deki kozmetik adet toplamına eşit olmalı. |  
  
   
**Bölgelere göre net satış tutarı**  
  
|  |  |  |  |  |  
| - | - | - | - | - |  
| **Bölge** |  **Sipariş** |  **Adet** |  **Net tutar** |  **Pay** |  
| Marmara |  110 |  338 |  155.370,50 |  %40,7 |  
| İç Anadolu |  60 |  169 |  82.137,50 |  %21,5 |  
| Akdeniz |  40 |  135 |  67.122,00 |  %17,6 |  
| Ege |  30 |  81 |  29.574,00 |  %7,7 |  
| Güneydoğu |  22 |  65 |  29.273,50 |  %7,7 |  
| Karadeniz |  13 |  34 |  18.720,00 |  %4,9 |  
| **Toplam** |  **275** |  **822** |  **382.197,50** |  %100 |  
  
   
**Kanallara göre sonuçlar**  
  
|  |  |  |  |  |  
| - | - | - | - | - |  
| **Kanal** |  **Sipariş** |  **Adet** |  **Net tutar** |  **Pay** |  
| Online |  179 |  534 |  246.797,00 |  %64,6 |  
| Mağaza |  96 |  288 |  135.400,50 |  %35,4 |  
  
   
**Yorumlar**  
- **Marmara** net satış tutarının yaklaşık %41'iyle açık ara öndedir. İlk üç bölge (Marmara, İç Anadolu, Akdeniz) toplamın yaklaşık %80'ini oluşturur.  
- **Online kanal** net tutarın yaklaşık üçte ikisini (%64,6) ve siparişlerin yaklaşık %65'ini oluşturur.  
- Beş bölgede online kanal mağazadan fazladır. Tek istisna **Karadeniz**'dir: orada mağaza (10.116,50, 7 sipariş) online kanaldan (8.603,50, 6 sipariş) biraz öndedir.  
- Online-mağaza farkı en büyük olan bölgeler **Güneydoğu** (22.753,50 – 6.520,00) ve **İç Anadolu**'dur (59.832,00 – 22.305,50). Marmara'da mağaza kanalı da güçlüdür (online 96.648,00, mağaza 58.722,50).  
- En düşük toplam satış **Karadeniz**'dedir (18.720,00, 13 sipariş).  
**Veri kalitesi notu**  
`indirim_orani` kolonu 0–1 arası bir orandır (0,2 = %20). Önceki sürümde bu mart `(1 - indirim_orani / 100)` kullandığından indirim yaklaşık yüzde 0,1 gibi çok düşük uygulanıyordu ve net tutarlar brüt tutara neredeyse eşit çıkıyordu. Formül `(1 - indirim_orani)` olarak düzeltilmiştir. Düzeltilmiş toplam net tutar (382.197,50), `mart_kozmetik_satis` martının toplamıyla aynıdır, yani iki mart birbiriyle tutarlıdır.  
**Power BI**  
Grafik: bölgelere göre net satış tutarı (çubuk grafik). Kaynak: `mart_kozmetik_kanal_bolge`. Link: https://app.powerbi.com/links/7WtzSrCWU4?ctid=de24a125-09c4-4916-a8eb-d3d035168252&pbi_source=linkShare  
**Sınırlılıklar**  
- Veri yalnızca 2024 yılını ve yalnızca Kozmetik kategorisini kapsar. Diğer kategoriler dahil değildir.  
- Küçük bölgelerde (Karadeniz, Güneydoğu) sipariş sayısı azdır (5–17 sipariş), bu yüzden kanal karşılaştırmaları temkinli yorumlanmalıdır.  
- Google Trends verisiyle karşılaştırma 4. kişinin kapsamındadır.  
