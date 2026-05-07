# CrisisMap iOS — Task Spec & TODO

> **後端不動。** Swift app 消費現有 4 個 Next.js API endpoint。
> **最低版本：** iOS 17.0 | **語言：** Swift 6 | **框架：** SwiftUI + MapKit + Swift Charts

---

## API Contract (現有，不修改)

```
GET /api/events?locale={en|zh-TW}
GET /api/indicators
GET /api/markets
GET /api/actors

統一回傳: { "success": bool, "data": T[], "error"?: string }
```

---

## Task 1: Xcode 專案初始化

**目標：** 建立可編譯的空 SwiftUI 專案骨架

- [ ] 建立 Xcode project: `CrisisMap`, SwiftUI App, iOS 17.0+
- [ ] 設定 Bundle ID: `com.crisismap.app`
- [ ] Info.plist: 預設 dark mode (`UIUserInterfaceStyle = Dark`)
- [ ] 建立資料夾結構：

```
CrisisMap/
├── App/
│   └── CrisisMapApp.swift        # @main entry, TabView root
├── Models/                        # Codable structs
├── Services/                      # APIClient, networking
├── ViewModels/                    # @Observable classes
├── Views/
│   ├── Map/
│   ├── Feed/
│   ├── Charts/
│   └── Shared/                    # 共用元件 (ThreatBadge, CategoryIcon...)
└── Utilities/                     # Color theme, formatters
```

- [ ] 建立 `ContentView.swift`：三個 tab 的 `TabView`
  - Tab 1: 地圖 (icon: `map.fill`, label: "Map")
  - Tab 2: 事件列表 (icon: `list.bullet`, label: "Feed")
  - Tab 3: 儀表板 (icon: `chart.bar.fill`, label: "Dashboard")
- [ ] 確認 build & run 成功 (simulator)

**驗收：** App 啟動，顯示三個空白 tab，可切換。

---

## Task 2: Models — Codable 資料型別

**目標：** 定義所有 API 回傳的 Swift 型別，確保能正確 decode 真實 JSON

### 2.1 Enums

```swift
enum ThreatLevel: String, Codable, CaseIterable {
    case critical, high, medium, low, info

    var color: Color {
        switch self {
        case .critical: .red
        case .high:     .orange
        case .medium:   .yellow
        case .low:      .blue
        case .info:     .gray
        }
    }

    var markerSize: CGFloat {
        switch self {
        case .critical: 16
        case .high:     12
        case .medium:   10
        case .low:      8
        case .info:     6
        }
    }
}

enum EventCategory: String, Codable, CaseIterable {
    case conflict, statement, military, diplomatic
    case economic, terrorism, disaster, prediction, earthquake

    var icon: String {  // SF Symbol name
        switch self {
        case .conflict:   "flame.fill"
        case .statement:  "quote.bubble.fill"
        case .military:   "shield.fill"
        case .diplomatic: "flag.fill"
        case .economic:   "chart.line.uptrend.xyaxis"
        case .terrorism:  "exclamationmark.triangle.fill"
        case .disaster:   "tornado"
        case .prediction: "chart.pie.fill"
        case .earthquake: "waveform.path.ecg"
        }
    }
}

enum SourceTier: String, Codable {
    case `public`, `private`
}
```

### 2.2 Structs

```swift
struct Location: Codable {
    let lat: Double
    let lng: Double
    let name: String
    let country: String?
}

struct CrisisEvent: Codable, Identifiable {
    let id: String
    let title: String
    let summary: String
    let category: EventCategory
    let level: ThreatLevel
    let location: Location?
    let timestamp: String        // ISO 8601
    let source: String
    let sourceTier: SourceTier
    let url: String?
    let actor: String?
    let entities: [String]?
}

struct MarketIndicator: Codable, Identifiable {
    var id: String { symbol }
    let symbol: String
    let name: String
    let price: Double
    let change: Double
    let changePercent: Double
    let timestamp: String
}

struct PolymarketContract: Codable, Identifiable {
    let id: String
    let question: String
    let probability: Int         // 0-100
    let volume: Double
    let url: String?
}

struct ActorStatus: Codable, Identifiable {
    var id: String { name }
    let name: String
    let flag: String
    let role: String
    let lastStatement: String?
    let lastStatementTime: String?
    let eventCount: Int
}
```

### 2.3 API Response Wrapper

```swift
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: String?
}
```

