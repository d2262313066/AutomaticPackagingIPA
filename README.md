# AutomaticPackagingIPA
由于每次打包都十分麻烦，故写了一个自动打包的脚本
此脚本不需要手动获取大量证书的信息，只需要将文件夹名称，bundleID填写好，将provisionProfile放入指定文件夹就可以

使用前准备：
文件夹名称
BundleID
provisionProfile

1.利用终端cd进入需要打包的文件夹
2.使用./AutoArchive.sh
3.结束等待出包


可能会出现的问题
工程包文件内Sign不要设置任何证书，否则会导致打包失败
如果已经设置了，点击 Automatically manage signing两次，则会取消设置过的证书


