# These are used to link to the LGPL 2.1 licensed MariaDB Connector/C library
# They are derived from:
# https://mariadb.com/kb/en/mariadb/mariadb-connector-c
# The Julia wrapper types are:
# Copyright (c) 2015 Dynactionize NV

export MYSQL, MYSQL_RES, MYSQL_ROW, MYSQL_FIELD_OFFSET, MYSQL_ROW_OFFSET

mutable struct MYSQL
    ptr::Ptr{Cvoid}
    MYSQL(p) = (val = new(p) ; finalizer(val, finalizer!) ; val)
end

mutable struct MYSQL_RES
    ptr::Ptr{Cvoid}
    MYSQL_RES(p) = (val = new(p) ; finalizer(val, finalizer!) ; val)
end

struct MYSQL_ROW
    data::Vector{String}
end

struct MYSQL_FIELD_OFFSET
    off::UInt32
end

mutable struct MYSQL_ROW_OFFSET
    ptr::Ptr{Cvoid}
    MYSQL_ROW_OFFSET(p) = (val = new(p) ; finalizer(val, finalizer!) ; val)
end

struct MYSQL_FIELD_TYPE
    typ::UInt8
end


export MYSQL_FIELD_TYPE
export MYSQL_TYPE_DECIMAL, MYSQL_TYPE_TINY, MYSQL_TYPE_SHORT, MYSQL_TYPE_LONG, MYSQL_TYPE_FLOAT,
       MYSQL_TYPE_DOUBLE, MYSQL_TYPE_NULL, MYSQL_TYPE_TIMESTAMP, MYSQL_TYPE_LONGLONG,
       MYSQL_TYPE_INT24, MYSQL_TYPE_DATE, MYSQL_TYPE_TIME, MYSQL_TYPE_DATETIME, MYSQL_TYPE_YEAR,
       MYSQL_TYPE_NOWDATE, MYSQL_TYPE_VARCHAR, MYSQL_TYPE_BIT, MYSQL_TYPE_TIMESTAMP2,
       MYSQL_TYPE_DATETIME2, MYSQL_TYPE_TIME2, MYSQL_TYPE_NEWDECIMAL, MYSQL_TYPE_ENUM,
       MYSQL_TYPE_SET, MYSQL_TYPE_TINY_BLOB, MYSQL_TYPE_MEDIUM_BLOB, MYSQL_TYPE_LONG_BLOB,
       MYSQL_TYPE_BLOB, MYSQL_TYPE_VAR_STRING, MYSQL_TYPE_STRING, MYSQL_TYPE_GEOMETRY

const MYSQL_TYPE_DECIMAL        = MYSQL_FIELD_TYPE(0)
const MYSQL_TYPE_TINY           = MYSQL_FIELD_TYPE(1)
const MYSQL_TYPE_SHORT          = MYSQL_FIELD_TYPE(2)
const MYSQL_TYPE_LONG           = MYSQL_FIELD_TYPE(3)
const MYSQL_TYPE_FLOAT          = MYSQL_FIELD_TYPE(4)
const MYSQL_TYPE_DOUBLE         = MYSQL_FIELD_TYPE(5)
const MYSQL_TYPE_NULL           = MYSQL_FIELD_TYPE(6)
const MYSQL_TYPE_TIMESTAMP      = MYSQL_FIELD_TYPE(7)
const MYSQL_TYPE_LONGLONG       = MYSQL_FIELD_TYPE(8)
const MYSQL_TYPE_INT24          = MYSQL_FIELD_TYPE(9)
const MYSQL_TYPE_DATE           = MYSQL_FIELD_TYPE(10)
const MYSQL_TYPE_TIME           = MYSQL_FIELD_TYPE(11)
const MYSQL_TYPE_DATETIME       = MYSQL_FIELD_TYPE(12)
const MYSQL_TYPE_YEAR           = MYSQL_FIELD_TYPE(13)
const MYSQL_TYPE_NOWDATE        = MYSQL_FIELD_TYPE(14)
const MYSQL_TYPE_VARCHAR        = MYSQL_FIELD_TYPE(15)
const MYSQL_TYPE_BIT            = MYSQL_FIELD_TYPE(16)
const MYSQL_TYPE_TIMESTAMP2     = MYSQL_FIELD_TYPE(17)
const MYSQL_TYPE_DATETIME2      = MYSQL_FIELD_TYPE(18)
const MYSQL_TYPE_TIME2          = MYSQL_FIELD_TYPE(19)
const MYSQL_TYPE_NEWDECIMAL     = MYSQL_FIELD_TYPE(246)
const MYSQL_TYPE_ENUM           = MYSQL_FIELD_TYPE(247)
const MYSQL_TYPE_SET            = MYSQL_FIELD_TYPE(248)
const MYSQL_TYPE_TINY_BLOB      = MYSQL_FIELD_TYPE(249)
const MYSQL_TYPE_MEDIUM_BLOB    = MYSQL_FIELD_TYPE(250)
const MYSQL_TYPE_LONG_BLOB      = MYSQL_FIELD_TYPE(251)
const MYSQL_TYPE_BLOB           = MYSQL_FIELD_TYPE(252)
const MYSQL_TYPE_VAR_STRING     = MYSQL_FIELD_TYPE(253)
const MYSQL_TYPE_STRING         = MYSQL_FIELD_TYPE(254)
const MYSQL_TYPE_GEOMETRY       = MYSQL_FIELD_TYPE(255)