- [ ] 建立所有 enum 和 struct
- [ ] 寫一個 unit test：用真實 API JSON 字串測試 decode (從瀏覽器 copy `/api/events` 回傳)
- [ ] 確認所有 optional field 正確處理 (location, url, actor, entities, lastStatement)

**驗收：** `JSONDecoder().decode(APIResponse<[CrisisEvent]>.self, from: data)` 通過，零 decode error。

---

## Task 3: APIClient — 網路層

**目標：** 統一的 async API client，支援 polling 和錯誤處理

### 3.1 Spec

```swift
actor APIClient {
    static let shared = APIClient()

    // 可設定 base URL (dev / prod)
    var baseURL: URL

    func fetchEvents(locale: String = "en") async throws -> [CrisisEvent]
    func fetchIndicators() async throws -> [MarketIndicator]
    func fetchMarkets() async throws -> [PolymarketContract]
    func fetchActors() async throws -> [ActorStatus]
}
```

### 3.2 需求

- [ ] Base URL 從 `Info.plist` 或 environment 讀取，預設 `http://localhost:3000`
- [ ] 統一 `fetch<T>` 泛型方法：
  - `URLSession.shared.data(for: request)`
  - Decode `APIResponse<T>`
  - 若 `success == false`，throw `APIError.serverError(message)`
  - 若 `data == nil`，throw `APIError.noData`
- [ ] Timeout: 15 秒
- [ ] 錯誤型別：

```swift
enum APIError: LocalizedError {
    case serverError(String)
    case noData
    case networkError(Error)

    var errorDescription: String? { ... }
}
```

- [ ] 不做 client 端 cache（依賴 server 的 Cache-Control header + URLSession 預設行為）

**驗收：** 在 simulator 連上 `npm run dev` 的本地 server，`await APIClient.shared.fetchEvents()` 回傳事件陣列。

---

## Task 4: ViewModels — 資料驅動層

**目標：** 三個 `@Observable` ViewModel，各自管理 polling 和狀態

### 4.1 EventsViewModel

```swift
@Observable
class EventsViewModel {
    var events: [CrisisEvent] = []
    var isLoading = false
    var error: String?

    // 篩選狀態
    var selectedRegion: Region = .all
    var selectedCategories: Set<EventCategory> = []
    var selectedLevels: Set<ThreatLevel> = []
    var searchText: String = ""

    // 選取狀態
    var selectedEventId: String?

    // 計算屬性
    var filteredEvents: [CrisisEvent] { ... }

    // Polling: 30 秒
    func startPolling() { ... }
    func stopPolling() { ... }
    func refresh() async { ... }
}
```

- [ ] `Region` enum: `all, middleEast, europe, eastAsia, africa, americas`
  - 每個 region 對應一組關鍵字 (複用 Web 版 `regions.ts` 邏輯)
- [ ] `filteredEvents` 依序套用：region → categories → levels → searchText
- [ ] Timer 每 30 秒自動 `refresh()`
- [ ] `startPolling()` 在 `onAppear` 呼叫，`stopPolling()` 在 `onDisappear`

### 4.2 MarketsViewModel

```swift
@Observable
class MarketsViewModel {
    var indicators: [MarketIndicator] = []
    var contracts: [PolymarketContract] = []
    var isLoading = false
    var error: String?

    // Polling: 5 分鐘
    func startPolling() { ... }
    func stopPolling() { ... }
}
```

- [ ] 同時 fetch indicators + markets (TaskGroup)
- [ ] 5 分鐘 polling

### 4.3 ActorsViewModel

```swift
@Observable
class ActorsViewModel {
    var actors: [ActorStatus] = []
    var isLoading = false
    var error: String?

    // Polling: 5 分鐘
    func startPolling() { ... }
    func stopPolling() { ... }
}
```

- [ ] 5 分鐘 polling

**驗收：** 在 SwiftUI Preview 中注入 ViewModel，確認 `events.count > 0`，篩選正確運作。

---

## Task 5: 色彩主題與共用元件

**目標：** 統一的深色主題 + 可複用 UI 元件

### 5.1 Color Theme

```swift
extension Color {
    static let bgPrimary    = Color(hex: "#0a0a0f")
    static let bgSecondary  = Color(hex: "#12121a")
    static let bgTertiary   = Color(hex: "#1a1a2e")
    static let border       = Color(hex: "#2a2a3e")
    static let textPrimary  = Color(hex: "#e8e8f0")
    static let textSecondary = Color(hex: "#9898b0")
    static let accentRed    = Color(hex: "#ef4444")
    static let accentOrange = Color(hex: "#f97316")
    static let accentYellow = Color(hex: "#eab308")
    static let accentBlue   = Color(hex: "#3b82f6")
    static let accentGreen  = Color(hex: "#22c55e")
}
```

