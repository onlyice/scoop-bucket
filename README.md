# Scoop Bucket

这是一个 [scoop][] bucket，用来放一些我日常使用的包。

## 更新包 JSON 文件到新版本

在 PowerShell 中运行：

```cmd
cd ~/scoop/apps/scoop/current/bin
.\checkver.ps1 -dir <path-to-my-bucket> * -u
git commit -m "Updated apps"
git push
```

参考 [Scoop Wiki][scoop-autoupdate-wiki]。

[scoop]: https://github.com/lukesampson/scoop
[scoop-autoupdate-wiki]: https://github.com/lukesampson/scoop/wiki/App-Manifest-Autoupdate


