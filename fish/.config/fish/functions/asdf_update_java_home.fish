# Point JAVA_HOME/JDK_HOME at the active asdf Java install.
#
# Fires on every prompt because the active version can change at runtime,
# after the shell has already started.
function asdf_update_java_home --on-event fish_prompt
    if not type -q asdf
        return 0
    end
    set --local java_binary (asdf which java 2>/dev/null)
    if test -z "$java_binary"
        return 0
    end
    set --local java_real_path (builtin realpath "$java_binary")
    # realpath returns $JAVA_HOME/bin/java, so strip two path segments.
    set --global JAVA_HOME (dirname (dirname "$java_real_path"))
    set --global JDK_HOME $JAVA_HOME
end