export MYSQL_TIMESTAMP_TYPE
export MYSQL_TIMESTAMP_NONE, MYSQL_TIMESTAMP_ERROR, MYSQL_TIMESTAMP_DATE,
       MYSQL_TIMESTAMP_DATETIME, MYSQL_TIMESTAMP_TIME

struct MYSQL_TIMESTAMP_TYPE
    typ::Int8
end

const MYSQL_TIMESTAMP_NONE      = MYSQL_TIMESTAMP_TYPE(-2)
const MYSQL_TIMESTAMP_ERROR     = MYSQL_TIMESTAMP_TYPE(-1)
const MYSQL_TIMESTAMP_DATE      = MYSQL_TIMESTAMP_TYPE(0)
const MYSQL_TIMESTAMP_DATETIME  = MYSQL_TIMESTAMP_TYPE(1)
const MYSQL_TIMESTAMP_TIME      = MYSQL_TIMESTAMP_TYPE(2)


export MYSQL_OPTION
export MYSQL_OPT_CONNECT_TIMEOUT, MYSQL_OPT_COMPRESS, MYSQL_OPT_NAMED_PIPE, MYSQL_INIT_COMMAND,
       MYSQL_READ_DEFAULT_FILE, MYSQL_READ_DEFAULT_GROUP, MYSQL_SET_CHARSET_DIR,
       MYSQL_SET_CHARSET_NAME, MYSQL_OPT_LOCAL_INFILE, MYSQL_OPT_PROTOCOL,
       MYSQL_SHARED_MEMORY_BASE_NAME, MYSQL_OPT_READ_TIMEOUT, MYSQL_OPT_WRITE_TIMEOUT,
       MYSQL_OPT_USE_RESULT, MYSQL_OPT_USE_REMOTE_CONNECTION, MYSQL_OPT_USE_EMBEDDED_CONNECTION,
       MYSQL_OPT_GUESS_CONNECTION, MYSQL_SET_CLIENT_IP, MYSQL_SECURE_AUTH,
       MYSQL_REPORT_DATA_TRUNCATION, MYSQL_OPT_RECONNECT, MYSQL_OPT_SSL_VERIFY_SERVER_CERT,
       MYSQL_PLUGIN_DIR, MYSQL_DEFAULT_AUTH, MYSQL_ENABLE_CLEARTEXT_PLUGIN, MYSQL_PROGRESS_CALLBACK,
       MYSQL_OPT_NONBLOCK

struct MYSQL_OPTION
    opt::UInt16
end

