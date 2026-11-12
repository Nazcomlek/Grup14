# Google Trends ve Satış Verisi Karşılaştırması

Bu doküman, "Güzellik Trendleri" projesinde Google Trends arama ilgisi ile kozmetik satışları arasındaki ilişkiyi inceler.

## Ortak tarih aralığı

| Veri | Aralık | Sıklık |
|---|---|---|
| Google Trends | 2023-12-31 → 2024-12-29 | Haftalık (hafta pazar günü başlar) |
| NovaPerakende satışı | 2024-01-01 → 2024-12-31 | Günlük |
| **Ortak aralık** | **2024-01-01 → 2024-12-29** | Haftalık |

Satışlar Trends ile aynı hafta tanımıyla (pazar başlangıçlı) haftalara toplanmıştır. İki hafta satış verisinde eksik gün içerdiği için `tam_hafta = false` olarak işaretlenmiştir:

- 2023-12-31 haftası: satış verisi 2024-01-01'de başladığından Pazar günü (31 Aralık) eksik.
- 2024-12-29 haftası: satış verisi 31 Aralık'ta bittiği için yalnızca 3 gün var.

Korelasyon yalnızca **51 tam haftada** (2024-01-07 → 2024-12-22) hesaplanmıştır. Tüm haftalar toplandığında satış adedi 822'dir ve `mart_kozmetik_satis` ile aynıdır.

## Eşleştirme

Satış ürünleri ile arama terimleri birebir örtüşmediği için şu eşleştirme kullanılmıştır:

| Trends terimi | Satış tarafı |
|---|---|
| şampuan | Şampuan ürünü |
| parfüm | Parfüm ürünü |
| makyaj | Makyaj Paleti ürünü |
| kozmetik | Tüm kozmetik ürünleri (genel terim) |

Cilt Bakım Seti, ürün bazında bir arama terimiyle eşleşmediği için yalnızca "kozmetik" toplamında yer alır.

## İlgili dbt çıktıları

| Dosya | Açıklama |
|---|---|
| `models/marts/mart_trends_satis_haftalik.sql` | Haftalık arama puanı ile satış adedi ve net satış tutarını kategori bazında birleştirir. |
| `models/marts/mart_trends_satis_korelasyon.sql` | Kategori bazında arama puanı ile satış adedi arasındaki Pearson korelasyonu (aynı hafta ve 1 hafta sonrası). |
| `tests/test_trends_satis_ortak_aralik.sql` | Tam haftaların ortak aralıkta kaldığını ve her kategorinin aynı sayıda tam haftaya sahip olduğunu doğrular. |
| `tests/test_trends_satis_korelasyon_araligi.sql` | Korelasyonların boş olmadığını ve −1 ile 1 arasında olduğunu doğrular. |

## Korelasyon sonuçları (51 tam hafta)

| Kategori | Ort. arama puanı | Ort. haftalık satış adedi | Aynı hafta | 1 hafta sonra |
|---|---|---|---|---|
| Şampuan | 29,06 | 3,76 | −0,172 | −0,108 |
| Parfüm | 81,73 | 3,75 | 0,140 | 0,256 |
| Makyaj | 20,47 | 3,73 | −0,223 | −0,132 |
| Kozmetik (genel) | 12,33 | 15,43 | −0,160 | 0,019 |

"1 hafta sonra", t haftasındaki arama puanı ile t+1 haftasındaki satış adedinin korelasyonudur.

## Yorum

- **Tüm korelasyonlar zayıftır** (mutlak değer 0,26'nın altında). 51 gözlemle bu düzeydeki korelasyonlar %5 anlamlılık düzeyinde istatistiksel olarak anlamlı değildir (anlamlılık için yaklaşık ±0,28 gerekir).
- Parfüm için tek pozitif ve en yüksek ilişki 1 hafta gecikmeli sonuçtur (0,256). Arama ilgisi yüksek haftanın ardından satış artışına dair bir eğilim işareti olabilir, ancak güçlü bir kanıt değildir ve anlamlılık eşiğinin altındadır.
- Şampuan ve makyaj için ilişki hafif negatiftir. Bu, arama ilgisi arttığında satışın azaldığı anlamına gelmez. Bu düzeydeki değerler rastlantıyla da açıklanabilir.
- Yani bu veride Google Trends arama ilgisinin haftalık kozmetik satışlarını belirgin biçimde açıkladığına dair bir kanıt yoktur.

## Sınırlılıklar

- Haftalık satış adetleri çok küçüktür (ürün başına haftada ortalama yaklaşık 3,7 adet). Bu, korelasyonları gürültülü yapar. 51 tam haftanın bir bölümünde ürün satışı sıfırdır (Makyaj 20, Şampuan 17, Parfüm 14 hafta).
- Veri yalnızca 2024'ü kapsar. Mevsimsel ilişkiler tek yıldan güvenle çıkarılamaz.
- Google Trends puanları göreli (0–100) olduğu için mutlak arama hacmi bilinmez.
- Korelasyon nedensellik değildir. Satış verisi tek bir mağaza zincirine aittir ve Türkiye genelindeki aramayı temsil etmez.
- Birden çok korelasyon (4 kategori × 2 gecikme) hesaplandığı için tesadüfen yüksek görünen değerler olabilir.

## Power BI

Önerilen grafik: seçili kategori için haftalık arama puanı ve satış adedi (iki eksenli çizgi grafik), kategori slicer'ı ile. Kaynak: `mart_trends_satis_haftalik`. Korelasyon tablosu için `mart_trends_satis_korelasyon` kullanılabilir.
Link: https://app.powerbi.com/groups/me/reports/446edcfb-c8eb-4c1b-b38d-3e1dbae80f9b/93b781370bd168a7eaa2?experience=power-bi
