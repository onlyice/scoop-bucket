# 一键上传至腾讯云 COS

v0.1

Windows 上一键上传文件到 COS。

## 效果

在文件管理器中上传文件至 COS：

![](https://raw.githubusercontent.com/onlyice/scoop-bucket/master/assets/cosupload/demo-1.gif)

在 IDE 中上传文件至 COS：

![](https://raw.githubusercontent.com/onlyice/scoop-bucket/master/assets/cosupload/demo-2.gif)

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

安装完成后，在命令行中会多了两个命令，分别是 `coscmd` 及 `cosupload`。`cosupload` 是 PowerShell 写的脚本，本质上是调用 `coscmd` 做操作。

## 使用

第一次使用 `cosupload` 前，需要先参考 [这里][coscmd-config] 设置 COS 所使用的参数配置，如：

```shell
coscmd config -r ap-guangzhou -a <ak> -s <sk> -b <bucket>
```

配置文件默认会放在 `~\.cos.conf` 作为全局配置。如果你在一些场景想用单独的配置，可以使用 `-c` 参数指定配置文件位置：

```shell
coscmd -c some-other-dir\.cos.conf config -r ap-guangzhou -a <ak> -s <sk> -b <bucket>
```

cosupload 运行时会从被上传文件所在目录起，一级级往上找 `.cos.conf` 文件，作为上传所使用的配置文件。

配置好后，就可以在文件管理器中右键，选择 "Upload to COS" 了。上传完后会自动设置一个 `wget` 命令行在剪贴板中。

### 命令行使用

```shell
cosupload <file-to-upload> <key-in-bucket>
```

如：

```shell
cosupload my-file.txt another-name-in-bucket.txt
```

会把 `my-file.txt` 上传到 bucket 中的 `another-name-in-bucket.txt` 位置。

### IDE 中使用

IDE 大多数提供了使用外部工具的能力。比如 JetBrains 系的 External Tools 功能，可以用这种方式配置：

![](https://raw.githubusercontent.com/onlyice/scoop-bucket/master/assets/cosupload/jetbrains-ide-config.png)

[coscmd]: https://github.com/tencentyun/coscmd
[python-download]: https://www.python.org/downloads/
[scoop]: https://scoop.sh
[coscmd-config]: https://github.com/tencentyun/coscmd#%E9%85%8D%E7%BD%AE%E5%8F%82%E6%95%B0