const MYSQL_OPT_CONNECT_TIMEOUT         = MYSQL_OPTION(0)
const MYSQL_OPT_COMPRESS                = MYSQL_OPTION(1)
const MYSQL_OPT_NAMED_PIPE              = MYSQL_OPTION(2)
const MYSQL_INIT_COMMAND                = MYSQL_OPTION(3)
const MYSQL_READ_DEFAULT_FILE           = MYSQL_OPTION(4)
const MYSQL_READ_DEFAULT_GROUP          = MYSQL_OPTION(5)
const MYSQL_SET_CHARSET_DIR             = MYSQL_OPTION(6)
const MYSQL_SET_CHARSET_NAME            = MYSQL_OPTION(7)
const MYSQL_OPT_LOCAL_INFILE            = MYSQL_OPTION(8)
const MYSQL_OPT_PROTOCOL                = MYSQL_OPTION(9)
const MYSQL_SHARED_MEMORY_BASE_NAME     = MYSQL_OPTION(10)
const MYSQL_OPT_READ_TIMEOUT            = MYSQL_OPTION(11)
const MYSQL_OPT_WRITE_TIMEOUT           = MYSQL_OPTION(12)
const MYSQL_OPT_USE_RESULT              = MYSQL_OPTION(13)
const MYSQL_OPT_USE_REMOTE_CONNECTION   = MYSQL_OPTION(14)
const MYSQL_OPT_USE_EMBEDDED_CONNECTION = MYSQL_OPTION(15)
const MYSQL_OPT_GUESS_CONNECTION        = MYSQL_OPTION(16)
const MYSQL_SET_CLIENT_IP               = MYSQL_OPTION(17)
const MYSQL_SECURE_AUTH                 = MYSQL_OPTION(18)
const MYSQL_REPORT_DATA_TRUNCATION      = MYSQL_OPTION(19)
const MYSQL_OPT_RECONNECT               = MYSQL_OPTION(20)
const MYSQL_OPT_SSL_VERIFY_SERVER_CERT  = MYSQL_OPTION(21)
const MYSQL_PLUGIN_DIR                  = MYSQL_OPTION(22)
const MYSQL_DEFAULT_AUTH                = MYSQL_OPTION(23)
const MYSQL_ENABLE_CLEARTEXT_PLUGIN     = MYSQL_OPTION(24)
const MYSQL_PROGRESS_CALLBACK           = MYSQL_OPTION(5999)
const MYSQL_OPT_NONBLOCK                = MYSQL_OPTION(6000)

export MYSQL_PROTOCOL_TYPE
export MYSQL_PROTOCOL_DEFAULT, MYSQL_PROTOCOL_TCP, MYSQL_PROTOCOL_SOCKET, MYSQL_PROTOCOL_PIPE,
       MYSQL_PROTOCOL_PIPE

struct MYSQL_PROTOCOL_TYPE
    typ::UInt8
end

const MYSQL_PROTOCOL_DEFAULT    = MYSQL_PROTOCOL_TYPE(0)
const MYSQL_PROTOCOL_TCP        = MYSQL_PROTOCOL_TYPE(1)
const MYSQL_PROTOCOL_SOCKET     = MYSQL_PROTOCOL_TYPE(2)
const MYSQL_PROTOCOL_PIPE       = MYSQL_PROTOCOL_TYPE(3)
const MYSQL_PROTOCOL_MEMORY     = MYSQL_PROTOCOL_TYPE(4)


export MYSQL_STATUS
export MYSQL_STATUS_READY, MYSQL_STATUS_GET_RESULT, MYSQL_STATUS_USE_RESULT,
       MYSQL_STATUS_STATEMENT_GET_RESULT

struct MYSQL_STATUS
    status::UInt8
end

const MYSQL_STATUS_READY                = MYSQL_STATUS(0)
const MYSQL_STATUS_GET_RESULT           = MYSQL_STATUS(1)
const MYSQL_STATUS_USE_RESULT           = MYSQL_STATUS(2)
const MYSQL_STATUS_STATEMENT_GET_RESULT = MYSQL_STATUS(3)

export MYSQL_SET_OPTION
export MYSQL_OPTION_MULTI_STATEMENT_ON, MYSQL_OPTION_MULTI_STATEMENT_OFF

struct MYSQL_SET_OPTION
    status::UInt8
end

const MYSQL_OPTION_MULTI_STATEMENTS_ON  = MYSQL_SET_OPTION(0)
const MYSQL_OPTION_MULTI_STATEMENTS_OFF = MYSQL_SET_OPTION(1)

