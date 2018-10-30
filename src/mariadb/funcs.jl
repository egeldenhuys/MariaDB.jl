# These functions link to the LGPL 2.1 licensed MariaDB Connector/C library
# The documentation of the functions is derived from:
# https://mariadb.com/kb/en/mariadb/mariadb-connector-c
# The Julia wrapper functions are:
# Copyright (c) 2015 Dynactionize NV

"""
# Description

Returns the number of affected rows by the last operation associated with mysql, if the operation
was an "upsert" (INSERT, UPDATE, DELETE or REPLACE) statement, or -1 if the last query failed.

When using UPDATE, MariaDB will not update columns where the new value is the same as the old value.
This creates the possibility that mysql_affected_rows may not actually equal the number of rows
matched, only the number of rows that were literally affected by the query.
The REPLACE statement first deletes the record with the same primary key and then inserts the new
record. This function returns the number of deleted records in addition to the number of inserted
records.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_affected_rows(mysql::MYSQL) =
    ccall( (:mysql_affected_rows, mariadb_lib), Culonglong, (Ptr{Cvoid}, ), mysql.ptr)

"""
# Description

Toggles autocommit mode on or off for the current database connection. Autocommit mode will be set
if auto_mode=true or unset if auto_mode=false. Returns MYSQL_OK on success, or nonzero if an error
occurred.

**Autocommit** mode only affects operations on transactional table types. To determine the current
state of autocommit mode use the SQL command SELECT @@autocommit. Be aware: the *mysql_rollback()*
function will not work if autocommit mode is switched on.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **auto_mode** whether to turn autocommit on or not.
"""
mysql_autocommit(mysql::MYSQL, auto_mode::Bool) =
    ccall( (:mysql_autocommit, mariadb_lib), Cchar, (Ptr{Cvoid}, Cchar),
           mysql.ptr, Int8(auto_mode)) != 0

"""
# Description

Changes the user and default database of the current connection.

In order to successfully change users a valid username and password parameters must be provided and
that user must have sufficient permissions to access the desired database. If for any reason
authorization fails, the current user authentication will remain.

Returns MYSQL_OK on success, nonzero if an error occured.

**mysql_change_user** will always cause the current database connection to behave as if was a
completely new database connection, regardless of if the operation was completed successfully. This
reset includes performing a rollback on any active transactions, closing all temporary tables, and
unlocking all locked tables.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **user** the user name for server authentication
- **passwd** the password for server authentication
- **db** the default database. If desired, the empty string "" may be passed resulting in only
  changing the user and not selecting a database. To select a database in this case use the
  *mysql_select_db()* function.
"""
mysql_change_user(mysql::MYSQL, user::String, passwd::String, db::String = "") =
    ccall((:mysql_change_user, mariadb_lib), Cchar, (Ptr{Cvoid}, Cstring, Cstring, Cstring),
          mysql.ptr, user, passwd, (db == "" ? C_NULL : db))

"""
# Description

Returns the default client character set for the specified connection.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_character_set_name(mysql::MYSQL) = bytestring(
    ccall( (:mysql_character_set_name, mariadb_lib), Cstring, (Ptr{Cvoid},), mysql.ptr))

"""
# Description

Closes a previously opened connection.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_close(mysql::MYSQL) = ccall( (:mysql_close, mariadb_lib), Cvoid, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Commits the current transaction for the specified database connection. Returns MYSQL_OK on success,
nonzero if an error occurred.

Executing **mysql_commit()** will not affected the behaviour of *autocommit*. This means, any update
or insert statements following mysql_commit() will be rolled back when the connection gets closed.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_commit(mysql::MYSQL) = ccall( (:mysql_commit, mariadb_lib), Cchar, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

The **mysql_data_seek()** function seeks to an arbitrary function result pointer specified by the
offset in the result set.

This function can only be used with buffered result sets obtained from the use of the
*mysql_store_result* function.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()*.
- **offset** the field offset. Must be between 1 and the total number of rows.
"""
mysql_data_seek(result::MYSQL_RES, offset::UInt64) =
    ccall( (:mysql_data_seek, mariadb_lib), Cvoid, (Ptr{Cvoid}, Culonglong), result.ptr, offset-1)

"""
# Description

This function is designed to be executed by an user with the SUPER privilege and is used to dump
server status information into the log for the MariaDB Server relating to the connection.

Returns MYSQL_OK on success, nonzero if an error occurred.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_dump_debug_info(mysql::MYSQL) =
    ccall( (:mysql_dump_debug_info, mariadb_lib), Cint, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Returns the last error code for the most recent function call that can succeed or fail. Zero means
no error occurred.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_errno(mysql::MYSQL) = ccall( (:mysql_errno, mariadb_lib), Cuint, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Returns the last error message for the most recent function call that can succeed or fail. If no
error occurred an empty string is returned.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_error(mysql::MYSQL) =
    Base.unsafe_string((ccall( (:mysql_error, mariadb_lib), Cstring, (Ptr{Cvoid},), mysql.ptr)))

"""
# Description

Returns the definition of one column of a result set as a MYSQL_FIELD type. Call this function
repeatedly to retrieve information about all columns in the result set.

The field order will be reset if you execute a new SELECT query.
In case only information for a specific field is required the field can be selected by using the
*mysql_field_seek()* function or obtained by *mysql_fetch_field_direct()* function.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
mysql_fetch_field(result::MYSQL_RES) =
    MYSQL_FIELD(unsafe_load(ccall( (:mysql_fetch_field, mariadb_lib), Ptr{_MYSQL_FIELD_},
                                   (Ptr{Cvoid},), result.ptr), 1))

"""
# Description

This function serves an identical purpose to the mysql_fetch_field() function with the single
difference that instead of returning one field at a time for each field, the fields are returned as
an array. Each field contains the definition for a column of the result set.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
function mysql_fetch_fields(result::MYSQL_RES)::Vector{MYSQL_FIELD}
    num_fields = ccall( (:mysql_num_fields, mariadb_lib), Cuint, (Ptr{Cvoid},), result.ptr)
    fields = Vector{MYSQL_FIELD}(undef, num_fields)
    ptr = ccall( (:mysql_fetch_fields, mariadb_lib), Ptr{_MYSQL_FIELD_}, (Ptr{Cvoid},), result.ptr)
    for i in 1:num_fields
        fields[i] = MYSQL_FIELD(unsafe_load(ptr,i))
    end
    fields
end

"""
# Description

