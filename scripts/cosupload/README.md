# 一键上传至腾讯云 COS

v0.1

Windows 上一键上传文件到 COS。

## 效果

TODO:

* 在 Windows 资源管理器中上传 Gif
* 在 IDE 中上传 Gif

## 快速开始

如果你访问网络需要走代理（比如在公司环境中），先设置好 `http_proxy` 及 `https_proxy` 环境变量。

这个工具使用 [Scoop][scoop] 简化安装，Scoop 要求 PowerShell 3.0 才可使用:

* 如果你是 Windows 7 系统，系统自带的是 2.0 版本，你需要安装新版本的 PowerShell（建议 5.x 版本）；你可以打开一个 PowerShell 窗口，输入 `$PSVersionTable` 观察是什么版本
* 如果你是 Windows 10 系统，系统已经自带了高版本 PowerShell，不需要做额外操作

确保 PowerShell 满足要求后，打开一个新的 PowerShell 窗口，执行：

```powershell
# 允许运行远程脚本
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
# 安装 Scoop
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
# 添加 cosupload 所在的 bucket
scoop bucket add onlyice https://github.com/onlyice/scoop-bucket.git
# 安装 cosupload
scoop install cosupload
```

安装过程会自动安装 Python 3，并使用 pip 去安装 COS 的命令行工具 [coscmd][]。如果 pip 的过程有失败，请先运行 `scoop uninstall cosupload`，再运行 `scoop install cosupload` 重新安装。

安装完成后，按屏幕提示进到 `C:\Users\<username>\scoop\apps\cosupload\current` 中双击运行 `cosupload-install-context.reg`，以将 "Upload to COS" 加入到资源管理器右键菜单中。如果后面你不需要这个右键菜单项了，你可以运行 `cosupload-uninstall-context.reg`。

## 使用

[coscmd]: https://github.com/tencentyun/coscmd
[python-download]: https://www.python.org/downloads/
[scoop]: https://scoop.sh
