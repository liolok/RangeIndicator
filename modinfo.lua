name = "Crystaleyezer/Furnace/Mushlight/Brightshade Range/Ice Flingomatic"
description = [[
1.Click the following Entities to activate the range indicator.Reclick them to cancel the range instantly, press H to cancel all range indicators, or press G to stop the range indicators from working.
You can modify the key in modinfo.(ASCII code)
Scaled Furnace:Red
Ice Crystaleyezer:Blue
Mushlight:Cyan
BrightShade Aggro range:Yellow
BrightShade Parasite Immune range:Green
Houndius Shootius:Pink
Lighting Rod:Yellow
Ice Flingomatic:White

This mod is mainly used for making constant temperature base.
When Ice Crystaleyezer and Scaled Furnace range overlap, the temperature will keep between 1-69.

2.Indicate range while building furnace and mushlight.

Code refer to WorkShopID:2575190872
Code Original Author:冰汽
Code Optimization:adai1198 (TW)Eric
-----------------------------------

1、點選下列物件會顯示其所涵蓋的範圍。再次點擊取消範圍，按下H取消全部範圍或者按下G暫停顯示範圍。
可以在modinfo修改你要的按鍵(使用ASCII碼)

龍鱗爐:紅色
冰眼塔:藍色
蘑菇燈:青色
亮茄仇恨範圍:黃色
亮茄不寄生範圍:綠色
眼球塔:粉紅色
避雷針:黃色
雪球發射機:白色

2、建造龍林爐、蘑菇燈時顯示範圍

第二部分程式碼由友人adai1198編寫

本mod主要用於建造恆溫住所，二者互相覆蓋到的範圍會無視季節維持恆溫


此Mod程式碼參照工作坊ID:2575190872
程式碼來源:冰汽
程式碼優化:adai1198 (TW)Eric
-----------------------------------
]]

configuration_options =
{
    {
        name = "key_toggle",
        label = "Stop Toggle Range Key",
        options =   {
                        --{description = "<you want the key name>", data = <you want the key ASCII code>}
                        {description = "F5", data = 286}, -- ASCII code for 'g'
                        {description = "B", data = 98}, -- ASCII code for 'b'
                        -- Add more keys as needed
                    },
        --default = <you want the key ASCII code>,
        default = 286,
    },
    {
        name = "key_clear",
        label = "Clear Tagged Range Key",
        options =   {
                        {description = "H", data = 104}, -- ASCII code for 'h'
                        {description = "N", data = 110}, -- ASCII code for 'n'
                        -- Add more keys as needed
                    },
        default = 104,
    },
}

author = "TakaoInari, adai1198, (TW)Eric"
version = "0.1.0"
forumthread = "/"
api_version = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"
all_clients_require_mod = false
client_only_mod = true
dst_compatible = true