export MYSQL_NO_MORE_RESULTS

const MYSQL_NO_MORE_RESULTS               = -1

export MYSQL_SHUTDOWN_KILLABLE_CONNECT, MYSQL_SHUTDOWN_KILLABLE_TRANS,
       MYSQL_SHUTDOWN_KILLABLE_LOCK_TABLE, MYSQL_SHUTDOWN_KILLABLE_UPDATE

const MYSQL_SHUTDOWN_KILLABLE_CONNECT     = 0x01
const MYSQL_SHUTDOWN_KILLABLE_TRANS       = 0x02
const MYSQL_SHUTDOWN_KILLABLE_LOCK_TABLE  = 0x04
const MYSQL_SHUTDOWN_KILLABLE_UPDATE      = 0x08

export MYSQL_SHUTDOWN_LEVEL

struct MYSQL_SHUTDOWN_LEVEL
    level::UInt8
end

const SHUTDOWN_DEFAULT               = MYSQL_SHUTDOWN_LEVEL(0)
const SHUTDOWN_WAIT_CONNECTIONS      = MYSQL_SHUTDOWN_LEVEL(MYSQL_SHUTDOWN_KILLABLE_CONNECT)
const SHUTDOWN_WAIT_TRANSACTIONS     = MYSQL_SHUTDOWN_LEVEL(MYSQL_SHUTDOWN_KILLABLE_TRANS)
const SHUTDOWN_WAIT_UPDATES          = MYSQL_SHUTDOWN_LEVEL(MYSQL_SHUTDOWN_KILLABLE_UPDATE)
const SHUTDOWN_WAIT_ALL_BUFFERS      = MYSQL_SHUTDOWN_LEVEL(MYSQL_SHUTDOWN_KILLABLE_UPDATE<<1)
const SHUTDOWN_WAIT_CRITICAL_BUFFERS = MYSQL_SHUTDOWN_LEVEL((MYSQL_SHUTDOWN_KILLABLE_UPDATE<<1)+1)

export NOT_NULL_FLAG, PRI_KEY_FLAG, UNIQUE_KEY_FLAG, MULTIPLE_KEY_FLAG, BLOB_FLAG, UNSIGNED_FLAG,
       ZEROFILL_FLAG, BINARY_FLAG, ENUM_FLAG, AUTO_INCREMENT_FLAG, TIMESTAMP_FLAG, SET_FLAG,
       NO_DEFAULT_VALUE_FLAG, ON_UPDATE_NOW_FLAG, NUM_FLAG, UNIQUE_FLAG, BINCP_FLAG,
       GET_FIXED_FIELDS_FLAG, FIELD_IN_PART_FUNC_FLAG

const NOT_NULL_FLAG                  = 0x00000001
const PRI_KEY_FLAG                   = 0x00000002
const UNIQUE_KEY_FLAG                = 0x00000004
const MULTIPLE_KEY_FLAG              = 0x00000008
const BLOB_FLAG                      = 0x00000010
const UNSIGNED_FLAG                  = 0x00000020
const ZEROFILL_FLAG                  = 0x00000040
const BINARY_FLAG                    = 0x00000080
const ENUM_FLAG                      = 0x00000100
const AUTO_INCREMENT_FLAG            = 0x00000200
const TIMESTAMP_FLAG                 = 0x00000400
const SET_FLAG                       = 0x00000800
const NO_DEFAULT_VALUE_FLAG          = 0x00001000
const ON_UPDATE_NOW_FLAG             = 0x00002000
const NUM_FLAG                       = 0x00004000
const UNIQUE_FLAG                    = 0x00008000
const BINCP_FLAG                     = 0x00010000
const GET_FIXED_FIELDS_FLAG          = 0x00020000
const FIELD_IN_PART_FUNC_FLAG        = 0x00040000


