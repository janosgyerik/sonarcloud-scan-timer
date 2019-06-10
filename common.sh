recipes_basedir=recipes
sonarcloud_token_path=$recipes_basedir/sonarcloud-token.txt
work_basedir=work
report_filename=report.txt

fatal() {
    echo "fatal: $@"
    exit 1
}

msg() {
    echo "* $@"
}