- [ ] `Color(hex:)` init extension
- [ ] 與 Web 版 CSS custom properties 完全一致

### 5.2 共用元件

- [ ] `ThreatBadge(level:)` — 色點 + level 文字
- [ ] `CategoryIcon(category:)` — SF Symbol icon
- [ ] `RelativeTime(iso:)` — "3m ago", "2h ago" 顯示
- [ ] `SourceBadge(source:, tier:)` — 來源名稱 + private 鎖 icon
- [ ] `LiveIndicator()` — 綠色脈動圓點 (動畫)

**驗收：** 在 Preview 中渲染所有共用元件，色彩與 Web 版視覺一致。

---

## Task 6: 地圖頁 — Map Tab

**目標：** 全螢幕地圖，事件以標註點顯示，點擊彈出詳情

### 6.1 CrisisMapView

```swift
struct CrisisMapView: View {
    @State var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 32, longitude: 50),
            span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
        )
    )

    var body: some View {
        Map(position: $position) {
            ForEach(viewModel.filteredEvents.compactMap { $0.asAnnotation }) { event in
                Annotation(event.title, coordinate: event.coordinate) {
                    EventMarkerDot(level: event.level)
                }
            }
        }
        .mapStyle(.imagery(elevation: .realistic))  // 或 .standard
    }
}
```

- [ ] 初始視角：中東 (lat 32, lng 50, span 40°)
- [ ] 只顯示有 `location` 的事件
- [ ] Marker 大小和顏色依 `ThreatLevel`
- [ ] `.mapControlVisibility(.visible)` — 顯示指南針、比例尺
- [ ] 頂部覆蓋半透明 header bar：app 標題 + LiveIndicator + event count

### 6.2 EventMarkerDot

```swift
struct EventMarkerDot: View {
    let level: ThreatLevel

    var body: some View {
        Circle()
            .fill(level.color)
            .frame(width: level.markerSize, height: level.markerSize)
            .shadow(color: level.color.opacity(0.5), radius: 4)
    }
}
```

- [ ] Critical level 加上脈動動畫 (scaleEffect + opacity animation)
- [ ] Private source 事件右上角加 🔒

### 6.3 Event Detail Sheet

- [ ] 點擊 annotation → `selectedEventId` → `.sheet` 呈現
- [ ] Sheet 內容：
  - ThreatBadge + CategoryIcon + 相對時間
  - 標題 (bold, 17pt)
  - 摘要 (secondary color, 15pt)
  - 分隔線
  - 位置名稱 + MapPin icon
  - 來源 + SourceBadge
  - 若有 url → "Read Article" 按鈕 (Safari open)
- [ ] Sheet 高度：`.presentationDetents([.medium])`
- [ ] 點擊事件時，地圖 `position` 動畫移動到該座標

### 6.4 Map Filter Overlay

- [ ] 地圖左下角浮動按鈕 → 展開 filter popover
- [ ] 包含：Region picker, Level toggles, Category toggles
- [ ] 篩選變更即時反映在地圖 annotation 上

**驗收：** 地圖顯示所有有位置的事件，色彩正確，點擊彈出詳情，篩選即時生效。

---

## Task 7: 事件列表頁 — Feed Tab

**目標：** 可篩選、可搜尋的事件列表，點擊可跳轉地圖

### 7.1 EventListView

```swift
struct EventListView: View {
    var body: some View {
        NavigationStack {
            List(viewModel.filteredEvents) { event in
                EventRow(event: event)
                    .onTapGesture { selectAndFlyTo(event) }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText, prompt: "Search events...")
            .refreshable { await viewModel.refresh() }
            .navigationTitle("Events")
            .toolbar { FilterBar(...) }
        }
    }
}
```

- [ ] `.searchable` 搜尋欄
- [ ] `.refreshable` 下拉更新
- [ ] 列表背景色 `bgPrimary`

### 7.2 EventRow

```swift
// Layout:
// ┌─────────────────────────────────┐
// │ 🔴 ⚔️ conflict        3m ago   │
// │ Title text bold here            │
// │ Summary text secondary 2 lines  │
// │ 📍 Tehran, Iran  ·  Reuters     │
// └─────────────────────────────────┘
```