Returns a pointer to a MYSQL_FIELD structure which contains field information from the specified
result set.

The total number of fields can be obtained by *mysql_field_count()* or *mysql_num_fields()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
- **fieldnr** the field number. This value must be within the range from 1 to number of fields.
"""
mysql_fetch_field_direct(result::MYSQL_RES, fieldnr::UInt) =
    MYSQL_FIELD(unsafe_load(ccall( (:mysql_fetch_field_direct, mariadb_lib),
                                   Ptr{_MYSQL_FIELD_}, (Ptr{Cvoid}, Cuint),
                                   result.ptr, fieldnr-1), 1))

"""
# Description

The mysql_fetch_lengths() function returns an array containing the lengths of every column of the
current row within the result set (not including terminating zero character) or an empty array if an
error occurred.

**mysql_fetch_lengths()** is valid only for the current row of the result set. It returns an empty
array if you call it before calling *mysql_fetch_row()* or after retrieving all rows in the result.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
function mysql_fetch_lengths(result::MYSQL_RES)
    num_fields = ccall( (:mysql_num_fields, mariadb_lib), Cuint, (Ptr{Cvoid},), result.ptr)
    ptr = ccall( (:mysql_fetch_lengths, mariadb_lib), Ptr{Culong}, (Ptr{Cvoid},), result.ptr)
    ptr == C_NULL ? Culong[] : pointer_to_array(ptr, num_fields)
end

"""
# Description

Fetches one row of data from the result set and returns it as an array of ByteStrings (MYSQL_ROW),
where each column is stored in an offset starting from 1 (one). Each subsequent call to this
function will return the next row within the result set, or an empty array if there are no more
rows.

If a column contains a NULL value the corresponding element will be set to the empty string ("").
Memory associated to MYSQL_ROW will be freed when calling mysql_free_result() function.

Returns empty vector if no row is available.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""

# TODO columns to their appropriate Julia types, for now return null terminated as ByteString and not null terminated as Vector{UInt8}
const MDB_COLUMN = Union{Vector{UInt8}, String}

const NULL_TERMINATED = [ MYSQL_TYPE_TINY, 
    MYSQL_TYPE_SHORT, 
    MYSQL_TYPE_LONG, 
    MYSQL_TYPE_INT24, 
    MYSQL_TYPE_LONGLONG, 
    MYSQL_TYPE_DECIMAL, 
    MYSQL_TYPE_NEWDECIMAL, 
    MYSQL_TYPE_FLOAT, 
    MYSQL_TYPE_DOUBLE, 
    MYSQL_TYPE_BIT, 
    MYSQL_TYPE_TIMESTAMP, 
    MYSQL_TYPE_TIMESTAMP2,
    MYSQL_TYPE_DATE, 
    MYSQL_TYPE_TIME, 
    MYSQL_TYPE_TIME2,
    MYSQL_TYPE_DATETIME, 
    MYSQL_TYPE_DATETIME2,
    MYSQL_TYPE_YEAR, 
    MYSQL_TYPE_NOWDATE,
    MYSQL_TYPE_VARCHAR,
    MYSQL_TYPE_NULL ]


"""
MYSQL_ROW mysql_fetch_row(MYSQL_RES * result);
"""
function mysql_fetch_row_ptr(mysql_res::MYSQL_RES)::Ptr{Ptr{UInt8}}
    ccall((:mysql_fetch_row, "libmariadb"), Ptr{Ptr{UInt8}}, (Ref{Cvoid},), mysql_res.ptr)
end

function mysql_fetch_row(result::MYSQL_RES)
    row = Vector{MDB_COLUMN}()
    ptr = ccall( (:mysql_fetch_row, mariadb_lib), Ptr{Ptr{UInt8}}, (Ptr{Cvoid},), result.ptr)
    ptr == C_NULL &&
        return C_NULL
    fields = mysql_fetch_fields(result.ptr)
    lengths = mysql_fetch_lengths(result.ptr)
    for i in 1:length(fields)
        # Get Ptr{UInt8}
        colptr = unsafe_load(ptr,i)
        if colptr == C_NULL
            push!(row, nothing)
        elseif fields[i].field_type in NULL_TERMINATED
            push!(row, bytestring(pointer_to_array(colptr, lengths[i])))
        else
            push!(row, pointer_to_array(colptr, lengths[i]))
        end
    end
    return row
end

"""
# Description

Returns the number of columns for the most recent query on the connection represented by the link
parameter as an unsigned integer. This function can be useful when using the *mysql_store_result()*
function to determine if the query should have produced a non-empty result set or not without
knowing the nature of the query.

