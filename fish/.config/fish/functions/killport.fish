# killport <port> — free a TCP port by killing the process holding it.
#
# fish autoloads functions/<name>.fish on demand, so one function per file.
function killport --description "Kill the process listening on a TCP port"
    if test (count $argv) -ne 1
        echo "usage: killport <port>" >&2
        return 1
    end
    fuser --kill --tcp $argv[1]
end