- [ ] 左側 ThreatBadge 色點
- [ ] CategoryIcon + category 文字
- [ ] RelativeTime 靠右
- [ ] Title: bold, `.textPrimary`
- [ ] Summary: `.textSecondary`, 2 行 `.lineLimit(2)`
- [ ] Footer: MapPin + location name + source + SourceBadge
- [ ] 點擊 → 切換到 Map tab + flyTo 該座標

### 7.3 FilterBar (toolbar)

- [ ] `Menu` 按鈕展開篩選選項
- [ ] Region picker (dropdown)
- [ ] Category multi-select
- [ ] Level multi-select
- [ ] 已啟用篩選時，toolbar 按鈕顯示 badge 數字

### 7.4 TimelineView (optional, 可與 Feed 共用 tab)

- [ ] `Section` 按小時分組
- [ ] Section header: "14:00 - 15:00" 格式
- [ ] 精簡版 EventRow (只顯示 level dot + title + time)

**驗收：** 事件列表顯示、篩選、搜尋、下拉更新皆正常。點擊事件可跳轉地圖。

---

## Task 8: 儀表板 — Dashboard Tab

**目標：** 資訊化圖表顯示，一眼掌握全局態勢

### 8.1 DashboardView Layout

```
// ScrollView:
// ┌──────────────────────────────┐
// │  Threat Overview (bar chart) │
// ├──────────────────────────────┤
// │  Categories (pie chart)      │
// ├──────────────────────────────┤
// │  Market Indicators (cards)   │
// ├──────────────────────────────┤
// │  Prediction Markets (bars)   │
// ├──────────────────────────────┤
// │  Key Actors (list)           │
// └──────────────────────────────┘
```

- [ ] `ScrollView` 包裹所有卡片
- [ ] 每個區塊用 `.bgSecondary` 圓角卡片包裝
- [ ] 卡片間距 12pt

### 8.2 ThreatOverviewCard

```swift
Chart(threatCounts, id: \.level) { item in
    BarMark(
        x: .value("Level", item.level.rawValue),
        y: .value("Count", item.count)
    )
    .foregroundStyle(item.level.color)
}
```

- [ ] 統計各 threat level 事件數量
- [ ] 水平 BarMark，顏色對應 level
- [ ] 頂部顯示 total event count 大數字
- [ ] 卡片標題: "Threat Overview"

### 8.3 CategoryBreakdownCard

```swift
Chart(categoryCounts, id: \.category) { item in
    SectorMark(angle: .value("Count", item.count))
        .foregroundStyle(by: .value("Category", item.category.rawValue))
}
```

- [ ] SectorMark 圓餅圖
- [ ] Legend 在右側顯示各 category 名稱 + 數量
- [ ] 卡片標題: "Event Categories"

### 8.4 MarketIndicatorsCard

```swift
// 橫向 ScrollView，每個 indicator 一張小卡
// ┌──────────┐ ┌──────────┐ ┌──────────┐
// │ WTI Oil  │ │ Gold     │ │ BTC      │
// │ $72.45   │ │ $2,341   │ │ $64,200  │
// │ ▲ +1.2%  │ │ ▼ -0.3%  │ │ ▲ +2.1%  │
// └──────────┘ └──────────┘ └──────────┘
```

- [ ] 橫向 ScrollView，每張卡片固定寬 140pt
- [ ] 漲 = green + "▲"，跌 = red + "▼"
- [ ] price 用 `NumberFormatter` 格式化 (currency style)
- [ ] 卡片標題: "Market Indicators"

### 8.5 PolymarketCard

```swift
Chart(contracts.prefix(10), id: \.id) { contract in
    BarMark(
        x: .value("Probability", contract.probability),
        y: .value("Question", contract.question)
    )
    .foregroundStyle(probabilityColor(contract.probability))
}
```

- [ ] 水平 BarMark，y 軸 = question (truncated), x 軸 = probability %
- [ ] 顏色：>70% 紅, >40% 黃, ≤40% 綠
- [ ] 點擊某個 bar → 開啟 Polymarket URL
- [ ] 卡片標題: "Prediction Markets"

### 8.6 KeyActorsCard

- [ ] 垂直列表，每個 actor 一行
- [ ] Flag emoji + name (bold) + role (secondary)
- [ ] 右側：eventCount badge
- [ ] 若有 lastStatement → 下方引述文字 + 相對時間
- [ ] 卡片標題: "Key Actors"

