Gem::Specification.new do |s|
  s.name = %q{activerecord}
  s.version = "1.15.3"
  s.date = %q{2007-03-13}
  s.summary = %q{Implements the ActiveRecord pattern for ORM.}
  s.email = %q{david@loudthinking.com}
  s.homepage = %q{http://www.rubyonrails.org}
  s.rubyforge_project = %q{activerecord}
  s.description = %q{Implements the ActiveRecord pattern (Fowler, PoEAA) for ORM. It ties database tables and classes together for business objects, like Customer or Subscription, that can find, save, and destroy themselves without resorting to manual SQL.}
  s.autorequire = %q{active_record}
  s.has_rdoc = true
  s.authors = ["David Heinemeier Hansson"]
  s.files = ["Rakefile", "install.rb", "README", "RUNNING_UNIT_TESTS", "CHANGELOG", "lib/active_record", "lib/active_record.rb", "lib/active_record/acts", "lib/active_record/aggregations.rb", "lib/active_record/associations", "lib/active_record/associations.rb", "lib/active_record/attribute_methods.rb", "lib/active_record/base.rb", "lib/active_record/calculations.rb", "lib/active_record/callbacks.rb", "lib/active_record/connection_adapters", "lib/active_record/deprecated_associations.rb", "lib/active_record/deprecated_finders.rb", "lib/active_record/fixtures.rb", "lib/active_record/locking", "lib/active_record/migration.rb", "lib/active_record/observer.rb", "lib/active_record/query_cache.rb", "lib/active_record/reflection.rb", "lib/active_record/schema.rb", "lib/active_record/schema_dumper.rb", "lib/active_record/timestamp.rb", "lib/active_record/transactions.rb", "lib/active_record/validations.rb", "lib/active_record/vendor", "lib/active_record/version.rb", "lib/active_record/wrappers", "lib/active_record/wrappings.rb", "lib/active_record/xml_serialization.rb", "lib/active_record/acts/list.rb", "lib/active_record/acts/nested_set.rb", "lib/active_record/acts/tree.rb", "lib/active_record/associations/association_collection.rb", "lib/active_record/associations/association_proxy.rb", "lib/active_record/associations/belongs_to_association.rb", "lib/active_record/associations/belongs_to_polymorphic_association.rb", "lib/active_record/associations/has_and_belongs_to_many_association.rb", "lib/active_record/associations/has_many_association.rb", "lib/active_record/associations/has_many_through_association.rb", "lib/active_record/associations/has_one_association.rb", "lib/active_record/connection_adapters/abstract", "lib/active_record/connection_adapters/abstract_adapter.rb", "lib/active_record/connection_adapters/db2_adapter.rb", "lib/active_record/connection_adapters/firebird_adapter.rb", "lib/active_record/connection_adapters/frontbase_adapter.rb", "lib/active_record/connection_adapters/mysql_adapter.rb", "lib/active_record/connection_adapters/openbase_adapter.rb", "lib/active_record/connection_adapters/oracle_adapter.rb", "lib/active_record/connection_adapters/postgresql_adapter.rb", "lib/active_record/connection_adapters/sqlite_adapter.rb", "lib/active_record/connection_adapters/sqlserver_adapter.rb", "lib/active_record/connection_adapters/sybase_adapter.rb", "lib/active_record/connection_adapters/abstract/connection_specification.rb", "lib/active_record/connection_adapters/abstract/database_statements.rb", "lib/active_record/connection_adapters/abstract/quoting.rb", "lib/active_record/connection_adapters/abstract/schema_definitions.rb", "lib/active_record/connection_adapters/abstract/schema_statements.rb", "lib/active_record/locking/optimistic.rb", "lib/active_record/locking/pessimistic.rb", "lib/active_record/vendor/db2.rb", "lib/active_record/vendor/mysql.rb", "lib/active_record/vendor/simple.rb", "lib/active_record/wrappers/yaml_wrapper.rb", "test/aaa_create_tables_test.rb", "test/abstract_unit.rb", "test/active_schema_test_mysql.rb", "test/adapter_test.rb", "test/adapter_test_sqlserver.rb", "test/aggregations_test.rb", "test/all.sh", "test/ar_schema_test.rb", "test/association_inheritance_reload.rb", "test/associations", "test/associations_test.rb", "test/attribute_methods_test.rb", "test/base_test.rb", "test/binary_test.rb", "test/calculations_test.rb", "test/callbacks_test.rb", "test/class_inheritable_attributes_test.rb", "test/column_alias_test.rb", "test/connection_test_firebird.rb", "test/connections", "test/copy_table_sqlite.rb", "test/datatype_test_postgresql.rb", "test/default_test_firebird.rb", "test/defaults_test.rb", "test/deprecated_associations_test.rb", "test/deprecated_finder_test.rb", "test/empty_date_time_test.rb", "test/finder_test.rb", "test/fixtures", "test/fixtures_test.rb", "test/inheritance_test.rb", "test/lifecycle_test.rb", "test/locking_test.rb", "test/method_scoping_test.rb", "test/migration_test.rb", "test/migration_test_firebird.rb", "test/mixin_nested_set_test.rb", "test/mixin_test.rb", "test/modules_test.rb", "test/multiple_db_test.rb", "test/pk_test.rb", "test/readonly_test.rb", "test/reflection_test.rb", "test/schema_authorization_test_postgresql.rb", "test/schema_dumper_test.rb", "test/schema_test_postgresql.rb", "test/synonym_test_oracle.rb", "test/table_name_test_sqlserver.rb", "test/threaded_connections_test.rb", "test/transactions_test.rb", "test/unconnected_test.rb", "test/validations_test.rb", "test/xml_serialization_test.rb", "test/associations/callbacks_test.rb", "test/associations/cascaded_eager_loading_test.rb", "test/associations/eager_test.rb", "test/associations/extension_test.rb", "test/associations/join_model_test.rb", "test/connections/native_db2", "test/connections/native_firebird", "test/connections/native_frontbase", "test/connections/native_mysql", "test/connections/native_openbase", "test/connections/native_oracle", "test/connections/native_postgresql", "test/connections/native_sqlite", "test/connections/native_sqlite3", "test/connections/native_sqlserver", "test/connections/native_sqlserver_odbc", "test/connections/native_sybase", "test/connections/native_db2/connection.rb", "test/connections/native_firebird/connection.rb", "test/connections/native_frontbase/connection.rb", "test/connections/native_mysql/connection.rb", "test/connections/native_openbase/connection.rb", "test/connections/native_oracle/connection.rb", "test/connections/native_postgresql/connection.rb", "test/connections/native_sqlite/connection.rb", "test/connections/native_sqlite3/connection.rb", "test/connections/native_sqlite3/in_memory_connection.rb", "test/connections/native_sqlserver/connection.rb", "test/connections/native_sqlserver_odbc/connection.rb", "test/connections/native_sybase/connection.rb", "test/fixtures/accounts.yml", "test/fixtures/author.rb", "test/fixtures/author_favorites.yml", "test/fixtures/authors.yml", "test/fixtures/auto_id.rb", "test/fixtures/bad_fixtures", "test/fixtures/binary.rb", "test/fixtures/categories", "test/fixtures/categories.yml", "test/fixtures/categories_ordered.yml", "test/fixtures/categories_posts.yml", "test/fixtures/categorization.rb", "test/fixtures/categorizations.yml", "test/fixtures/category.rb", "test/fixtures/column_name.rb", "test/fixtures/comment.rb", "test/fixtures/comments.yml", "test/fixtures/companies.yml", "test/fixtures/company.rb", "test/fixtures/company_in_module.rb", "test/fixtures/computer.rb", "test/fixtures/computers.yml", "test/fixtures/course.rb", "test/fixtures/courses.yml", "test/fixtures/customer.rb", "test/fixtures/customers.yml", "test/fixtures/db_definitions", "test/fixtures/default.rb", "test/fixtures/developer.rb", "test/fixtures/developers.yml", "test/fixtures/developers_projects", "test/fixtures/developers_projects.yml", "test/fixtures/edge.rb", "test/fixtures/edges.yml", "test/fixtures/entrant.rb", "test/fixtures/entrants.yml", "test/fixtures/fk_test_has_fk.yml", "test/fixtures/fk_test_has_pk.yml", "test/fixtures/flowers.jpg", "test/fixtures/funny_jokes.yml", "test/fixtures/joke.rb", "test/fixtures/keyboard.rb", "test/fixtures/legacy_thing.rb", "test/fixtures/legacy_things.yml", "test/fixtures/migrations", "test/fixtures/migrations_with_decimal", "test/fixtures/migrations_with_duplicate", "test/fixtures/migrations_with_missing_versions", "test/fixtures/mixed_case_monkey.rb", "test/fixtures/mixed_case_monkeys.yml", "test/fixtures/mixin.rb", "test/fixtures/mixins.yml", "test/fixtures/movie.rb", "test/fixtures/movies.yml", "test/fixtures/naked", "test/fixtures/order.rb", "test/fixtures/people.yml", "test/fixtures/person.rb", "test/fixtures/post.rb", "test/fixtures/posts.yml", "test/fixtures/project.rb", "test/fixtures/projects.yml", "test/fixtures/reader.rb", "test/fixtures/readers.yml", "test/fixtures/reply.rb", "test/fixtures/subject.rb", "test/fixtures/subscriber.rb", "test/fixtures/subscribers", "test/fixtures/tag.rb", "test/fixtures/tagging.rb", "test/fixtures/taggings.yml", "test/fixtures/tags.yml", "test/fixtures/task.rb", "test/fixtures/tasks.yml", "test/fixtures/topic.rb", "test/fixtures/topics.yml", "test/fixtures/vertex.rb", "test/fixtures/vertices.yml", "test/fixtures/bad_fixtures/attr_with_numeric_first_char", "test/fixtures/bad_fixtures/attr_with_spaces", "test/fixtures/bad_fixtures/blank_line", "test/fixtures/bad_fixtures/duplicate_attributes", "test/fixtures/bad_fixtures/missing_value", "test/fixtures/categories/special_categories.yml", "test/fixtures/categories/subsubdir", "test/fixtures/categories/subsubdir/arbitrary_filename.yml", "test/fixtures/db_definitions/db2.drop.sql", "test/fixtures/db_definitions/db2.sql", "test/fixtures/db_definitions/db22.drop.sql", "test/fixtures/db_definitions/db22.sql", "test/fixtures/db_definitions/firebird.drop.sql", "test/fixtures/db_definitions/firebird.sql", "test/fixtures/db_definitions/firebird2.drop.sql", "test/fixtures/db_definitions/firebird2.sql", "test/fixtures/db_definitions/frontbase.drop.sql", "test/fixtures/db_definitions/frontbase.sql", "test/fixtures/db_definitions/frontbase2.drop.sql", "test/fixtures/db_definitions/frontbase2.sql", "test/fixtures/db_definitions/mysql.drop.sql", "test/fixtures/db_definitions/mysql.sql", "test/fixtures/db_definitions/mysql2.drop.sql", "test/fixtures/db_definitions/mysql2.sql", "test/fixtures/db_definitions/openbase.drop.sql", "test/fixtures/db_definitions/openbase.sql", "test/fixtures/db_definitions/openbase2.drop.sql", "test/fixtures/db_definitions/openbase2.sql", "test/fixtures/db_definitions/oracle.drop.sql", "test/fixtures/db_definitions/oracle.sql", "test/fixtures/db_definitions/oracle2.drop.sql", "test/fixtures/db_definitions/oracle2.sql", "test/fixtures/db_definitions/postgresql.drop.sql", "test/fixtures/db_definitions/postgresql.sql", "test/fixtures/db_definitions/postgresql2.drop.sql", "test/fixtures/db_definitions/postgresql2.sql", "test/fixtures/db_definitions/schema.rb", "test/fixtures/db_definitions/sqlite.drop.sql", "test/fixtures/db_definitions/sqlite.sql", "test/fixtures/db_definitions/sqlite2.drop.sql", "test/fixtures/db_definitions/sqlite2.sql", "test/fixtures/db_definitions/sqlserver.drop.sql", "test/fixtures/db_definitions/sqlserver.sql", "test/fixtures/db_definitions/sqlserver2.drop.sql", "test/fixtures/db_definitions/sqlserver2.sql", "test/fixtures/db_definitions/sybase.drop.sql", "test/fixtures/db_definitions/sybase.sql", "test/fixtures/db_definitions/sybase2.drop.sql", "test/fixtures/db_definitions/sybase2.sql", "test/fixtures/developers_projects/david_action_controller", "test/fixtures/developers_projects/david_active_record", "test/fixtures/developers_projects/jamis_active_record", "test/fixtures/migrations/1_people_have_last_names.rb", "test/fixtures/migrations/2_we_need_reminders.rb", "test/fixtures/migrations/3_innocent_jointable.rb", "test/fixtures/migrations_with_decimal/1_give_me_big_numbers.rb", "test/fixtures/migrations_with_duplicate/1_people_have_last_names.rb", "test/fixtures/migrations_with_duplicate/2_we_need_reminders.rb", "test/fixtures/migrations_with_duplicate/3_foo.rb", "test/fixtures/migrations_with_duplicate/3_innocent_jointable.rb", "test/fixtures/migrations_with_missing_versions/1000_people_have_middle_names.rb", "test/fixtures/migrations_with_missing_versions/1_people_have_last_names.rb", "test/fixtures/migrations_with_missing_versions/3_we_need_reminders.rb", "test/fixtures/migrations_with_missing_versions/4_innocent_jointable.rb", "test/fixtures/naked/csv", "test/fixtures/naked/yml", "test/fixtures/naked/csv/accounts.csv", "test/fixtures/naked/yml/accounts.yml", "test/fixtures/naked/yml/companies.yml", "test/fixtures/naked/yml/courses.yml", "test/fixtures/subscribers/first", "test/fixtures/subscribers/second", "examples/associations.png", "examples/associations.rb", "examples/shared_setup.rb", "examples/validation.rb"]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  s.add_dependency(%q<activesupport>, ["= 1.4.2"])
end
