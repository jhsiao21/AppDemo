# KOKO Demo

## 說明
* 此為[國泰iOS面試考題](https://app.zeplin.io/project/5c498614493bf5bf68258c5a/screen/5d776380061b64a13531f133)，demo實作好友頁面



## 操作說明
* 將程式Clone下來後直接開啟Cathaybk_iOS_interview.xcodeproj，直接案Run或Cmd⌘+R執行
* 在底下標籤列點選"朋友"會看到以下畫面：

![](images/FriendVC-portrait.png)

## 實作內容
- [x] 以Swift／MVVM架構開發

- [x] 實作⾴⾯三種狀態：

1. 無好友時畫⾯

![](images/1-1-portrait.png)


2. 有好友且無邀請資料時畫⾯

![](images/1-2-portrait.png)


3. 有好友且有邀請時畫⾯

![](images/1-3-portrait.png)
-

### 加分項目
* 好友列表⽀援下拉更新(重新呼叫request)

![](images/scroll_down_to_refresh.mov)
-

* 搜尋功能

![](images/search.mov)
-

* 邀請列表，可以點選打勾或打叉來回應邀請，選擇後"邀請中"狀態會消失

![](images/invite_interaction.mov)

## 其他
* 測試環境：
    - [x] Xcode 14.0.1
    - [x] Xcode 15.0.1
* 開發工具：
    * Xcode 15.0.1
    * Postman