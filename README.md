# 山人输入方案

本方案设计主要参考（抄袭）[Ace-Who/rime-xuma: 徐码／爾雅](https://github.com/Ace-Who/rime-xuma)方案，码表和词库来自于疏影孤桐版。

- 三重注解：字根拆分 + 全息码 + 拼音。可以通过选项切换\[〇重注解\]、\[一重注解\]、\[二重注解\]、\[三重注解\]
- 字集切换：`规范`（通用规范汉字表，默认）、`BIG5`、`GBK`、`UTF8`
- 繁入简出
- 简入繁出
- PUA设置：默认只显示基本的PUA字符（常见部件和有读音字符，即GBK&PUA），可以通过选项切换
- 全码后置：简码单字排序靠前，全码重码时降低排序，让位于无简码字词。默认开启

## Tips

- 反查：拼音+五笔画，按`` ` ``反查，`` `P ``拼音，`` `B ``五笔画
- 手动造词（按`` ` ``分割，*每个字最少两码*。），词组编码每字取两码。按`Ctrl + Delete`或`Shift+Delete`（Mac OS 用 `Shift + Fn + Delete`）删除选中的用户自造词。
- 内置词典位置固定，自造词动态调频
- 精确匹配时，单字在前，词组在后（例外：二简、三简词组在生僻字之前）
- `sunman.extended.dict.yaml` 中可自定义词组，更新方案时记得手动保存
- 使用`/XX`输入符号

## 码表修改

- 一简

| 编码 | 修改前 | 修改后 |
| ---- | ------ | ------ |
| o    | 口     | 中     |

- 二简

| 编码 | 修改前   | 修改后   |
| ---- | -------- | -------- |
| ad   | 罗 將 鬥 | 将 將 鬥 |
| an   | 要       | 安 要    |
| ti   | 士       | 士 地方  |

- 三简

| 编码 | 修改前 | 修改后   |
| ---- | ------ | -------- |
| lle  | 辽 頻  | 频 辽 頻 |
| tyi  | 邑     | 邑 地方  |

- 错码

  修正一些错码

## 使用方案

复制所有文件到用户文件夹下。

**注：如果你已经有`rime.lua`文件，不要直接替换，而是将本方案的`rime.lua`追加到你的`rime.lua`中。**