The mysql_field_count() function should be used to determine if there is a result set available.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_field_count(mysql::MYSQL) =
    ccall( (:mysql_field_count, mariadb_lib), Cuint, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Sets the field cursor to the given offset. The next call to mysql_fetch_field() will retrieve the
field definition of the column associated with that offset.

Returns the previous value of the field cursor.

The number of fields can be obtained from *mysql_field_count()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
- **offset** the field number. This number must be in the range from 1..number of fields.
"""
mysql_field_seek(result::MYSQL_RES, offset::MYSQL_FIELD_OFFSET) =
    ccall( (:mysql_field_seek, mariadb_lib), Cuint, (Ptr{Cvoid}, Cuint),
           result.ptr, offset-1) + 1

"""
# Description

Return the offset of the field cursor used for the last *mysql_fetch_field()* call. This value can
be used as a parameter for the function *mysql_field_seek()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
mysql_field_tell(result::MYSQL_RES) =
    ccall( (:mysql_field_tell, mariadb_lib), Cuint, (Ptr{Cvoid},), result.ptr) + 1

"""
# Description

Frees the memory associated with a result set.

You should always free your result set with **mysql_free_result()** as soon it's not needed anymore.
Row values obtained by a prior *mysql_fetch_row()* call will become invalid after calling
*mysql_free_result()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
mysql_free_result(result::MYSQL_RES) =
    ccall( (:mysql_free_result, mariadb_lib), Cvoid, (Ptr{Cvoid},), result.ptr)

"""
# Description

Returns information about the current default character set for the specified connection.

A complete list of supported character sets in the client library is listed in the function
description for *mysql_set_character_set_info()*.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
function mysql_get_character_set_info(mysql::MYSQL)
    info = _MY_CHARSET_INFO_[_MY_CHARSET_INFO_()]
    ccall( (:mysql_get_character_set_info, mariadb_lib), Cvoid, (Ptr{Cvoid}, Ref{_MY_CHARSET_INFO_}),
            mysql.ptr, info)
    return MY_CHARSET_INFO(info[1])
end

"""
# Description

Returns a string representing the client library version.

To obtain the numeric value of the client library version use *mysql_get_client_version()*.
"""
mysql_get_client_info() = bytestring(
    ccall( (:mysql_get_client_info, mariadb_lib), Ptr{UInt8}, ()))

"""
# Description

Returns a number representing the client library version.

To obtain a string containing the client library version use the *mysql_get_client_info()* function.
"""
mysql_get_client_version() = ccall( (:mysql_get_client_version, mariadb_lib), Culong, ())

"""
# Description

Describes the type of connection in use for the connection, including the server host name. Returns
a string, or "" if the connection is not valid.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
    """

_wrap_null(ptr::Ptr{UInt8}) = (ptr == C_NULL) ? "" : bytestring(ptr)

mysql_get_host_info(mysql::MYSQL) =
    _wrap_null(ccall( (:mysql_get_host_info, mariadb_lib), Ptr{UInt8}, (Ptr{Cvoid},), mysql.ptr))

"""
# Description

Returns the protocol version number for the specified connection.

The client library doesn't support protocol version 9 and prior.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_get_proto_info(mysql::MYSQL) =
    ccall( (:mysql_get_proto_info, mariadb_lib), Cuint, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Returns the server version or "" on failure.

To obtain the numeric server version please use mysql_get_server_version().

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_get_server_info(mysql::MYSQL) =
    _wrap_null(ccall( (:mysql_get_server_info, mariadb_lib), Ptr{UInt8}, (Ptr{Cvoid},), mysql.ptr))

"""
# Description

Returns an integer representing the version of connected server.

The form of the version number is VERSION_MAJOR * 10000 + VERSION_MINOR * 100 + VERSION_PATCH.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_get_server_version(mysql::MYSQL) =
    ccall( (:mysql_get_server_version, mariadb_lib), Culong, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Returns the name of the currently used cipher of the ssl connection, or "" for non ssl connections.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_get_ssl_cipher(mysql::MYSQL) =
    _wrap_null(ccall( (:mysql_get_ssl_cipher, mariadb_lib), Ptr{UInt8}, (Ptr{Cvoid},), mysql.ptr))

"""
# Description

This function is used to create a hexadecimal string which can be used in SQL statements. e.g.
`INSERT INTO my_blob VALUES(X'A0E1CD')`.

Returns the hexadecimal encoded string.

# Parameters

- **from** the string which will be encoded
"""
function mysql_hex_string(from::String)
    num_bytes = sizeof(from)
    out = Vector{UInt8}(num_bytes * 2 + 1)
    len = ccall( (:mysql_hex_string, mariadb_lib), Culong, (Ptr{UInt8}, Ptr{UInt8}, Culong),
                  out, from, num_bytes)
    r = range(1, Int64(len))
    return (bytestring(getindex(out,r)), len)
end

"""
# Description

returns a string providing information about the last query executed. The nature of this string is
provided below:

| Query type                             | Example result string                        |
| -------------------------------------- | -------------------------------------------- |
| INSERT INTO ... SELECT ...             | Records: 100 Duplicates: 0 Warnings: 0       |
| INSERT INTO...VALUES (...),(...),(...) | Records: 3 Duplicates: 0 Warnings: 0         |
| LOAD DATA INFILE ...                   | Records: 1 Deleted: 0 Skipped: 0 Warnings: 0 |
| ALTER TABLE ...                        | Records: 3 Duplicates: 0 Warnings: 0         |
| UPDATE ...                             | Rows matched: 40 Changed: 40 Warnings: 0     |

Queries which do not fall into one of the preceding formats are not supported
(e.g. `SELECT ...`). In these situations mysql_info() will return an empty string.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_info(mysql::MYSQL) =
    _wrap_null(ccall( (:mysql_info, mariadb_lib), Ptr{UInt8}, (Ptr{Cvoid},), mysql.ptr))

"""
# Description

Prepares and initializes a MYSQL structure to be used with mysql_real_connect().

If mysql_thread_init() was not called before, mysql_init() will also initialize the thread subsystem
for the current thread.

Any subsequent calls to any mysql function (except *mysql_options()*) will fail until
*mysql_real_connect()* was called.
Memory allocated by **mysql_init()** must be freed with *mysql_close()*.
"""
function mysql_init()::MYSQL
    ccall( (:mysql_init, mariadb_lib), MYSQL, (Ptr{Cvoid},), C_NULL)
end
"""
# Descriiption

The **mysql_insert_id()** function returns the ID generated by a query on a table with a column
having the AUTO_INCREMENT attribute. If the last query wasn't an INSERT or UPDATE statement or if
the modified table does not have a column with the AUTO_INCREMENT attribute, this function will
return zero.

Performing an INSERT or UPDATE statement using the LAST_INSERT_ID() function will also modify the
value returned by the mysql_insert_id() function.
When performing a multi insert statement, mysql_insert_id() will return the value of the first row.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_insert_id(mysql::MYSQL) =
    ccall( (:mysql_insert_id, mariadb_lib), Culonglong, (Ptr{UInt8},), mysql.ptr)

"""
# Description

This function is used to ask the server to kill a MariaDB thread specified by the processid
parameter. This value must be retrieved by SHOW PROCESSLIST. If trying to kill the own connection
mysql_thread_id() should be used.

Returns MYSQL_OK on success, otherwise nonzero.

To stop a running command without killing the connection use KILL QUERY. The mysql_kill() function
only kills a connection, it doesn't free any memory - this must be done explicitly by calling
*mysql_close()*.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **pid** process id.
"""
mysql_kill(mysql::MYSQL, pid::UInt) = call( (:mysql_kill, mariadb_lib), Cint, (PTr{UInt8}, Culong),
                                             mysql.ptr, pid)


"""
# Description

**mysql_server_end()** is an alias for *mysql_library_end()*.
"""
mysql_server_end() = ccall( (:mysql_server_end, mariadb_lib), Cvoid, ())

"""
# Description

**mysql_server_init()** is an alias for *mysql_library_init()*.
"""
function mysql_server_init(argv::Vector{String}, groups::Vector{String})
    c_groups::Vector{Ptr{UInt8}}
    for s in groups
        push!(c_groups, pointer(s))
    end
    push!(c_groups, convert(Ptr{UInt8}, C_NULL))
    return ccall( (:mysql_server_init, mariadb_lib), Cint,
                   (Cint, Ptr{Ptr{UInt8}}, Ptr{Ptr{UInt8}}),
                   length(argv), argv, c_groups)
end

mysql_server_init(argv::Vector{String}) =
    ccall( (:mysql_server_init, mariadb_lib), Cint,
           (Cint, Ptr{Ptr{UInt8}}, Ptr{Ptr{UInt8}}),
           length(argv), argv, C_NULL)

mysql_server_init() =
    ccall( (:mysql_server_init, mariadb_lib), Cint,
           (Cint, Ptr{Ptr{UInt8}}, Ptr{Ptr{UInt8}}),
           0, C_NULL, C_NULL)

"""
# Description

Call when finished using the library, such as after disconnecting from the server. In an embedded
server application, the embedded server is shut down and cleaned up. For a client program, only
cleans up by performing memory management tasks.

*mysql_server_end()* is an alias
"""
mysql_library_end() = mysql_server_end()

"""
# Description

Call to initialize the library before calling other functions, both for embedded servers and regular
clients. If used on an embedded server, the server is started and subsystems initialized. Returns
MYSQL_OK for success, or nonzero if an error occurred.

Call *mysql_library_end()* to clean up after completion.

*mysql_server_init()* is an alias.

# Parameters
- **argv** The arguments to pass into the init function, If used, the first parameter should be the
    process name
- **groups** The groups to pass into the init function.
"""
mysql_library_init(argv::Vector{String}, groups::Vector{String}) = mysql_server_init(argv, groups)
mysql_library_init(argv::Vector{String}) = mysql_server_init(argv)
mysql_library_init() = mysql_server_init()

"""
# Description

Indicates if one or more result sets are available from a previous call to *mysql_real_query()*.
Returns true if more result sets are available, otherwise false.

The function *mysql_set_server_option()* enables or disables multi statement support.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_more_results(mysql::MYSQL) =
    ccall( (:mysql_more_results, mariadb_lib), Cchar, (Ptr{Cvoid},), mysql.ptr) == 1

"""
# Description

Prepares next result set from a previous call to *mysql_real_query()* which can be retrieved by
*mysql_store_result()* or *mysql_use_result()*. Returns MYSQL_OK on success, nonzero if an error
occurred.

If a multi query contains errors the return value of *mysql_errno/error()* might change and there
will be no result set available.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_next_result(mysql::MYSQL) =
    ccall( (:mysql_next_result, mariadb_lib), Cint, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Returns number of fields in a specified result set.

# Parameters

- **Result** A result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
mysql_num_fields(result::MYSQL_RES) =
    ccall( (:mysql_num_fields, mariadb_lib), Cuint, (Ptr{Cvoid},), result.ptr)

"""
# Description

Returns number of rows in a result set.

The behaviour of mysql_num_rows() depends on whether buffered or unbuffered result sets are being
used. For unbuffered result sets, *mysql_num_rows()* will not return the correct number of rows
until all the rows in the result have been retrieved.

# Parameters

- **Result** A result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
mysql_num_rows(result::MYSQL_RES) =
    ccall( (:mysql_num_rows, mariadb_lib), Culonglong, (Ptr{Cvoid},), result.ptr)

"""
# Description

Used to set extra connect options and affect behavior for a connection. This function may be called
multiple times to set several options. *mysql_options()* should be called after *mysql_init()* and
before *mysql_real_connect()*.

Returns MYSQL_OK on success, non zero if an error occurred (invalid option or value).

## Options

- **MYSQL_INIT_COMMAND** Command(s) which will be executed when connecting and reconnecting to the
    server.
    ```
    mysql_options(mysql, MYSQL_INIT_COMMAND, "CREATE TABLE ...")
    ```

- **MYSQL_OPT_COMPRESS** Use the compressed protocol for client server communication. If the server
    doesn't support compressed protocol, the default protocol will be used.
    ```
    mysql_options(mysql, MYSQL_OPT_COMPRESS)
    ```

- **MYSQL_OPT_CONNECT_TIMEOUT** Connect timeout in seconds. This value will be passed as an unsigned
    int parameter.
    ```
    mysql_options(mysql, MYSQL_OPT_CONNECT_TIMEOUT, 5)
    ```

- **MYSQL_OPT_LOCAL_INFILE** Enable or disable use of LOAD DATA LOCAL INFILE
    ```
    mysql_options(mysql, MYSQL_OPT_LOCAL_INFILE)        /* disable */
    mysql_options(mysql, MYSQL_OPT_LOCAL_INFILE, "1")   /* enable */
    ```

- **MYSQL_OPT_NAMED_PIPE** For Windows operating systems only: Use named pipes for client/server
    communication.
    ```
    mysql_options(mysql, MYSQL_OPT_NAMED_PIPE)
    ```

- **MYSQL_OPT_PROTOCOL** Specify the type of client/server protocol. Possible values are:
    - MYSQL_PROTOCOL_TCP
    - MYSQL_PROTOCOL_SOCKET
    - MYSQL_PROTOCOL_PIPE
    ```
    mysql_options(mysql, MYSQL_OPT_PROTOCOL, MYSQL_PROTOCOL_SOCKET)
    ```

- **MYSQL_OPT_RECONNECT** Enable or disable automatic reconnect.
    ```
    mysql_options(mysql, MYSQL_OPT_RECONNECT)       /* disable */
    mysql_options(mysql, MYSQL_OPT_RECONNECT, "1")  /* enable */
    ```

- **MYSQL_OPT_READ_TIMEOUT** Specifies the timeout in seconds for reading packets from server. This
    value will be passed as an unsigned int.
    ```
    mysql_options(mysql, MYSQL_OPT_READ_TIMEOUT, 5)
    ```

- **MYSQL_OPT_WRITE_TIMEOUT** Specifies the timeout in seconds for sending packets to server. This
    value will be passed as an unsigned int.
    ```
    mysql_options(mysql, MYSQL_OPT_WRITE_TIMEOUT, 5)
    ```

- **MYSQL_READ_DEFAULT_FILE** Read options from named option file instead of *my.cnf*
    ```
    mysql_options(mysql, MYSQL_READ_DEFAULT_FILE, "./my_conf.cnf")
    ```

- **MYSQL_READ_DEFAULT_GROUP** Read options from the named group from my.cnf or the file specified
    with *MYSQL_READ_DEFAULT_FILE*.
    ```
    mysql_options(mysql, MYSQL_READ_DEFAULT_GROUP, "my_section")
    ```

- **MYSQL_REPORT_DATA_TRUNCATION** Enable or disable reporting data truncation errors for prepared
    statement.
    ```
    mysql_options(mysql, MYSQL_REPORT_DATA_TRUNCATION)        /* disable */
    mysql_options(mysql, MYSQL_REPORT_DATA_TRUNCATION, "1")   /* enable */
    ```

- **MYSQL_SET_CHARSET_NAME** Specify the default character set for the connection.
    ```
    mysql_options(mysql, MYSQL_SET_CHARSET_NAME, "utf8")
    ```

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **option** the option you want to set. See description above.
- **arg** The value for the option.
"""
function mysql_options(mysql::MYSQL, option::MYSQL_OPTION, arg::Ptr{Cvoid})
    if option == MYSQL_PROGRESS_CALLBACK
        error("Unsupported option: MYSQL_PROGRESS_CALLBACK")
    end
    return ccall( (:mysql_options, mariadb_lib), Cint, (Ptr{Cvoid}, Cint, Ptr{Cvoid}),
                    mysql.ptr, option, arg)
end
mysql_options(mysql::MYSQL, option::MYSQL_OPTION) = mysql_options(mysql, option, C_NULL)
mysql_options(mysql::MYSQL, option::MYSQL_OPTION, arg::String) = mysql_options(
    mysql, option, @str_2_c_str(arg))
function mysql_options(mysql::MYSQL, option::MYSQL_OPTION, arg::Int)
    tmp = Cint[arg]
    return mysql_options(mysql, option, pointer(tmp))
end
function mysql_options(mysql::MYSQL, option::MYSQL_OPTION, arg::UInt)
    tmp = Cuint[arg]
    return mysql_optinos(mysql, option, pointer(tmp))
end
mysql_options(mysql::MYSQL, optino::MYSQL_OPTION, arg::MYSQL_PROTOCOL_TYPE) = mysql_options(
    mysql, option, convert(Int, arg))

"""
# Description

Checks whether the connection to the server is working. If it has gone down, and global option
reconnect is enabled an automatic reconnection is attempted.

Returns MYSQL_OK on success, nonzero if an error occured.

This function can be used by clients that remain idle for a long while, to check whether the server
has closed the connection and reconnect if necessary.

If a reconnect occurred the thread_id will change. Also resources bundled to the connection
(prepared statements, locks, temporary tables, ...) will be released.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_ping(mysql::MYSQL) = ccall( (:mysql_ping, mariadb_lib), Cint, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Performs a statement pointed to by the null terminate string query against the database. Contrary to
*mysql_real_query()*, *mysql_query()* is not binary safe.

Returns MYSQL_OK on success, non zero on failure.

For executing multi statements the statements within the null terminated string statements must be
separated by a semicolon.

If your statement contains binary data you should use *mysql_real_query()* or escape your data with
*mysql_hex_string()*.

To determine if a statement returned a result set use the function *mysql_num_fields()*.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **query** a string containing the statement to be performed.
"""
mysql_query(mysql::MYSQL, query::String) =
    ccall( (:mysql_query, mariadb_lib), Cint, (Ptr{Cvoid}, Ptr{UInt8}), mysql.ptr, query)

"""
# Description

Establishes a connection to a database server. Returns a MYSQL handle or C_NULL if an error
occurred.

The password doesn't need to be encrypted before executing mysql_real_connect(). This will be
handled in the client server protocol.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()*.
- **host** can be either a host name or an IP address. Passing the C_NULL value or the string "" or
    "localhost" to this parameter, the local host is assumed. When possible, pipes will be used
    instead of the TCP/IP protocol.
- **user** the user name
- **passwd** If "" provided or C_NULL, the server will attempt to authenticate the user against
    those user records which have no password only. This allows one username to be used with
    different permissions (depending on if a password as provided or not).
- **db** if provided will specify the default database to be used when performing queries.
- **port** specifies the port number to attempt to connect to the server.
- **unix_socket** specifies the socket or named pipe that should be used.
- **flags** the flags allows various connection options to be set:
    - **CLIENT_FOUND_ROWS** Return the number of matched rows instead of number of changed rows.
    - **CLIENT_NO_SCHEMA** Forbids the use of database.tablename.column syntax and forces the SQL
        parser to generate an error.
    - **CLIENT_COMPRESS** Use compression protocol
    - **CLIENT_IGNORE_SPACE** This option makes all function names reserved words.
    - **CLIENT_LOCAL_FILES** Use compression protocol
    - **CLIENT_MULTI_STATEMENTS** Allows the client to send multiple statements in one command.
        Statements will be divided by a semicolon.
    - **CLIENT_MULTI_RESULTS** Indicates that the client is able to handle multiple result sets from
        stored procedures or multi statements. This option will be automatically set if
        *CLIENT_MULTI_STATEMENTS* is set.
"""
mysql_real_connect(mysql::MYSQL, host::Cstring, user::Cstring,
                   passwd::Cstring = C_NULL,
                   db::Cstring = C_NULL,
                   port::UInt = 0,
                   unix_socket::Cstring = C_NULL,
                   flags::UInt32 = 0) = ccall( (:mysql_real_connect, mariadb_lib), MYSQL,
	   (Ptr{Cvoid}, Cstring, Cstring, Cstring, Cstring, Cuint, Cstring, Culong),
           mysql.ptr, host, user, passwd, db, port, unix_socket, flags)

mysql_real_connect(mysql::MYSQL, host::String, user::String,
                    passwd::String = "",
                    db::String = "",
                    port::UInt=UInt(0),
                    unix_socket::String="",
                    flags::UInt32=UInt32(0)) = mysql_real_connect(mysql, Base.unsafe_convert(Cstring, host), Base.unsafe_convert(Cstring, user),
    Base.unsafe_convert(Cstring, passwd),
    Base.unsafe_convert(Cstring, db),
        port,
        Base.unsafe_convert(Cstring, unix_socket),
        flags)

"""
# Description

This function is used to create a legal SQL string that you can use in an SQL statement. The given
string is encoded to an escaped SQL string, taking into account the current character set of the connection.

Returns the escaped string.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **from** the string which will be escaped
"""
function mysql_real_escape_string(mysql::MYSQL, from::String)
    num_bytes = sizeof(from)
    out = Vector{UInt8}(num_bytes * 2 + 1)
    len = ccall( (:mysql_real_escape_string, mariadb_lib), Culong,
                  (Ptr{Cvoid}, Ptr{UInt8}, Ptr{UInt8}, Culong),
                  mysql.ptr, out, from, num_bytes)
    r = range(1, Int64(len))
    return (bytestring(getindex(out,r)), len)
end

"""
**mysql_real_query()** is the binary safe function for performing a statement on the database
server.

Returns MYSQL_OK on success, otherwise non zero

Contrary to the *mysql_query()* function, **mysql_real_query** is binary safe.

To determine if **mysql_real_query** returns a result set use the *mysql_num_fields()* function.

# Parameters
- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **query** a string containing the statement to be performed.
"""
mysql_real_query(mysql::MYSQL, query::Ptr{UInt8}, length::Culong) =
    ccall( (:mysql_real_query, mariadb_lib), Cint, (Ptr{Cvoid}, Ptr{UInt8}, Culong),
           mysql.ptr, query, length)

function mysql_real_query(mysql::MYSQL, query::String)
    println(query)
    mysql_real_query(mysql, Base.unsafe_convert(Ptr{UInt8}, query), Base.convert(UInt64, length(query)))
end

"""
# Description

Flushes different types of information stored on the server. The bit-masked parameter options
specify which kind of information will be flushed. options can be any combinationation of the
following:

| Option            | Description                                         |
| ----------------- | --------------------------------------------------- |
| REFRESH_GRANT     | Refresh grant tables.                               |
| REFRESH_LOG       | Flush logs.                                         |
| REFRESH_TABLES    | Flush table cache.                                  |
| REFRESH_HOSTS     | Flush host cache.                                   |
| REFRESH_STATUS    | Reset status variable.                              |
| REFRESH_THREADS   | Flush thread chache.                                |
| REFRESH_SLAVE     | Reset master server information and restart slaves. |
| REFRESH_MASTER    | Remove binary log files.                            |
| REFRESH_READ_LOCK |                                                     |
| REFRESH_FAST      |                                                     |

Returns MYSQL_OK on success, otherwise non zero.

To combine different values in the options parameter use the OR operator '|'. The function
*mysql_reload()* is an alias for *mysql_refresh()*.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **options**  a bit masked composed integer. See above.
"""
mysql_refresh(mysql::MYSQL, options::UInt32) =
    ccall( (:mysql_refresh, mariadb_lib), Cchar, (Ptr{Cvoid}, Cuint), mysql.ptr, options)

"""
# Description

Rolls back the current transaction for the database.

Returns MYSQL_OK on success, nonzero if an error occurred.

**mysql_rollback()** will not work as expected if autocommit mode was set or the storage engine does
not support transactions.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_rollback(mysql::MYSQL) =
    ccall( (:mysql_rollback, mariadb_lib), Cchar, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Positions the row cursor to an aribtrary row in a result set which was obtained by
*mysql_store_result()*.

Returns the previous row offset.

This function will **not** work if the result set was obtained by *mysql_use_result()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
- **offset** row offset. This value can be obtained either by *mysql_row_seek()* or
    *mysql_row_tell()*
"""
mysql_row_seek(result::MYSQL_RES, offset::MYSQL_ROW_OFFSET) =
    MYSQL_ROW_OFFSET(ccall( (:mysql_row_seek, mariadb_lib), Ptr{Cvoid},
                            (Ptr{Cvoid}, Ptr{Cvoid}), result.ptr, offset.ptr))

"""
# Description

Returns the row offset of a result cursor. The returned offset value can be used to reposition the
result cursor by calling *mysql_row_seek()*.

This function will not work if the result set was obtained by *mysql_use_result()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
mysql_row_tell(result::MYSQL_RES) =
    MYSQL_ROW_OFFSET(ccall( (:mysql_row_tell, mariadb_lib), Ptr{Cvoid}, (Ptr{Cvoid},), result.ptr))

"""
# Description

Selects a database as default.

Returns MYSQL_OK on success, non-zero on failure.

The SQL command SELECT DATABASE() will return the name of the default database.

The default database can also be set by the db parameter in mysql_real_connect().

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **db** the default database name.
"""
mysql_select_db(mysql::MYSQL, db::String) =
    ccall( (:mysql_select_db, mariadb_lib), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), mysql.ptr, db)

"""
# Description

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **query** the query
"""
mysql_send_query(mysql::MYSQL, query::String) =
    ccall( (:mysql_send_query, mariadb_lib),
           Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Culong),
           mysql.ptr, query, sizeof(query))

"""
# Description

Sets the default character set for the current connection.

Returns MYSQL_OK on success, non-zero on failure.

It's strongly recommended to use mysql_set_character_set() instead of SET NAMES ... since
*mysql_real_escape_string()* might fail or deliver unexpected results.

The client library supports the following character sets:

| Character set | Description                                                              |
| ------------- | ------------------------------------------------------------------------ |
| armscii8      | 8 bit character set for Armenian                                         |
| ascii	        | US ASCII character set                                                   |
| big5	        | 2 byte character set for traditional Chinese, Hongkong, Macau and Taiwan |
| binary        | 8 bit binary character set                                               |
| cp1250	| Windows code page 1250 character set                                     |
| cp1251	| Windows code page 1251 character set                                     |
| cp1256	| Windows code page 1256 character set                                     |
| cp1257	| Windows code page 1257 character set                                     |
| cp850	        | MS-DOS Codepage 850 (Western Europe)                                     |
| cp852	        | MS-DOS Codepage 852 (Middle Europe)                                      |
| cp866	        | MS-DOS Codepage 866 (Russian)                                            |
| cp932	        | Microsoft Codepage 932 (Extension to sjis)                               |
| dec8	        | DEC West European                                                        |
| eucjpms	| UJIS for Windows Japanese                                                |
| euckr	        | EUC KR-Korean                                                            |
| gb2312	| GB-2312 simplified Chinese                                               |
| gbk	        | GBK simplified Chinese                                                   |
| geostd8	| GEOSTD8 Georgian                                                         |
| greek	        | ISO 8859-7 Greek                                                         |
| hebrew	| ISO 8859-8 Hebrew                                                        |
| hp8	        | HP West European                                                         |
| keybcs2	| DOS Kamenicky Czech-Slovak                                               |
| koi8r	        | KOI8-R Relcom Russian                                                    |
| koi8u	        | KOI8-U Ukrainian                                                         |
| latin1	| CP1252 Western European                                                  |
| latin2	| ISO 8859-2 Central Europe                                                |
| latin5	| ISO 8859-9 Turkish                                                       |
| latin7	| ISO 8859-13 Baltic                                                       |
| macce	        | MAC Central European                                                     |
| macroman	| MAC Western European                                                     |
| sjis	        | SJIS for Windows Japanese                                                |
| swe7	        | 7-bit Swedish                                                            |
| tis620	| TIS620 Thai                                                              |
| ucs2	        | UCS-2 Unicode                                                            |
| ujis	        | EUC-JP Japanese                                                          |
| utf8	        | UTF-8 Unicode                                                            |
| utf16	        | UTF-16 Unicode                                                           |
| utf32	        | UTF-32 Unicode                                                           |

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **csname** character set name
"""
mysql_set_character_set(mysql::MYSQL, csname::String) =
    ccall( (:mysql_set_character_set, mariadb_lib), Cint, (Ptr{Cvoid}, Ptr{UInt8}),
           mysql.ptr, csname)

"""
# Description

Server option, which can be one of the following values:

| Option                            | Description                      |
| --------------------------------- | -------------------------------- |
| MYSQL_OPTION_MULTI_STATEMENTS_OFF | Disables multi statement support |
| MYSQL_OPTION_MULTI_STATEMENTS_ON  | Enable multi statement support   |

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **option** server option (see above)
"""
mysql_set_server_option(mysql::MYSQL, option::MYSQL_SET_OPTION) =
    ccall( (:mysql_set_server_option, mariadb_lib), Cint, (Ptr{Cvoid}, Cint), mysql.ptr, option)

"""
# Description

Sends a shutdown message to the server. To shutdown the database server, the user for the current
connection must have SHUTDOWN privileges.

Returns MYSQL_OK on success, non-zero on failure.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **shutdown_level** currently only one shutdown level, **SHUTDOWN_DEFAULT** is supported.
"""
mysql_shutdown(mysql::MYSQL, shutdown_level::MYSQL_SHUTDOWN_LEVEL) =
    ccall( (:mysql_shutdown, mariadb_lib), Cint, (Ptr{Cvoid}, Cint), mysql.ptr, shutdown_level)

"""
# Description

Returns a string containing the SQLSTATE error code for the most recently invoked function that can
succeed or fail. The error code consists of five characters. '00000' means no error. The values are
specified by ANSI SQL and ODBC

Please note that not all client library error codes are mapped to SQLSTATE errors. Errors which
can't be mapped will returned as value HY000.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_sqlstate(mysql::MYSQL) = bytestring(
    ccall( (:mysql_sqlstate, mariadb_lib), Ptr{UInt8}, (Ptr{Cvoid},), mysql.ptr))

"""
# Description

Used for establishing a secure SSL connection. It must be called before attempting to use
*mysql_real_connect()*. SSL support must be enabled in the client library in order for the function
to have any effect.

"" or C_NULL can be used for an unused parameter.

*mysql_real_connect()* will return an error if attempting to connect and SSL is incorrectly set up.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **key** path to the key file.
- **cert** path to the certificate file.
- **ca** path to the certificate authority file.
- **capath** path to the directory containing the trusted SSL CA certificates in PEM format.
- **cipher** list of permitted ciphers to use for SSL encryption.
"""
mysql_ssl_set(mysql::MYSQL,
              key::Ptr{UInt8}=C_NULL,
              cert::Ptr{UInt8}=C_NULL,
	      ca::Ptr{UInt8}=C_NULL,
              capath::Ptr{UInt8}=C_NULL,
              cipher::Ptr{UInt8}=C_NULL) =
    ccall( (:mysql_ssl_set, mariadb_lib), Cchar,
	   (Ptr{Cvoid}, Ptr{UInt8}, Ptr{UInt8}, Ptr{UInt8}, Ptr{UInt8}, Ptr{UInt8}),
           mysql.ptr, key, cert, ca, capath, cipher)

mysql_ssl_set(mysql::MYSQL,
              key::String,
              cert::String,
              ca::String,
              capath::String,
              cipher::String) =
    mysql_ssl_set(mysql,
                  @str_2_c_str(key),
                  @str_2_c_str(cert),
                  @str_2_c_str(ca),
                  @str_2_c_str(capath),
                  @str_2_c_str(cipher))

"""
# Description

**mysql_stat()** returns a string with the current server status for uptime, threads, queries, open
tables, flush tables and queries per second.

For a complete list of other status variables, you have to use the SHOW STATUS SQL command.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_stat(mysql::MYSQL) = bytestring(
    ccall( (:mysql_stat, mariadb_lib), Ptr{UInt8}, (Ptr{Cvoid},), mysql.ptr))

"""
# Description

Returns a buffered resultset from the last executed query.

**mysql_store_result()** returns C_NULL in case an error occured or if the query didn't return data
(e.g. when executing an INSERT or UPDATE query).

*mysql_field_count()* indicates if there will be a result set available.

The memory allocated by **mysql_store_result()** needs to be released by calling the function
*mysql_free_result()*.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_store_result(mysql::MYSQL) =
    ccall( (:mysql_store_result, mariadb_lib), MYSQL_RES, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

The **mysql_thread_end()** function needs to be called before a client thread ends. It will release
thread specific memory, which was allocated by a previous mysql_thread_init() call.

Unlike *mysql_thread_init()* **mysql_thread_end()** will not be invoked automatically if the thread
ends. To avoid memory leaks *mysql_thread_end()* must be called explicitly.
"""
mysql_thread_end() = ccall( (:mysql_thread_end, mariadb_lib), Cvoid, ())

"""
# Description

The mysql_thread_id() function returns the thread id for the current connection.

The current connection can be killed with *mysql_kill()*. If reconnect option is enabled the thread
id might change if the client reconnects to the server.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_thread_id(mysql::MYSQL) =
    ccall( (:mysql_thread_id, mariadb_lib), Culong, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Thread initialization for multi threaded clients. Multi threaded clients should call
**mysql_thread_init()** at the beginning of the thread initialization to initialize thread specific
client library variables. If **mysql_thread_init()** was not called explicitly, it will be called
automatically by *mysql_init()* or *mysql_real_connect()*.

Returns MYSQL_OK if successful or 1 if an error occurred.

Before a client thread ends the *mysql_thread_end()* function must be called to release memory -
otherwise the client library will report an error.
"""
mysql_thread_init() = ccall( (:mysql_thread_init, mariadb_lib), Cchar, ())

"""
# Description

Indicates whether or not the client library is compiled as thread safe. Returns 1 if the client
library was compiled as thread safe otherwise zero.

By default the mariadb client library is compiled as thread safe.
"""
mysql_thread_safe() = ccall( (:mysql_thread_safe, mariadb_lib), Cint, ())

"""
# Description

Used to initiate the retrieval of a result set from the last query executed using the
*mysql_real_query()* function on the database connection. Either this or *the mysql_store_result()*
function must be called before the results of a query can be retrieved, and one or the other must be
called to prevent the next query on that database connection from failing.

Returns an unbuffered result set or C_NULL if an error occurred.

The **mysql_use_result()** function does not transfer the entire result set. Hence several functions
like *mysql_num_rows()* or *mysql_data_seek()* cannot be used. **mysql_use_result()** will block the
current connection until all result sets are retrieved or result set was released by
*mysql_free_result()*.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_use_result(mysql::MYSQL) =
    ccall( (:mysql_use_result, mariadb_lib), MYSQL_RES, (Ptr{Cvoid},), mysql.ptr)

"""
# Description

Returns the number of warnings from the last executed query, or zero if there are no warnings.

For retrieving warning messages you should use the SQL command SHOW WARNINGS. If
SQL_MODE TRADITIONAL is enabled an error instead of warning will be returned. For detailed
information check the server documentation.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_warning_count(mysql::MYSQL) =
    ccall( (:mysql_warning_count, mariadb_lib), Cuint, (Ptr{Cvoid},), mysql.ptr)


export mysql_affected_rows, mysql_autocommit, mysql_change_user, mysql_character_set_name,
       mysql_close, mysql_commit, mysql_data_seek, mysql_dump_debug_info, mysql_errno,
       mysql_error, mysql_escape_string, mysql_fetch_field, mysql_fetch_fields,
       mysql_fetch_field_direct, mysql_fetch_lengths, mysql_fetch_row, mysql_field_count,
       mysql_field_seek, mysql_field_tell, mysql_free_result, mysql_get_character_set_info,
       mysql_get_client_info, mysql_get_client_version, mysql_get_host_info,
       mysql_get_proto_info, mysql_get_server_info, mysql_get_server_version,
       mysql_get_ssl_cipher, mysql_hex_string, mysql_info, mysql_init, mysql_insert_id,
       mysql_kill, mysql_library_end, mysql_library_init, mysql_more_results, mysql_next_result,
       mysql_num_fields, mysql_num_rows, mysql_options, mysql_ping, mysql_query,
       mysql_real_connect, mysql_real_escape_string, mysql_real_query, mysql_refresh,
       mysql_rollback, mysql_row_seek, mysql_row_tell, mysql_select_db, mysql_send_query,
       mysql_server_end, mysql_server_init, mysql_set_character_set, mysql_set_server_option,
       mysql_shutdown, mysql_sqlstate, mysql_ssl_set, mysql_stat, mysql_store_result,
       mysql_thread_end, mysql_thread_id, mysql_thread_init, mysql_thread_safe, mysql_use_result,
       mysql_warning_count
