#

node 'default' {
  include oradb_12c
}

# operating system settings for Database
class oradb_12c {

    oradb::database{ 'oraDb':
      oracle_base               => '/oracle',
      oracle_home               => '/oracle/product/12.1/db',
      version                   => '12.1',
      user                      => 'oracle',
      group                     => 'dba',
      download_dir              => "/var/tmp/install",
      action                    => 'create',
      db_name                   => 'soa',
      db_domain                 => 'avioconsulting.com',
      sys_password              => 'oracle',
      system_password           => 'oracle',
      data_file_destination     => "/oracle/oradata",
      recovery_area_destination => "/oracle/flash_recovery_area",
      character_set             => "AL32UTF8",
      nationalcharacter_set     => "UTF8",
      init_params               => "open_cursors=1000,processes=1000,sessions=1000,job_queue_processes=2,sga_target=1000M",
      sample_schema             => 'TRUE',
      memory_percentage         => "40",
      memory_total              => "800",
      database_type             => "MULTIPURPOSE",
      require                   => Oradb::Listener['start listener'],
    }

    oradb::dbactions{ 'start oraDb':
      oracle_home             => '/oracle/product/12.1/db',
      user                    => 'oracle',
      group                   => 'dba',
      action                  => 'start',
      db_name                 => 'orcl',
      require                 => Oradb::Database['oraDb'],
    }

    oradb::autostartdatabase{ 'autostart oracle':
      oracle_home             => '/oracle/product/12.1/db',
      user                    => 'oracle',
      db_name                 => 'soa',
      require                 => Oradb::Dbactions['start oraDb'],
    }

