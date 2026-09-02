# 五步开始：定位哪一层出了问题

[返回首页](../README.md) · [开发者指南](DEVELOPER_GUIDE.md)

![请求经过客户端、Gateway、节点或通道，再到实际结果](media/workflow.svg)

## 1 · 先理解四层

客户端负责发请求；Gateway 负责接收和路由；节点执行或通道发送；最后才是用户看见的结果。前一层成功，不代表后一层一定成功。

## 2 · 先试离线工具

需要 Windows PowerShell 5.1 或 PowerShell 7。在下载的仓库目录打开终端：

```powershell
./scripts/collect_openclaw_diagnostics.ps1 -SelfTest
./scripts/collect_openclaw_diagnostics.ps1 -InputPath examples/synthetic-diagnostic.txt -OutputPath openclaw-diagnostics-demo.txt
```

自检显示 PASS 后，会生成一个新文本。它不是原始日志，不会自动上传。查看 [预期输出](../examples/expected-sanitized.txt) 对照即可。

文件已存在时工具会拒绝覆盖，换个输出文件名。不建议为了运行脚本而全局降低执行策略。

## 3 · 再选择故障入口

[初步检查表](../references/triage.md) 帮你决定是否需要运行某个命令。工具本身不会启动 OpenClaw、读取配置、修复系统或改变权限。

可选人工检查的输出仍可能含隐私。只选短片段，在本地脱敏后逐行复核。

## 4 · 写出有用的结论

> 已确认：Gateway 可达、轻量能力返回。
>
> 未确认：进程是否最终完成。
>
> 下一步：查看同一次请求的最终结果，先不重复执行。

这是教学示例，不是你当前设备的诊断结果。

## 5 · 安装技能并反馈

先读 [SKILL.md](../SKILL.md)，按首页安装。然后把脱敏后的短案例交给 Agent，要求先定位边界、不修改系统。

Issues 中选择 Reproducible problem 或 Beginner feedback。只写系统类别、版本、最小步骤和结果；不提交账号、密钥、完整日志或原始配置。

[工具说明](../examples/README.md) · [验证边界](VERIFICATION.md)