**驗收：** Dashboard 顯示 5 個圖表卡片，資料正確，圖表可互動。

---

## Task 9: i18n — 雙語支援

**目標：** 支援 English 和繁體中文，與 Web 版一致

- [ ] `Localizable.xcstrings` 加入 `en` 和 `zh-Hant-TW` 兩組翻譯
- [ ] 翻譯內容複用 Web 版 `src/lib/i18n.ts` 的 `zhTW` object
- [ ] API call 帶 `?locale=zh-TW` 取得 server 翻譯後的事件 title/summary
- [ ] 系統設定跟隨裝置語系自動切換
- [ ] 時間格式化：en 用 UTC，zh-TW 用 Asia/Taipei (與 Web 版一致)

**驗收：** 切換裝置語系，所有 UI 文字和事件內容正確切換。

---

## Task 10: 離線與本地快取

**目標：** 無網路時仍可瀏覽上次抓取的資料

### 10.1 SwiftData Model

```swift
@Model
class CachedEvent {
    @Attribute(.unique) var id: String
    var json: Data          // 存原始 JSON
    var fetchedAt: Date
}

@Model
class CachedIndicator { ... }
```

- [ ] `ModelContainer` 在 App entry 初始化
- [ ] 每次 API 成功後，寫入 SwiftData
- [ ] API 失敗時，從 SwiftData 讀取
- [ ] 超過 24 小時的快取自動清除
- [ ] UI 顯示「離線模式 - 資料更新於 X 分鐘前」banner

**驗收：** 開飛航模式，app 仍顯示上次的資料，有離線提示。

---

## Task 11: 推播通知

**目標：** Critical / High 事件即時推播

- [ ] App 啟動時向 APNs 註冊，取得 device token
- [ ] **Server 端新增** `POST /api/register-device` endpoint (存 token)
- [ ] **Server 端新增** aggregator hook：新事件為 critical/high 時，呼叫 APNs
  - 可複用現有 Telegram notification 邏輯的觸發條件
- [ ] 推播內容：title + 前 50 字 summary + category icon
- [ ] 點擊推播 → 開啟 app → 跳轉到該事件地圖位置
- [ ] 設定頁面：可選擇接收哪些 level 的通知

**驗收：** 新的 critical 事件出現後 60 秒內收到推播，點擊可定位。

---

## Task 12: Widget (WidgetKit)

**目標：** 主畫面和鎖定畫面快速查看態勢

### 12.1 Small Widget (systemSmall)

```
┌──────────────┐
│ ⊕ CrisisMap  │
│              │
│ 🔴 3 Critical │
│ 🟠 7 High     │
│ 12 total     │
└──────────────┘
```

### 12.2 Medium Widget (systemMedium)

```
┌──────────────────────────────┐
│ ⊕ CrisisMap          Live 🟢│
│ 🔴 Airstrike hits...   3m   │
│ 🟠 Iran warns of...    15m  │
│ 🟡 Oil prices surge    1h   │
│ WTI $72 ▲1.2%  Gold $2341   │
└──────────────────────────────┘
```

### 12.3 Lock Screen Widget (accessoryCircular)

```
🔴 3    ← critical event count
```

- [ ] Widget Extension target
- [ ] `TimelineProvider`: 每 15 分鐘 fetch `/api/events`
- [ ] Small: threat level 統計
- [ ] Medium: 前 3 事件 + market strip
- [ ] Lock Screen: critical count
- [ ] 點擊 widget → deep link 到 app 對應頁面

**驗收：** 三種尺寸 widget 正確顯示，15 分鐘自動更新。

---

## Task 13: App Store 上架

- [ ] Apple Developer Program 帳號 ($99/year)
- [ ] App Store Connect 建立 app record
- [ ] 截圖準備：
  - iPhone 6.7" (15 Pro Max): 地圖頁、事件列表、儀表板
  - iPhone 6.1" (15 Pro): 同上
  - iPad 12.9" (if 支援): 同上
- [ ] App 描述 (en + zh-TW)
- [ ] 隱私政策 URL (只收集 device token for push)
- [ ] Category: News / Reference
- [ ] Age Rating: 17+ (戰爭/衝突內容)
- [ ] Archive & Upload via Xcode
- [ ] App Review 提交

**驗收：** App Store 審核通過，可供下載。

---

## 執行順序與依賴關係

