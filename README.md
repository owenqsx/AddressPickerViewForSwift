
### 省市区地址选择器

fork By Jonhory
[原作者传送门](https://github.com/Jonhory/AddressPickerView)

更新数据源为China-area-data的数据源
增加直接通过RegionID返显的地区的功能

![效果图](https://ws1.sinaimg.cn/large/c6a1cfeagy1fts792k4hkj20ae0il0ta.jpg)

[OC版本传送门](https://github.com/Jonhory/AddressPickerView)

## 注意 

* /// 是否自动显示上次的结果，默认是
* 
`var isAutoOpenLast: Bool = true`

## 使用

* 初始化

`var picker: AddressPickerView?`

```
picker = AddressPickerView.addTo(superView: view)
picker?.delegate = self
```

* 展示

`picker?.show()`

* 隐藏

`picker?.hide()`

* 选择地区
`picker?.selectRow(regionId: Int)`