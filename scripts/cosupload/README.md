# 一键上传至腾讯云 COS

v1.0

Windows 上一键上传文件到 COS。

## 效果

TODO:

* 在 Windows 资源管理器中上传 Gif
* 在 IDE 中上传 Gif

## 安装

这个工具基于腾讯云 COS 团队提供的命令行工具 [coscmd][] 封装而成。coscmd 是使用 Python 编写的。因此需要先安装 Python 3（Python 2.7 不受支持，因为我不想写额外的代码去兼容它）。

下载 Python [安装包][python-download] 并运行它，安装过程中需要把「Add Python 3.x to Path」勾选上。安装完后，打开一个 **新的** 命令行窗口（Cmd、PowerShell 均可），输入 `pip` 并回车。如果找不到该命令，可能是环境变量还没生效，重启系统。

pip 是 Python 包管理器，我们要通过 pip 拿到 coscmd。如果你的网络环境需要代理才能访问外网，先设置好 `http_proxy` 和 `https_proxy` 环境变量。打开一个命令行窗口，输入这行命令安装 coscmd：

```shell
pip install -U coscmd
```

如果没有报错，那么在命令行中输入 `coscmd --help` 命令，观察是否安装成功。

## 使用

[coscmd]: https://github.com/tencentyun/coscmd
[python-download]: https://www.python.org/downloads/
