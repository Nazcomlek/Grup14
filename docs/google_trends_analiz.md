# Google Trends Analizi

Bu doküman, "Güzellik Trendleri" projesinde Google Trends verisinin analizini özetler.

## Veri

- Kaynak: Google Trends, Türkiye (`time_series_TR_20240101-0300_20261104-2056.csv`).
- Dönem: 2023-12-31 → 2024-12-29, 53 haftalık gözlem (hafta pazar günü başlar).
- Kategoriler (arama terimleri): şampuan, parfüm, makyaj, kozmetik.
- Değerler 0–100 arası göreli arama ilgisi puanıdır. 100, ilgili dönemdeki en yüksek ilgiyi gösterir. Mutlak arama sayısı değildir.

## İlgili dbt çıktıları

| Dosya | Açıklama |
|---|---|
| `models/staging/stg_google_trends.sql` | Ham veriyi temizler, tarih ve puan kolonlarını tiplendirir. |
| `models/marts/mart_trends_haftalik.sql` | Haftalık veriyi (tarih, kategori, arama_puani) uzun formata çevirir. Power BI çizgi grafiğinin kaynağıdır. |
| `models/marts/mart_trends_kategori_siralama.sql` | Kategori bazında ortalama, en yüksek, en düşük puan ve ilgi sırası. |
| `tests/test_trends_puan_araligi.sql` | Arama puanı 0–100 dışında olan satırları yakalar. |

## Kategori karşılaştırması

| Sıra | Kategori | Ortalama | En yüksek | En düşük |
|---|---|---|---|---|
| 1 | Parfüm | 81,72 | 100 | 67 |
| 2 | Şampuan | 29,06 | 34 | 25 |
| 3 | Makyaj | 20,36 | 23 | 17 |
| 4 | Kozmetik | 12,28 | 15 | 10 |

2024'te en çok ilgi gören kategori **parfüm**dür. Ortalaması şampuanın yaklaşık 2,8 katıdır. Dört kategorinin puanları ayrı aralıklarda kalır ve hiçbir hafta birbirinin yerine geçmez.

## Haftalık eğilimler

**Parfüm**
- Yılın en yüksek ilgisi 24 Kasım haftasında (100). 22 Aralık haftası da 99'a ulaşır.
- Aylık ortalama en yüksek Kasım'da (95,0). Aralık 87,8, Şubat ve Ekim 85,5 ile devam eder.
- Yaz aylarında ilgi daha düşüktür. Temmuz ortalaması 73,5, Ocak ortalaması 70,5'tir.
- Şubat başında kısa bir sıçrama vardır (4 Şubat: 87, 11 Şubat: 92). Bu, Sevgililer Günü ile ilgili olabilir. Veri bunu doğrulamaz, yalnızca olası bir yorumdur.
- Yılın ikinci yarısında genel bir yükseliş eğilimi görülür.

**Şampuan**
- Yıl boyunca yavaş bir düşüş eğilimi vardır: Ocak'ta 34, yıl sonunda 25.
- Belirgin bir mevsimsel tepe görülmez.

**Makyaj**
- 17–23 gibi dar bir bantta seyreder. Ocak–Ağustos arası görece yüksek, Eylül–Ekim arası daha düşüktür (17–19).

**Kozmetik**
- En düşük ve en az dalgalanan kategoridir (10–15).
- Şubat başındaki tepeden (15) sonra belirgin bir eğilim göstermez.

**Kategoriler arası ilişki**
- Parfüm ile makyaj arasındaki haftalık korelasyon yaklaşık −0,07'dir. Yani iki kategorinin haftalık hareketleri neredeyse birbirinden bağımsızdır. Yalnızca bu çift incelenmiştir.

## Power BI

Rapor: **Google Trends Haftalik Rapor** (Power BI Service).
Grafik: **Kategorilere Göre Haftalık Google Trends Eğilimleri** (çizgi grafik). X ekseni tarih, Y ekseni ortalama arama puanı, gösterge kategori. Kaynak: `mart_trends_haftalik`.
Link: https://app.powerbi.com/links/Q5c-mcbXkl?ctid=de24a125-09c4-4916-a8eb-d3d035168252&pbi_source=linkShare[https://app.powerbi.com/links/Q5c-mcbXkl?ctid=de24a125-09c4-4916-a8eb-d3d035168252&pbi_source=linkShare]

## Sınırlılıklar

- Veri yalnızca 2024 yılını kapsar. Mevsimselliği güvenle söylemek için tek yıl yeterli değildir, yorumlar "2024'te şöyle görünüyor" şeklinde okunmalıdır.
- Puanlar göreli olduğu için arama hacmi hakkında mutlak bir bilgi vermez.
- Haftalık veriyle satış verisi (günlük) karşılaştırılırken satışın aynı hafta tanımıyla (pazar başlangıçlı) toplanması gerekir. Bu karşılaştırma 4. kişinin kapsamındadır.
