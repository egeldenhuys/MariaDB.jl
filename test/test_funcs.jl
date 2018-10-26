module TestFuncs
    using Test
    using MariaDB

    function connect_to_database(user::String, password::String, db::String)::MYSQL
        mysql = mysql_init()
        @test mysql != C_NULL

        connect_flags = MariaDB.CLIENT_MULTI_RESULTS | MariaDB.CLIENT_MULTI_STATEMENTS
        mysql = mysql_real_connect(mysql, "127.0.0.1", user, password, db, UInt(3306))
        @test mysql != C_NULL

        return mysql
    end

    function create_test_database()
        mysql = connect_to_database("root", "", "")

        command = "create database db_test;"
        #command = string(command, "alter database db_test CHARACTER SET = 'utf8';")
        #command = string(command, "alter database db_test DEFAULT COLLATE = utf8mb4_unicode_ci;")
        command = string(command, "create user 'maarten'@'%' identified by 'pwd_maarten';")
        command = string(command, "grant ALL on db_test.* to 'maarten'@'%';")
        command = string(command, "create user 'michael'@'%' identified by 'pwd_michael';")
        command = string(command, "grant SELECT on db_test.* to 'michael'@'%';")
        rc = mysql_real_query(mysql, command)
        if rc != MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_OK

        mysql_close(mysql)
    end

    function drop_test_database()
        mysql = connect_to_database("root", "", "")

        command = "drop user 'maarten'@'%';"
        command = string(command, "drop user 'michael'@'%';")
        command = string(command, "drop database db_test;")
        rc = mysql_real_query(mysql, command)
        if rc != MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_OK

        mysql_close(mysql)
    end

    function prepare_database()
        mysql = connect_to_database("root", "", "")

        # Check to see if we already have a database 'db_test'
        command = "SHOW DATABASES LIKE 'db_test';"
        rc = mysql_real_query(mysql, command)
        if rc != MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_OK
        println("CHECK_B")
        fc = mysql_field_count(mysql)
        @test fc == 1

        println("CHECK_C")
        reshndl = mysql_use_result(mysql)
        @test reshndl != C_NULL

        println("CHECK_D")
        rowCount = 0
        while mysql_fetch_row(reshndl) != C_NULL
            println("CHECK_E")
            rowCount+=1
        end

        println("CHECK_F")
        mysql_free_result(reshndl)

        println("CHECK_G")
        mysql_close(mysql)

        println("CHECK_A")
        if rowCount > 0
            println("Database 'db_test' found")
            println("\tRecreating...")
            drop_test_database()
        else
            println("Database 'db_test' not found")
            println("\tCreating...")
        end
        create_test_database()
    end

    function create_tables()
        println("\tCreating tables ...")
        mysql = connect_to_database("maarten", "pwd_maarten", "db_test")
        @test mysql != C_NULL

        command = "create table Persons (
            ID INT NOT NULL AUTO_INCREMENT,
            FirstName VARCHAR(64),
            LastName VARCHAR(64),
            PRIMARY KEY pk_persons(ID)
        );"
        command = string(command, "insert into Persons (FirstName, LastName) values
            ('Michael', 'Brands'),
            ('Florian', 'Lechner'),
            ('Maarten', 'Heremans'),
            ('Diederik', 'Herbert'),
            ('Ulf', 'Nystrom'),
            ('Roy', 'Williams'),
            ('Enzo', 'Brands'),
            ('Scott', 'Jones'),
            ('Joby', 'Chacko'),
            ('Junia', 'Antony'),
            ('Thara', 'H'),
            ('Jayakrishnan', 'Nair'),
            ('Kiran', 'P'),
            ('Andrew', 'Joy')
        ;")

        rc = mysql_real_query(mysql, command)
        if rc != MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_OK

        # Loop over results and clear out
        rc = mysql_next_result(mysql)
        while rc == MYSQL_OK
            if mysql_field_count(mysql) > 0
                reshndl = mysql_store_result(mysql)
                mysql_free_result(reshndl)
            end
            rc = mysql_next_result(mysql)
        end
        if rc > MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_NO_MORE_RESULTS

        command = "create table Skills (
            ID INT NOT NULL AUTO_INCREMENT,
            Skill VARCHAR(64),
            PRIMARY KEY pk_skills(ID)
        );"
        command = string(command, "insert into Skills (Skill) values
            ('Management'),
            ('Programming'),
            ('Housekeeping'),
            ('Testing'),
            ('Eating'),
            ('PITA'),
            ('Design')
        ;")

        rc = mysql_real_query(mysql, command)
        if rc != MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_OK

        # Loop over results and clear out
        rc = mysql_next_result(mysql)
        while rc == MYSQL_OK
            if mysql_field_count(mysql) > 0
                reshndl = mysql_store_result(mysql)
                mysql_free_result(reshndl)
            end
            rc = mysql_next_result(mysql)
        end
        if rc > MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_NO_MORE_RESULTS

        command = "create table PersonSkills (
            PersonID INT NOT NULL,
            SkillID INT NOT NULL,
            PRIMARY KEY pk_person_skils(PersonID, SkillID),
            CONSTRAINT fk_personskills_personid FOREIGN KEY (PersonID) references Persons(ID)
                ON UPDATE CASCADE ON DELETE CASCADE,
            CONSTRAINT fk_personskills_skillid FOREIGN KEY (SkillID) references Skills(ID)
                ON UPDATE CASCADE ON DELETE RESTRICT
        );"
        command = string(command, "insert into PersonSkills (PersonID, SkillID) values
            (1, 1), (1, 4),
            (2, 1), (2, 2), (2, 4),
            (3, 2), (3, 4),
            (4, 1), (4, 3),
            (5, 3),
            (6, 1), (6, 7),
            (7, 2), (7, 4),
            (8, 2), (8, 5), (8, 6),
            (9, 1), (9, 2), (9, 4),
            (10, 2), (10, 4),
            (11, 2), (11, 4),
            (12, 2), (12, 4),
            (13, 7),
            (14, 2), (14, 7)
        ;")

        rc = mysql_real_query(mysql, command)
        if rc != MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_OK

        # Loop over results and clear out
        rc = mysql_next_result(mysql)
        while rc == MYSQL_OK
            if mysql_field_count(mysql) > 0
                reshndl = mysql_store_result(mysql)
                mysql_free_result(reshndl)
            end
            rc = mysql_next_result(mysql)
        end
        if rc > MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_NO_MORE_RESULTS

        mysql_close(mysql)
    end

    function print_fields(fields::Vector{MYSQL_FIELD})
        for f in fields
            println("
Field: {
    name: $(f.name),
    table: $(f.table),
    db: $(f.db),
    catalog: $(f.catalog),
    def: $(f.def),
    length: $(f.length),
    max_length:
    $(f.max_length),
    flags: $(f.flags),
    decimals:
    $(f.decimals),
    charsetnr: $(f.charsetnr),
    field_type: $(f.field_type)
}")
        end
    end

    function print_row(row::Vector{String})
        print("| ")
        for c in row
            print("$c | ")
        end
        println("")
    end

    function print_result(mysql::MYSQL)
        reshndl = mysql_use_result(mysql)
        fields = mysql_fetch_fields(reshndl)
        print_fields(fields)
        row = mysql_fetch_row(reshndl)
        while row != C_NULL
            print_row(row)
            row = mysql_fetch_row(reshndl)
        end
        mysql_free_result(reshndl)
    end

    function query_tables()
        println("\tQuerying tables ...")
        mysql = connect_to_database("michael", "pwd_michael", "db_test")
        @test mysql != C_NULL

        command = "Select * from Persons;"
        command = string(command, "Select * from Skills;")
        rc = mysql_real_query(mysql, command)
        if rc != MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_OK

        if mysql_field_count(mysql) > 0
            print_result(mysql)
        end

        rc = mysql_next_result(mysql)
        while rc == MYSQL_OK
            if mysql_field_count(mysql) > 0
                print_result(mysql)
            end
            rc = mysql_next_result(mysql)
        end
        if rc > MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_NO_MORE_RESULTS

        command = "select p.FirstName, p.LastName, s.Skill from PersonSkills as ps inner join
        Persons as p on (ps.PersonID = p.ID) inner join Skills as s on (ps.SkillID = s.ID) order
        by p.FirstName, p.LastNAme, s.Skill;"

        rc = mysql_real_query(mysql, command)
        if rc != MYSQL_OK
            println(mysql_error(mysql))
        end
        @test rc == MYSQL_OK
        if mysql_field_count(mysql) > 0
            print_result(mysql)
        end

        mysql_close(mysql)
    end

    rc = mysql_library_init()
    @test rc == MYSQL_OK

    prepare_database()
    create_tables()
    query_tables()

    mysql_library_end()
#=
    rc = mysql_library_init()
    @test rc == MYSQL_OK

    mysql = mysql_init()
    @test mysql != C_NULL

    rc = mysql_options(mysql, MariaDB.MYSQL_OPT_COMPRESS)
    @test rc == MYSQL_OK

    connect_flags = MariaDB.CLIENT_MULTI_RESULTS | MariaDB.CLIENT_MULTI_STATEMENTS
    mysql = mysql_real_connect(mysql, "localhost", "root", flags=connect_flags)
    @test mysql != C_NULL

    client_info = mysql_get_client_info()
    println(client_info)

    client_version = mysql_get_client_version()
    println(client_version)

    charset_info = mysql_get_character_set_info(mysql)
    println(charset_info)

    host_info = mysql_get_host_info(mysql)
    println(host_info)

    proto_info = mysql_get_proto_info(mysql)
    println(proto_info)

    server_info = mysql_get_server_info(mysql)
    println(server_info)

    server_version = mysql_get_server_version(mysql)
    println(server_version)

    ssl_cipher = mysql_get_ssl_cipher(mysql)
    @test ssl_cipher == ""

    commands = "create database db_test;
    alter database db_test DEFAULT CHARACTER SET = utf8mb4;
    alter database db_test DEFAULT COLLATE = utf8mb4_unicode_ci;"
    rc = mysql_real_query(mysql, commands)
    if rc != MYSQL_OK
        print(mysql_error(mysql))
    end
    @test rc ==  MYSQL_OK

    mysql_close(mysql)
    mysql_library_end()
    =#
end