export CLIENT_LONG_PASSWORD, CLIENT_FOUND_ROWS, CLIENT_LONG_FLAG, CLIENT_CONNECT_WITH_DB,
       CLIENT_NO_SCHEMA, CLIENT_COMPRESS, CLIENT_ODBC, CLIENT_LOCAL_FILES, CLIENT_IGNORE_SPACE,
       CLIENT_PROTOCOL_41, CLIENT_INTERACTIVE, CLIENT_SSL, CLIENT_IGNORE_SIGPIPE,
       CLIENT_TRANSACTIONS, CLIENT_RESERVED, CLIENT_SECURE_CONNECTION, CLIENT_MULTI_STATEMENTS,
       CLIENT_MULTI_RESULTS, CLIENT_PS_MULTI_RESULTS, CLIENT_PLUGIN_AUTH, CLIENT_PROGRESS,
       CLIENT_SSL_VERIFY_SERVER_CERT

const CLIENT_LONG_PASSWORD           = 0x00000001
const CLIENT_FOUND_ROWS              = 0x00000002
const CLIENT_LONG_FLAG               = 0x00000004
const CLIENT_CONNECT_WITH_DB         = 0x00000008
const CLIENT_NO_SCHEMA               = 0x00000010
const CLIENT_COMPRESS                = 0x00000020
const CLIENT_ODBC                    = 0x00000040
const CLIENT_LOCAL_FILES             = 0x00000080
const CLIENT_IGNORE_SPACE            = 0x00000100
const CLIENT_PROTOCOL_41             = 0x00000200
const CLIENT_INTERACTIVE             = 0x00000400
const CLIENT_SSL                     = 0x00000800
const CLIENT_IGNORE_SIGPIPE          = 0x00001000
const CLIENT_TRANSACTIONS            = 0x00002000
const CLIENT_RESERVED                = 0x00004000
const CLIENT_SECURE_CONNECTION       = 0x00008000
const CLIENT_MULTI_STATEMENTS        = 0x00010000
const CLIENT_MULTI_RESULTS           = 0x00020000
const CLIENT_PS_MULTI_RESULTS        = 0x00040000
const CLIENT_PLUGIN_AUTH             = 0x00080000
const CLIENT_PROGRESS                = 0x20000000
const CLIENT_SSL_VERIFY_SERVER_CERT  = 0x40000000


export REFRESH_GRANT, REFRESH_LOG, REFRESH_TABLES, REFRESH_HOSTS, REFRESH_STATUS, REFRESH_THREADS,
       REFRESH_SLAVE, REFRESH_MASTER, REFRESH_ERROR_LOG, REFRESH_ENGINE_LOG, REFRESH_BINARY_LOG,
       REFRESH_RELAY_LOG, REFRESH_GENERAL_LOG, REFRESH_SLOW_LOG, REFRESH_READ_LOCK,
       REFRESH_CHECKPOINT, REFRESH_QUERY_CACHE, REFRESH_QUERY_CACHE_FREE, REFRESH_DES_KEY_FILE,
       REFRESH_USER_RESOURCES, REFRESH_TABLE_STATS, REFRESH_INDEX_STATS, REFRESH_USER_STATS,
       REFRESH_FAST

const REFRESH_GRANT                  = 0x00000001
const REFRESH_LOG                    = 0x00000002
const REFRESH_TABLES                 = 0x00000004
const REFRESH_HOSTS                  = 0x00000008
const REFRESH_STATUS                 = 0x00000010
const REFRESH_THREADS                = 0x00000020
const REFRESH_SLAVE                  = 0x00000040
const REFRESH_MASTER                 = 0x00000080
const REFRESH_ERROR_LOG              = 0x00000100
const REFRESH_ENGINE_LOG             = 0x00000200
const REFRESH_BINARY_LOG             = 0x00000400
const REFRESH_RELAY_LOG              = 0x00000800
const REFRESH_GENERAL_LOG            = 0x00001000
const REFRESH_SLOW_LOG               = 0x00002000
const REFRESH_READ_LOCK              = 0x00004000
const REFRESH_CHECKPOINT             = 0x00008000
const REFRESH_QUERY_CACHE            = 0x00010000
const REFRESH_QUERY_CACHE_FREE       = 0x00020000
const REFRESH_DES_KEY_FILE           = 0x00040000
const REFRESH_USER_RESOURCES         = 0x00080000
const REFRESH_TABLE_STATS            = 0x00100000
const REFRESH_INDEX_STATS            = 0x00200000
const REFRESH_USER_STATS             = 0x00400000
const REFRESH_FAST                   = 0x80000000


