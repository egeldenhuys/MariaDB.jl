# Link to MariaDB C Client (system-dependent)
using Libdl

# let
#     global mariadb_lib
#     succeeded = false
#     if !isdefined(MariaDB, :mariadb_lib)
#         @static if Sys.islinux()
#             lib_choices = ["libmariadbclient", "libmariadbclient.so", "libmariadb"]
#         end

#         @static if Sys.iswindows()
#             lib_choices = ["libmariadb", "libmariadb.lib"]
#         end

#         @static if Sys.isapple()
#             lib_choices = ["libmysqlclient.dylib","libmysqlclient"]
#         end

#           # latest_lib should be a string, not whatever it is now
#         lib = nothing
#         latest_lib = nothing
#         for lib in lib_choices
#             try
#                 latest_lib = Libdl.dlopen(lib)
#                 succeeded = true
#                 break
#             catch
#                 println("WARNING: Could not find ", lib)
#                 latest_lib = nothing
#             end
#         end
#         succeeded || error("MariaDB client library not found")
#         const mariadb_lib = latest_lib
#         println("mariadb_lib = ", mariadb_lib)
#     end
# end

# TODO(egeldenhuys): Implement above logic again
let
    global mariadb_lib
    const mariadb_lib = "libmariadb"
end