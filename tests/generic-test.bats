## Generic bats tests

#
# Variable initialization
#
source /etc/proxysql-admin.cnf
PXC_BASEDIR=$WORKDIR/pxc-bin
PROXYSQL_BASEDIR=$WORKDIR/proxysql-bin

@test "run proxysql-admin under root privileges" {
    if [[ $(id -u) -ne 0 ]] ; then
        skip "Skipping this test, because you are NOT running under root"
    fi
    run $WORKDIR/proxysql-admin
    echo "$output" >&2
    [ "$status" -eq  1 ]
    [ "${lines[0]}" = "Usage: proxysql-admin [ options ]" ]
}

@test "run proxysql-admin without any arguments" {
    run sudo $WORKDIR/proxysql-admin
    echo "$output" >&2
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "Usage: proxysql-admin [ options ]" ]
}

@test "run proxysql-admin --help" {
    run sudo $WORKDIR/proxysql-admin --help
    echo "$output" >&2
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Usage: proxysql-admin [ options ]" ]
}

@test "run proxysql-admin with wrong option" {
    run sudo $WORKDIR/proxysql-admin test
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --config-file without parameters" {
    run sudo $WORKDIR/proxysql-admin --config-file
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin check default configuration file" {
    run ls /etc/proxysql-admin.cnf 
    echo "$output" >&2
    [ "$status" -eq 0 ]
	[ "${lines[0]}" == "/etc/proxysql-admin.cnf" ]
}

@test "run proxysql-admin --proxysql-username without parameters" {
    run sudo $WORKDIR/proxysql-admin --proxysql-username
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --proxysql-port without parameters" {
    run sudo $WORKDIR/proxysql-admin --proxysql-port
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --proxysql-hostname without parameters" {
    run sudo $WORKDIR/proxysql-admin --proxysql-hostname
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --cluster-username without parameters" {
    run sudo $WORKDIR/proxysql-admin --cluster-username
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --cluster-port without parameters" {
    run sudo $WORKDIR/proxysql-admin --cluster-port
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --cluster-hostname without parameters" {
    run sudo $WORKDIR/proxysql-admin --cluster-hostname
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --cluster-app-username without parameters" {
    run sudo $WORKDIR/proxysql-admin --cluster-app-username
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --monitor-username without parameters" {
    run sudo $WORKDIR/proxysql-admin --monitor-username
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --mode without parameters" {
    run sudo $WORKDIR/proxysql-admin --mode
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --mode check wrong option" {
    run sudo $WORKDIR/proxysql-admin --mode=foo
    echo "$output" >&2
    [ "$status" -eq 1 ]
	[ "${lines[0]}" == "ERROR : Invalid --mode passed: 'foo'" ]
}

@test "run proxysql-admin --write-node without parameters" {
    run sudo $WORKDIR/proxysql-admin --write-node
    echo "$output" >&2
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" =~ .*--write-node.* ]]
}

@test "run proxysql-admin --write-node with missing port" {
    run sudo $WORKDIR/proxysql-admin --write-node=1.1.1.1,2.2.2.2:44 --disable
    echo "$output" >&2
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" =~ ERROR.*--write-node.*expects.* ]]

    run sudo $WORKDIR/proxysql-admin --write-node=[1:1:1:1],[2:2:2:2]:44 --disable
    echo "$output" >&2
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" =~ ERROR.*--write-node.*expects.* ]]
}

@test "run proxysql-admin --server without parameters" {
    run sudo $WORKDIR/proxysql-admin --server
    echo "$output" >&2
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" =~ .*--server.* ]]
}

@test "run proxysql-admin --server with missing port" {
    run sudo $WORKDIR/proxysql-admin --server=1.1.1.1 --syncusers
    echo "$output" >&2
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" =~ ERROR.*--server.*expected.* ]]

    run sudo $WORKDIR/proxysql-admin --server=[1:1:1:1] --syncusers
    echo "$output" >&2
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" =~ ERROR.*--server.*expected.* ]]
}

@test "run proxysql-admin --server with unsupported commands" {
    run sudo $WORKDIR/proxysql-admin --server=1.1.1.1 --disable
    echo "$output" >&2
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" =~ ERROR.*--server.*can.only.be.used.* ]]

    run sudo $WORKDIR/proxysql-admin --server=[1:1:1:1] --update-cluster
    echo "$output" >&2
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" =~ ERROR.*--server.*can.only.be.used.* ]]
}

@test 'run proxysql-admin --max-connections without parameters' {
    run sudo $WORKDIR/proxysql-admin --max-connections
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test 'run proxysql-admin --max-connections without parameters' {
    run sudo $WORKDIR/proxysql-admin --max-connections=
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test 'run proxysql-admin --max-connections with non-number parameter' {
    run sudo $WORKDIR/proxysql-admin --max-connections=abc
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test 'run proxysql-admin --max-connections with negative values' {
    run sudo $WORKDIR/proxysql-admin --max-connections=-1
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test 'run proxysql-admin --login-file with nonexistent file' {
    run sudo $WORKDIR/proxysql-admin --login-file=dummy.file.should.not.exist.cnf
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test 'run proxysql-admin --login-file with nonexistent --login-password-file' {
    run sudo $WORKDIR/proxysql-admin --login-file=login-file.cnf --login-password-file=dummy.file.should.not.exist.cnf
    echo "$output" >&2
    [ "$status" -eq 1 ]
}

@test "run proxysql-admin --version check" {
    admin_version=$(sudo $WORKDIR/proxysql-admin -v | grep --extended-regexp -oe '[1-9]\.[0-9]\.[0-9]+')
    proxysql_version=$(sudo $PROXYSQL_BASEDIR/usr/bin/proxysql --help | grep --extended-regexp -oe '[1-9]\.[0-9]\.[0-9]+')
    echo "proxysql_version:$proxysql_version  admin_version:$admin_version" >&2
    [ "${proxysql_version}" = "${admin_version}" ]
}
