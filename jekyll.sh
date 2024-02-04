if [[ $1 == "-h" ]]; then
        echo "
        命令行参数如下:
        -b      执行编译指令
        -s      启动jekyll的本地服务
        -git    同步代码到git远端仓库"
fi


if [[ $1 == "-b" ]]; then
bundle exec jekyll build
fi

if [[ $1 == "-s" ]]; then
bundle exec jekyll serve
fi


if [[ $2 == "git" ]]; then
git add .
read -p '请输入git提交说明: ' msg
case $input in
        [yY]*)
                git commit -m "$msg"
                ;;
        [nN]*)
                exit
                ;;
        *)
                echo "Just enter y or n, please."
                exit
                ;;
esac
fi

git pull

git push