```
Task 1 (專案初始化)
  └→ Task 2 (Models)
       └→ Task 3 (APIClient)
            └→ Task 4 (ViewModels)
                 ├→ Task 5 (主題 + 共用元件)
                 ├→ Task 6 (地圖頁)      ← 可與 7, 8 並行
                 ├→ Task 7 (事件列表頁)   ← 可與 6, 8 並行
                 └→ Task 8 (儀表板頁)     ← 可與 6, 7 並行
                      └→ Task 9 (i18n)

─── MVP 分界線 (Task 1-9 完成即可用) ───

Task 10 (離線快取)   ← 獨立
Task 11 (推播通知)   ← 需 server 端配合
Task 12 (Widget)    ← 依賴 Task 3
Task 13 (上架)      ← 最後
```

**MVP (Task 1–9)：約 2 週**
**完整版 (Task 1–13)：約 4 週**

---

## Task 14: Research Tab — 智庫研究瀏覽（按區域 + 主題）

> **設計文件：** `docs/superpowers/specs/2026-03-11-research-tab-design.md`
> **實作計畫：** `docs/superpowers/plans/2026-03-11-research-tab.md`

**目標：** 新增第四個 Tab "Research"，從 Cloudflare 靜態 JSON 抓取智庫週報文章，以 區域 → 主題 → 文章列表 三層導航呈現，SwiftData 離線快取。

### 14.1 資料模型

- [ ] 建立 `ThinkTankArticle.swift` — `ThinkTankArticle`, `ThinkTankWeekly`, `WeekIndex`, `WeekEntry` Codable structs
- [ ] 建立 `CachedWeekly.swift` — SwiftData `@Model`，存原始 JSON + uploaded 時間戳
- [ ] 擴展 `Region.swift` — 新增 `researchCategories`, `researchTopics`, `matchesArticle(_:)` 方法

### 14.2 網路層

- [ ] 擴展 `APIClient.swift` — 新增 `fetchWeekIndex()`, `fetchWeekly(week:)` 方法
- [ ] Think tank JSON 為 raw JSON（非 `APIResponse` 包裝），需新增 `fetchRaw<T>` 泛型方法
- [ ] Base URL: `https://thinktankbriefdata.strataperture.net/2026`

### 14.3 ViewModel

- [ ] 建立 `ResearchViewModel.swift` — `@Observable`，管理抓取、增量快取、篩選
  - `regionsWithCounts` — 各區域文章數
  - `topicsForRegion` — 當前區域的 topics + 文章數
  - `articlesFor(region:topic:)` — 最終篩選結果
  - `loadData()` — 增量抓取 + SwiftData 快取邏輯
  - 離線 fallback：網路失敗時從 SwiftData 讀取

### 14.4 Views

- [ ] 建立 `ArticleRow.swift` — 文章列表行（智庫名 + category + 日期 + 標題 + 摘要 + topics 標籤）
- [ ] 建立 `ArticleListView.swift` — 依 region + topic 篩選的文章列表，點擊開 Safari
- [ ] 建立 `TopicListView.swift` — 區域內的 topics 列表（含文章數）
- [ ] 建立 `ResearchView.swift` — NavigationStack 根視圖，區域列表 + 離線提示 + 下拉更新

### 14.5 整合

- [ ] 修改 `CrisisMapApp.swift` — 加入 `ResearchViewModel`、SwiftData `ModelContainer`
- [ ] 修改 `ContentView.swift` — 新增第四個 Tab（icon: `book.fill`, label: "Research"）
- [ ] 更新 `Localizable.xcstrings` — 新增 `tab.research`, `research.title`, `research.allTopics`, `research.error`, `research.retry`, `research.offline`

### 14.6 文件

- [ ] 撰寫 `README.md` — 專案概述、功能說明、架構、設定指南

**資料來源：**
- 索引: `GET https://thinktankbriefdata.strataperture.net/2026/weeks.json`
- 週報: `GET https://thinktankbriefdata.strataperture.net/2026/2026-W10.json`

**區域 → Topics/Categories 映射：**

| 區域 | Categories | Topics |
|------|-----------|--------|
| 東亞 | china_indopacific | China, Taiwan, Indo-Pacific |
| 中東 | middle_east | Middle East |
| 歐洲 | europe | Europe, Russia, Ukraine, NATO |
| 非洲 | africa | — |
| 美洲 | americas | United States |

**驗收：** Research tab 顯示區域列表 → 點入可見該區域 topics → 點入可見文章列表 → 點擊開啟原文。離線時從快取載入，顯示離線提示。
