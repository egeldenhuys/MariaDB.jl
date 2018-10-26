# Link to MariaDB C Client (system-dependent)
using Libdl

let
    global mariadb_lib
    succeeded = false
    if !isdefined(MariaDB, :mariadb_lib)
        @static if Sys.islinux()
            lib_choices = ["libmariadbclient", "libmariadbclient.so", "libmariadb"]
        end

        @static if Sys.iswindows()
            lib_choices = ["libmariadb", "libmariadb.lib"]
        end

        @static if Sys.isapple()
            lib_choices = ["libmysqlclient.dylib","libmysqlclient"]
        end

        lib = nothing
        for lib in lib_choices
            try
                Libdl.dlopen(lib)
                succeeded = true
                break
            catch
                println("WARNING: Could not find ", lib)
            end
        end
        succeeded || error("MariaDB client library not found")
        const mariadb_lib = lib
    end
end