macro c_str_2_str(c_str)
    return :($c_str == C_NULL ? "" : bytestring($c_str))
end

macro str_2_c_str(str)
    return :($str == "" ? Base.convert(Ptr{UInt8}, C_NULL) : pointer($str))
end

struct _MYSQL_FIELD_
    name::Ptr{UInt8}
    org_name::Ptr{UInt8}
    table::Ptr{UInt8}
    org_table::Ptr{UInt8}
    db::Ptr{UInt8}
    catalog::Ptr{UInt8}
    def::Ptr{UInt8}
    @static if Sys.iswindows()
        length::UInt32
        max_length::UInt32
    end
    @static if Sys.islinux()
        length::UInt
        max_length::UInt
    end
    name_length::UInt32
    org_name_length::UInt32
    table_length::UInt32
    org_table_length::UInt32
    db_length::UInt32
    catalog_lenght::UInt32
    def_length::UInt32
    flags::UInt32
    decimals::UInt32
    charsetnr::UInt32
    field_type::UInt32
    extension::Ptr{Cvoid}
end
_MYSQL_FIELD_() = _MYSQL_FIELD_(C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, C_NULL)

export MYSQL_FIELD

struct MYSQL_FIELD
    name::String
    org_name::String
    table::String
    org_table::String
    db::String
    catalog::String
    def::String
    length::UInt
    max_length::UInt
    flags::UInt
    decimals::UInt
    charsetnr::UInt
    field_type::MYSQL_FIELD_TYPE
end

MYSQL_FIELD() = MYSQL_FIELD("", "", "", "", "", 0, 0, 0, 0, 0, 0)
function MYSQL_FIELD(c_mysql_field::_MYSQL_FIELD_)
    MYSQL_FIELD(
        @c_str_2_str(c_mysql_field.name),
        @c_str_2_str(c_mysql_field.org_name),
        @c_str_2_str(c_mysql_field.table),
        @c_str_2_str(c_mysql_field.org_table),
        @c_str_2_str(c_mysql_field.db),
        @c_str_2_str(c_mysql_field.catalog),
        @c_str_2_str(c_mysql_field.def),
        c_mysql_field.length,
        c_mysql_field.max_length,
        c_mysql_field.flags,
        c_mysql_field.decimals,
        c_mysql_field.charsetnr,
        c_mysql_field.field_type
    )
end

struct _MY_CHARSET_INFO_
    number::UInt32
    state::UInt32
    csname::Ptr{UInt8}
    name::Ptr{UInt8}
    comment::Ptr{UInt8}
    dir::Ptr{UInt8}
    mbminlen::UInt32
    mbmaxlen::UInt32
end
_MY_CHARSET_INFO_() = _MY_CHARSET_INFO_(0, 0, C_NULL, C_NULL, C_NULL, C_NULL, 0, 0)

export MY_CHARSET_INFO

struct MY_CHARSET_INFO
    number::UInt
    state::UInt
    csname::String
    name::String
    comment::String
    dir::String
    mbminlen::UInt
    mbmaxlen::UInt
end
MY_CHARSET_INFO() = MY_CHARSET_INFO(0, 0, "", "", "", "", 0, 0)
function MY_CHARSET_INFO(c_charset_info::_MY_CHARSET_INFO_)
    MY_CHARSET_INFO(
        c_charset_info.number,
        c_charset_info.state,
        @c_str_2_str(c_charset_info.csname),
        @c_str_2_str(c_charset_info.name),
        @c_str_2_str(c_charset_info.comment),
        @c_str_2_str(c_charset_info.dir),
        c_charset_info.mbminlen,
        c_charset_info.mbmaxlen
    )
end


export MYSQL_TIME

struct MYSQL_TIME
    year::UInt32
    month::UInt32
    day::UInt32
    hour::UInt32
    minute::UInt32
    second::UInt32
    @static if Sys.iswindows()
        second_part::UInt32
    end
    @static if Sys.islinux()
        second_part::UInt
    end
    neg::Int8
    time_type::MYSQL_TIMESTAMP_TYPE
end
