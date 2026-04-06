Option Explicit

Dim shell, env, codePath

Set shell = CreateObject("WScript.Shell")
Set env = shell.Environment("PROCESS")

env("HTTP_PROXY")  = "http://127.0.0.1:2048"
env("HTTPS_PROXY") = "http://127.0.0.1:2048"
env("ALL_PROXY")   = "http://127.0.0.1:2048"
env("http_proxy")  = "http://127.0.0.1:2048"
env("https_proxy") = "http://127.0.0.1:2048"
env("all_proxy")   = "http://127.0.0.1:2048"
env("NO_PROXY")    = "127.0.0.1,localhost"
env("no_proxy")    = "127.0.0.1,localhost"

codePath = "D:\Microsoft VS Code\Code.exe"
shell.CurrentDirectory = "D:\Microsoft VS Code"
shell.Run """" & codePath & """", 0, False
