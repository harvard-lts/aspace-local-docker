################################################################################
### This file shows the ArchivesSpace configuration options that are available,
### and the default value for each.
###
### Note that there is no need to uncomment these unless you plan to change the
### value from its default.
################################################################################
#
###
### This section contains the most commonly changed ArchivesSpace settings
###
#
## Set your database name and credentials here.  Example:
# AppConfig[:db_url] = "jdbc:mysql://db:3306/archivesspace?user=root&password=password&useUnicode=true&characterEncoding=UTF-8"
AppConfig[:db_url] = "jdbc:mysql://db:3306/archivesspace?useUnicode=true&characterEncoding=UTF-8&user=as&password=as123"
# AppConfig[:db_url] = "jdbc:mysql://aspace_db:3306/archivesspace?useUnicode=true&characterEncoding=UTF-8&user=as&password=as123&useSSL=false&allowPublicKeyRetrieval=true"

## Set the maximum number of database connections used by the application.
## Default is derived from the number of indexer threads.
#AppConfig[:db_max_connections] = proc { 20 + (AppConfig[:indexer_thread_count] * 2) }

# CAS
AppConfig[:omniauthCas] = {
  :full_host => '{{ site_home_url }}',
  :provider => {
    :url                  => 'https://www.pin1.harvard.edu',
    :login_url            => '/cas/login',
    :service_validate_url => '/cas/serviceValidate',
    :uid_key              => 'user',
    :host                 => 'www.pin1.harvard.edu',
    :ssl                  => true,
    },
  :frontendUidProc  => lambda { |hash| uri =  JSONModel(:user).uri_for("email/#{hash['extra']['mail']}")
                                       response = JSONModel::HTTP.post_form(uri)
                                       if response.code == '200'
                                         json = ASUtils.json_parse(response.body)
                                         json["username"]
                                       else
                                         "nope"
                                       end },
  :backendUidProc   => lambda { |hash| CasUser.fetch_username_from_email(hash['mail']) },
  :backendEmailProc => lambda { |hash| hash['mail']  },
  :logoutUrlPath    => '/cas/logout',
#       :initialUser      => {
  #        :username => '<USER_ID>',
#           :name     => '<USER-NAME',
#       },
  }

## The ArchivesSpace backend listens on port 8089 by default.  You can set it to
## something else below.
#AppConfig[:backend_url] = "http://localhost:8089"

## The ArchivesSpace staff interface listens on port 8080 by default.  You can
## set it to something else below.
#AppConfig[:frontend_url] = "http://localhost:8080"

## The ArchivesSpace public interface listens on port 8081 by default.  You can
## set it to something else below.
#AppConfig[:public_url] = "http://localhost:8081"

## The ArchivesSpace OAI server listens on port 8082 by default.  You can
## set it to something else below.
#AppConfig[:oai_url] = "http://localhost:8082"

## The ArchivesSpace Solr index listens on port 8090 by default.  You can
## set it to something else below.
AppConfig[:solr_url] = "http://solr:8983/solr/archivesspace"

## The ArchivesSpace indexer listens on port 8091 by default.  You can
## set it to something else below.
#AppConfig[:indexer_url] = "http://localhost:8091"

## The ArchivesSpace API documentation listens on port 8888 by default.  You can
## set it to something else below.
#AppConfig[:docs_url] = "http://localhost:8888"

## Logging. By default, this will be output on the screen while the archivesspace
## command is running. When running as a daemon/service, this is put into a
## file in logs/archivesspace.out. You can change this file by changing the log
## value to a filepath that archivesspace has write access to.
AppConfig[:frontend_log] = "/archivesspace/logs/frontend.log"
#AppConfig[:frontend_log] = "default"
## Log level for the frontend, values: (everything) debug, info, warn, error, fatal (severe only)
AppConfig[:frontend_log_level] = "debug"

## Log level for the backend, values: (everything) debug, info, warn, error, fatal (severe only)
#AppConfig[:backend_log] = "default"
AppConfig[:backend_log] = "/archivesspace/logs/backend.log"
AppConfig[:backend_log_level] = "info"

#AppConfig[:pui_log] = "default"
AppConfig[:pui_log] = "/archivesspace/logs/pui.log"
#AppConfig[:pui_log_level] = "debug"

#AppConfig[:indexer_log] = "default"
AppConfig[:indexer_log] = "/archivesspace/logs/indexer.log"
#AppConfig[:indexer_log_level] = "debug"

## Set to true to log all SQL statements.  Note that this will have a performance
## impact!
#AppConfig[:db_debug_log] = false
## Set to true if you have enabled MySQL binary logging
#AppConfig[:mysql_binlog] = false
#
## add default solr params, i.e. use AND for search: AppConfig[:solr_params] = { "op" => "AND" }
## Another example below sets the boost query value (bq) to boost the relevancy for the query string in the title,
## sets the phrase fields parameter (pf) to boost the relevancy for the title when the query terms are in close proximity to
## each other, and sets the phrase slop (ps) parameter for the pf parameter to indicate how close the proximity should be
##  AppConfig[:solr_params] = {
##      "bq" => proc { "title:\"#{@query_string}\"*" },
##      "pf" => 'title^10',
##      "ps" => 0,
##    }
## Configuring search operator to be AND by default - ANW-427
#AppConfig[:solr_params] = { 'op" => "AND" }
#AppConfig[:solr_params] = { "bq" => proc { "primary_type:resource^100 primary_type:accession^100 primary_type:subject^50 primary_type:agent_person^50 primary_type:agent_corporate_entity^30 primary_type:agent_family^30" } }
AppConfig[:solr_params] = { "q.op" => "AND", "bq" => proc { "primary_type:resource^100 OR primary_type:accession^100 OR primary_type:subject^50 OR primary_type:agent_person^50 OR primary_type:agent_corporate_entity^30 OR primary_type:agent_family^30" }}

## Set the application's language (see the .yml files in
## https://github.com/archivesspace/archivesspace/tree/master/common/locales for
## a list of available locale codes)
#AppConfig[:locale] = :en

## Plug-ins to load. They will load in the order specified
AppConfig[:plugins] = ['local','refid_rules', 'aspace-hvd-pui', 'request_list', 'harvard_request_list_customizations', 'aspace-jsonmodel-from-format', 'nla_accession_reports', 'aspace-ead-xform', 'aspace-event-cleanup', 'harvard_aspace_reports', 'quoted_types_fix']
#
## The number of concurrent threads available to run background jobs
## Introduced for AR-1619 - long running jobs were blocking the queue
## Resist the urge to set this to a big number!
#AppConfig[:job_thread_count] = 2
#
## OAI configuration options
#AppConfig[:oai_proxy_url] = 'http://your-public-oai-url.example.com'
# Example: 
AppConfig[:oai_ead_options] = { :include_daos => true, :use_numbered_c_tags => false, :include_uris => false }

#
###
### Other less commonly changed settings are below
###
#
#AppConfig[:default_admin_password] = "admin"
#
## NOTE: If you run ArchivesSpace using the standard scripts (archivesspace.sh,
## archivesspace.bat or as a Windows service), the value of :data_directory is
## automatically set to be the "data" directory of your ArchivesSpace
## distribution.  You don't need to change this value unless you specifically
## want ArchivesSpace to put its data files elsewhere.
##
#AppConfig[:data_directory] = File.join(Dir.home, "ArchivesSpace")
#
#AppConfig[:backup_directory] = proc { File.join(AppConfig[:data_directory], "demo_db_backups") }
#AppConfig[:solr_index_directory] = proc { File.join(AppConfig[:data_directory], "solr_index") }
#AppConfig[:solr_home_directory] = proc { File.join(AppConfig[:data_directory], "solr_home") }
#AppConfig[:solr_indexing_frequency_seconds] = 30
#AppConfig[:solr_facet_limit] = 100
#
AppConfig[:default_page_size] = 25
#AppConfig[:max_page_size] = 250
#
## A prefix added to cookies used by the application.
##
## Change this if you're running more than one instance of ArchivesSpace on the
## same hostname (i.e. multiple instances on different ports)
#AppConfig[:cookie_prefix] = "archivesspace"
#
## The periodic indexer can run using multiple threads to take advantage of
## multiple CPU cores.
##
## By setting the next two options, you can control how many CPU cores are used,
## and the amount of memory that will be consumed by the indexing process (more
## cores and/or more records per thread means more memory used).
AppConfig[:indexer_records_per_thread] = 25
AppConfig[:indexer_thread_count] = 2
AppConfig[:indexer_solr_timeout_seconds] = 800

## PUI Indexer Settings
AppConfig[:pui_indexer_enabled] = true
#AppConfig[:pui_indexing_frequency_seconds] = 30
AppConfig[:pui_indexer_records_per_thread] = 25
AppConfig[:pui_indexer_thread_count] = 1

#AppConfig[:index_state_class] = 'IndexState' # set to 'IndexStateS3' for amazon s3
## # store indexer state in amazon s3 (optional)
## # NOTE: s3 charges for read / update requests and the pui indexer is continually
## # writing to state files so you may want to increase pui_indexing_frequency_seconds
## AppConfig[:index_state_s3] = {
##   region: ENV.fetch("AWS_REGION"),
##   aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
##   aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
##   bucket: ENV.fetch("AWS_ASPACE_BUCKET"),
##   prefix: proc { "#{AppConfig[:cookie_prefix]}_" },
## }
#
#AppConfig[:allow_other_unmapped] = false
#
#AppConfig[:db_url_redacted] = proc { AppConfig[:db_url].gsub(/(user|password)=(.*?)(&|$)/, '\1=[REDACTED]\3') }
#
#
#AppConfig[:demo_db_backup_schedule] = "0 4 * * *"
#
#AppConfig[:allow_unsupported_database] = false
#AppConfig[:allow_non_utf8_mysql_database] = false
#
#AppConfig[:demo_db_backup_number_to_keep] = 7
#
## Proxy URLs
## If you are serving user-facing applications via proxy
## (i.e., another domain or port, or via https, or for a prefix) it is
## recommended that you record those URLs in your configuration
#AppConfig[:frontend_proxy_url] = proc { AppConfig[:frontend_url] }
#AppConfig[:public_proxy_url] = proc { AppConfig[:public_url] }

## Don't override _prefix or _proxy_prefix unless you know what you're doing
#AppConfig[:frontend_proxy_prefix] = proc { "#{URI(AppConfig[:frontend_proxy_url]).path}/".gsub(%r{/+$}, "/") }
#AppConfig[:public_proxy_prefix] = proc { "#{URI(AppConfig[:public_proxy_url]).path}/".gsub(%r{/+$}, "/") }

## Setting any of the four keys below to false will prevent the associated
## applications from starting. Temporarily disabling the frontend and public
## UIs and/or the indexer may help users who are running into memory-related
## issues during migration.
#
#AppConfig[:enable_backend] = true
#AppConfig[:enable_frontend] = true
#AppConfig[:enable_public] = true
AppConfig[:enable_solr] = false
# AppConfig[:enable_indexer] = true
#AppConfig[:enable_docs] = true
#AppConfig[:enable_oai] = true
#
## Some use cases want the ability to shutdown the Jetty service using Jetty's
## ShutdownHandler, which allows a POST request to a specific URI to signal
## server shutdown. The prefix for this URI path is set to /xkcd to reduce the
## possibility of a collision in the path configuration. So, full path would be
## /xkcd/shutdown?token={randomly generated password}
## The launcher creates a password to use this, which is stored
## in the data directory. This is not turned on by default.
##
#AppConfig[:use_jetty_shutdown_handler] = false
#AppConfig[:jetty_shutdown_path] = "/xkcd"
#
#
## If you have multiple instances of the backend running behind a load
## balancer, list the URL of each backend instance here.  This is used by the
## real-time indexing, which needs to connect directly to each running
## instance.
##
## By default we assume you're not using a load balancer, so we just connect
## to the regular backend URL.
##
#AppConfig[:backend_instance_urls] = proc { [AppConfig[:backend_url]] }
#
#AppConfig[:frontend_theme] = "default"
#AppConfig[:public_theme] = "default"
#
## Sessions marked as expirable will timeout after this number of seconds of inactivity
#AppConfig[:session_expire_after_seconds] = 3600
#
## Sessions marked as non-expirable will eventually expire too, but after a longer period.
#AppConfig[:session_nonexpirable_force_expire_after_seconds] = 604800
#
#AppConfig[:search_username] = "search_indexer"
#
#AppConfig[:public_username] = "public_anonymous"
#
#AppConfig[:staff_username] = "staff_system"
#
#AppConfig[:authentication_sources] = []
# When 'true' restrict authentication attempts to only the source already set for the user
# AppConfig[:authentication_restricted_by_source] = false # default: allow any source
#
#AppConfig[:realtime_index_backlog_ms] = 60000
#
#AppConfig[:notifications_backlog_ms] = 60000
#AppConfig[:notifications_poll_frequency_ms] = 1000
#
#AppConfig[:max_usernames_per_source] = 50
#
#AppConfig[:demodb_snapshot_flag] = proc { File.join(AppConfig[:data_directory], "create_demodb_snapshot.txt") }
#
## Report Configuration
## :report_page_layout uses valid values for the  CSS3 @page directive's
## size property: http://www.w3.org/TR/css3-page/#page-size-prop
#AppConfig[:report_page_layout] = "letter"
#AppConfig[:report_pdf_font_paths] = proc { ["#{AppConfig[:backend_url]}/reports/static/fonts/dejavu/DejaVuSans.ttf"] }
#AppConfig[:report_pdf_font_family] = "\"DejaVu Sans\", sans-serif"

## By default, the plugins directory will be in your ASpace Home.
## If you want to override that, update this with an absolute
## path
#AppConfig[:plugins_directory] = "plugins"

## URL to direct the feedback link
## You can remove this from the footer by making the value blank.
AppConfig[:feedback_url] = "http://nrs.harvard.edu/urn-3:hul.ois:aspace-help"

## Allow an unauthenticated user to create an account
#AppConfig[:allow_user_registration] = true

## Help Configuration
#AppConfig[:help_enabled] = true
#AppConfig[:help_url] = "http://docs.archivesspace.org"
#AppConfig[:help_topic_prefix] = "/Default_CSH.htm#"

#AppConfig[:shared_storage] = proc { File.join(AppConfig[:data_directory], "shared") }
#
## formerly known as :import_job_path
#AppConfig[:job_file_path] = proc { AppConfig.has_key?(:import_job_path) ? AppConfig[:import_job_path] : File.join(AppConfig[:shared_storage], "job_files") }
#
## this too
#AppConfig[:job_poll_seconds] = proc { AppConfig.has_key?(:import_poll_seconds) ? AppConfig[:import_poll_seconds] : 5 }
#
## and this
#AppConfig[:job_timeout_seconds] = proc { AppConfig.has_key?(:import_timeout_seconds) ? AppConfig[:import_timeout_seconds] : 300 }
#
#
## By default, only allow jobs to be cancelled if we're running against MySQL (since we can rollback)
#AppConfig[:jobs_cancelable] = proc { (AppConfig[:db_url] != AppConfig.demo_db_url).to_s }
#
#AppConfig[:max_location_range] = 1000
#
## Schema Info check
## ASpace backend will not start if the db's schema_info version is not set
## correctly for this version of ASPACE. This is to ensure that all the
## migrations have run and completed before starting the app. You can override
## this check here. Do so at your own peril.
#AppConfig[:ignore_schema_info_check] = false
#
## To use this, set an OS environment variable of ASPACE_DEMO = true
## This is the configuration variable to point to some demo data for use in testing,
## teaching, etc.
#AppConfig[:demo_data_url] = ""
AppConfig[:pui_stored_pdfs_url] = "https://s3.amazonaws.com/hadpdfs"
#
## Expose external ids in the frontend
#AppConfig[:show_external_ids] = false

# Whether to display archival record identifiers in the frontend largetree container
AppConfig[:display_identifiers_in_largetree_container] = true

#
# Allow mixed content in the title fields of resources, archival objects,
# digital objects, digital object components, and accessions
AppConfig[:allow_mixed_content_title_fields] = true
##
## This sets the allowed size of the request/response header that Jetty will accept (
## anything bigger gets a 403 error ). Note if you want to jack this size up,
## you will also have to configure your Nginx/Apache  as well if
## you're using that
#AppConfig[:jetty_response_buffer_size_bytes] = 64 * 1024
#AppConfig[:jetty_request_buffer_size_bytes] = 64 * 1024
#
## Container management configuration fields
## :container_management_barcode_length defines global and repo-level barcode validations
## (validating on length only).  Barcodes that have either no value, or a value between :min
## and :max, will validate on save.  Set global constraints via :system_default, and use
## the repo_code value for repository-level constraints.  Note that :system_default will
## always inherit down its values when possible.
##
## Example:
## AppConfig[:container_management_barcode_length] = {:system_default => {:min => 5, :max => 10}, 'repo' => {:min => 9, :max => 12}, 'other_repo' => {:min => 9, :max => 9} }
#
## :container_management_extent_calculator globally defines the behavior of the extent calculator.
## Use :report_volume (true/false) to define whether space should be reported in cubic
## or linear dimensions.
## Use :unit (:feet, :inches, :meters, :centimeters) to define the unit which the calculator
## reports extents in.
## Use :decimal_places to define how many decimal places the calculator should return.
##
## Example:
## AppConfig[:container_management_extent_calculator] = { :report_volume => true, :unit => :feet, :decimal_places => 3 }
#
## Define the fields for a record type that are inherited from ancestors
## if they don't have a value in the record itself.
## This is used in common/record_inheritance.rb and was developed to support
## the new public UI application.
## Note - any changes to record_inheritance config will require a reindex of pui
## records to take affect. To do this remove files from indexer_pui_state

AppConfig[:record_inheritance] = {
  :archival_object => {
    :inherited_fields => [
                          {
                            :property => 'title',
                            :inherit_directly => true
                          },
                          {
                            :property => 'component_id',
                            :inherit_directly => false
                          },
                          {
                            # lang_materials is new here, replacing 'lanaguage' as seen in aspace default config. Not sure yet if it's entirely correct.
                            :property => 'lang_materials',
                            :inherit_directly => true
                          },
                          {
                            :property => 'dates',
                            :inherit_directly => true
                          },
                          {
                            :property => 'extents',
                            :inherit_directly => true
                          },
                          {
                            :property => 'linked_agents',
                            :inherit_if => proc {|json| json.select {|j| j['role'] == 'creator'} },
                            :inherit_directly => false
                          },
                          {
                            :property => 'notes',
                            :inherit_if => proc {|json| json.select {|j| j['type'] == 'accessrestrict'} },
                            :inherit_directly => false
                          },
                          {
                            :property => 'notes',
                            :inherit_if => proc {|json| json.select {|j| j['type'] == 'scopecontent'} },
                            :inherit_directly => false
                          },
                          {
                            :property => 'notes',
                            :inherit_if => proc {|json| json.select {|j| j['type'] == 'langmaterial'} },
                            :inherit_directly => false
                          },
                          {
                            :property => 'notes',
                            :inherit_if => proc {|json| json.select {|j| j['type'] == 'physloc'} },
                            :inherit_directly => false
                          },
                         ]
  }
}

#
## To enable composite identifiers - added to the merged record in a property _composite_identifier
## The values for :include_level and :identifier_delimiter shown here are the defaults
## If :include_level is set to true then level values (eg Series) will be included in _composite_identifier
## The :identifier_delimiter is used when joining the four part identifier for resources
AppConfig[:record_inheritance][:archival_object][:composite_identifiers] = {
  :include_level => false,
  :identifier_delimiter => ', '
}

## To configure additional elements to be inherited use this pattern in your config
##AppConfig[:record_inheritance][:archival_object][:inherited_fields] <<
##  {
##    :property => 'linked_agents',
##    :inherit_if => proc {|json| json.select {|j| j['role'] == 'subject'} },
##    :inherit_directly => true
##  }
## ... or use this pattern to add many new elements at once
##AppConfig[:record_inheritance][:archival_object][:inherited_fields].concat(
##  [
##    {
##      :property => 'subjects',
##      :inherit_if => proc {|json|
##        json.select {|j|
##          ! j['_resolved']['terms'].select { |t| t['term_type'] == 'topical'}.empty?
##        }
##      },
##      :inherit_directly => true
##    },
##    {
##      :property => 'external_documents',
##      :inherit_directly => false
##    },
##    {
##      :property => 'rights_statements',
##      :inherit_directly => false
##    },
##    {
##      :property => 'instances',
##      :inherit_directly => false
##    },
##  ])
#
## If you want to modify any of the default rules, the safest approach is to uncomment
## the entire default record_inheritance config and make your changes.
## For example, to stop scopecontent notes from being inherited into file or item records
## uncomment the entire record_inheritance default config above, and add a skip_if
## clause to the scopecontent rule, like this:
##  {
##    :property => 'notes',
##    :skip_if => proc {|json| ['file', 'item'].include?(json['level']) },
##    :inherit_if => proc {|json| json.select {|j| j['type'] == 'scopecontent'} },
##    :inherit_directly => false
##  },
#
## PUI Configurations

AppConfig[:pui_search_results_page_size] = 25
# AppConfig[:pui_branding_img] = 'ArchivesSpaceLogo.svg'
#AppConfig[:pui_block_referrer] = true # patron privacy; blocks full 'referer' when going outside the domain
#AppConfig[:pui_enable_staff_link] = true # attempt to add a link back to the staff interface
AppConfig[:pui_enable_staff_link] = false # aspace-hvd-pui
AppConfig[:pui_feedback_link] = "http://nrs.harvard.edu/urn-3:hul.ois:archivesdiscovery"
AppConfig[:pui_help_link] = "https://guides.library.harvard.edu/hollisforarchivaldiscovery"

#
## The number of PDFs we'll generate (in the background) at the same time.
##
## PDF generation can be a little memory intensive for large collections, so we
## set this fairly low out of the box.
#AppConfig[:pui_max_concurrent_pdfs] = 2
## You can set this to nil or zero to prevent a timeout
#AppConfig[:pui_pdf_timeout] = 600
#
## The following determine which 'tabs' are on the main horizontal menu
#AppConfig[:pui_hide] = {}
#AppConfig[:pui_hide][:repositories] = false
#AppConfig[:pui_hide][:resources] = false
#AppConfig[:pui_hide][:digital_objects] = false
#AppConfig[:pui_hide][:accessions] = false
#AppConfig[:pui_hide][:subjects] = false
#AppConfig[:pui_hide][:agents] = false
#AppConfig[:pui_hide][:classifications] = false
#AppConfig[:pui_hide][:search_tab] = false
## The following determine globally whether the various "badges" appear on the Repository page
## can be overriden at repository level below (e.g.:  AppConfig[:repos][{repo_code}][:hide][:counts] = true
#AppConfig[:pui_hide][:resource_badge] = false
#AppConfig[:pui_hide][:record_badge] = true # hide by default
#AppConfig[:pui_hide][:digital_object_badge] = false
#AppConfig[:pui_hide][:accession_badge] = false
#AppConfig[:pui_hide][:subject_badge] = false
#AppConfig[:pui_hide][:agent_badge] = false
#AppConfig[:pui_hide][:classification_badge] = false
#AppConfig[:pui_hide][:counts] = false
## The following determines globally whether the 'container inventory' navigation tab/pill is hidden on resource/collection page
#AppConfig[:pui_hide][:container_inventory] = false
## Other usage examples:
## Don't display the accession ("unprocessed material") link on the main navigation menu
## AppConfig[:pui_hide][:accessions] = true
#
## the following determine when the request button is displayed
#AppConfig[:pui_requests_permitted_for_types] = [:resource, :archival_object, :accession, :digital_object, :digital_object_component]
#AppConfig[:pui_requests_permitted_for_containers_only] = false # set to 'true' if you want to disable if there is no top container
#
## Repository-specific examples.  Replace {repo_code} with your repository code, i.e. 'foo' - note the lower-case
#AppConfig[:pui_repos] = {}
## Example:
## AppConfig[:pui_repos]['foo'] = {}
## AppConfig[:pui_repos]['foo'][:requests_permitted_for_types] = [:resource, :archival_object, :accession, :digital_object, :digital_object_component] # for a particular repository, only enable requests for certain record types (Note this configuration will override AppConfig[:pui_requests_permitted_for_types] for the repository)
## AppConfig[:pui_repos]['foo'][:requests_permitted_for_containers_only] = true # for a particular repository ,disable request
## AppConfig[:pui_repos]['foo'][:request_email] = {email address} # the email address to send any repository requests
## AppConfig[:pui_repos]['foo'][:hide] = {}
## AppConfig[:pui_repos]['foo'][:hide][:counts] = true
#
#AppConfig[:pui_display_deaccessions] = true

# Whether to display archival record identifiers in the PUI collection organization tree
AppConfig[:pui_display_identifiers_in_resource_tree] = false

#
## Enable / disable PUI resource/archival object page actions
#AppConfig[:pui_page_actions_cite] = true
#AppConfig[:pui_page_actions_bookmark] = true
AppConfig[:pui_page_actions_request] = true
#AppConfig[:pui_page_actions_print] = true
#
## Add page actions via the configuration
#AppConfig[:pui_page_custom_actions] = []
## Examples:
## Javascript action example:
## AppConfig[:pui_page_custom_actions] << {
##   'record_type' => ['resource', 'archival_object'], # the jsonmodel type to show for
##   'label' => 'actions.do_something', # the I18n path for the action button
##   'icon' => 'fa-paw', # the font-awesome icon CSS class
##   'onclick_javascript' => 'alert("do something grand");',
## }
## # Hyperlink action example:
## AppConfig[:pui_page_custom_actions] << {
##   'record_type' => ['resource', 'archival_object'], # the jsonmodel type to show for
##   'label' => 'actions.do_something', # the I18n path for the action button
##   'icon' => 'fa-paw', # the font-awesome icon CSS class
##   'url_proc' => proc {|record| 'http://example.com/aspace?uri='+record.uri},
## }
## # Form-POST action example:
## AppConfig[:pui_page_custom_actions] << {
##   'record_type' => ['resource', 'archival_object'], # the jsonmodel type to show for
##   'label' => 'actions.do_something', # the I18n path for the action button
##   'icon' => 'fa-paw', # the font-awesome icon CSS class
##   # 'post_params_proc' returns a hash of params which populates a form with hidden inputs ('name' => 'value')
##   'post_params_proc' => proc {|record| {'uri' => record.uri, 'display_string' => record.display_string} },
##   # 'url_proc' returns the URL for the form to POST to
##   'url_proc' => proc {|record| 'http://example.com/aspace?uri='+record.uri},
##   # 'form_id' as string to be used as the form's ID
##   'form_id' => 'my_grand_action',
## }
## # ERB action example:
## AppConfig[:pui_page_custom_actions] << {
##   'record_type' => ['resource', 'archival_object'], # the jsonmodel type to show for
##   # 'erb_partial' returns the path to an erb template from which the action will be rendered
##   'erb_partial' => 'shared/my_special_action',
## }
#
## PUI email settings (logs emails when disabled)
AppConfig[:pui_email_enabled] = false

#
## See above AppConfig[:pui_repos][{repo_code}][:request_email] for setting repository email overrides
## 'pui_email_override' for testing, this email will be the to-address for all sent emails
## AppConfig[:pui_email_override] = 'testing@example.com'
## 'pui_request_email_fallback_to_address' the 'to' email address for repositories that don't define their own email
##AppConfig[:pui_request_email_fallback_to_address] = 'testing@example.com'
## 'pui_request_email_fallback_from_address' the 'from' email address for repositories that don't define their own email
##AppConfig[:pui_request_email_fallback_from_address] = 'testing@example.com'
#
## use the repository record email address for requests (overrides config email)
#AppConfig[:pui_request_use_repo_email] = false
#
## Example sendmail configuration:
AppConfig[:global_email_from_address] = "aspace@noreply.harvard.edu"
# AppConfig[:email_delivery_method] = :sendmail
# AppConfig[:email_sendmail_settings] = {
#AppConfig[:email_perform_deliveries] = true
#AppConfig[:email_raise_delivery_errors] = true
#AppConfig[:email_delivery_method] = :smtp
#AppConfig[:email_smtp_settings] = {
#AppConfig[:email_perform_deliveries] = true
#AppConfig[:email_raise_delivery_errors] = true
#
##The number of characters to truncate before showing the 'Read More' link on notes
#AppConfig[:pui_readmore_max_characters] = 450
AppConfig[:refid_rule] = "<%= eadid %>c<%= paddedseq %>"

# **** Special keys required for the pui to directly query solr ****
# IS THIS CORRECT???
AppConfig[:pui_solr_host] = "http://solr:8983"
AppConfig[:pui_solr_select] = "/solr/archivesspace/select"
# aspace-hvd-pui: **** id.lib host (different for pointing to dev, qa versions of idtest
AppConfig[:pui_perma] = 'https://id.lib.harvard.edu'

AppConfig[:max_boolean_queries] = 1024
AppConfig[:record_inheritance_resolves] = [
  'ancestors',
  'ancestors::linked_agents',
  'ancestors::subjects',
  'ancestors::instances::sub_container::top_container',
]

AppConfig[:pui_expand_all] = true
AppConfig[:pui_display_facets_alpha] = false
# Resolving linked events can have a big impact on performance. If the number of linked events surpasses the max then the events will not be resolved and a more abridged
# record will be displayed to keep memory usage under control as the no. of events grows
AppConfig[:max_linked_events_to_resolve] = 100
# Prior to 3.2.0, multiple ARKs may have been created without the user intending to do so. Setting this to true will make
# database upgrade 158 attempt to clean up unwanted extra ARKs. When multiple rows in the ARK table reference the same resource
# or archival object, the first one created will be kept and the rest discarded.  Use with caution and test thoroughly.
AppConfig[:prune_ark_name_table] = false
# If the PUI is enabled, add resource finding aid URLs to MARC exports
AppConfig[:include_pui_finding_aid_urls_in_marc_exports] = false
# If enabled, use slugs instead of URIs in finding aid links (856 $u)
AppConfig[:use_slug_finding_aid_urls_in_marc_exports] = false

# Enables Language Selection in PUI
AppConfig[:allow_pui_language_selection] = false
# How repositories should be sorted in the PUI. Options are :display_string or :position
AppConfig[:pui_repositories_sort] = :display_string

# ARK Changes. TODO: What is Ark??
AppConfig[:ark_minter] = :archivesspace_ark_minter
AppConfig[:ark_enable_repository_shoulder] = false
AppConfig[:ark_shoulder_delimiter] = ''

## AEON STUFF!!
AppConfig[:request_list] = {
  :button_position => 0,
  :record_types => ['archival_object', 'resource', 'top_container'],
  :item_limit => 20,
  :pdf_filename => 'HOLLISForArchivalDiscoveryList.pdf',

  :request_handlers => {
    :harvard_test_aeon => {
      :name => 'Harvard Test Aeon',
      :profile => :harvard_aeon,
      :url => 'https://aeontest.hul.harvard.edu/logon',
      :list_opts => {
        :return_link_label => 'Return to HOLLIS',
        :form_target => 'harvard-library-requests',
        :aeon_link_url => 'https://aeontest.hul.harvard.edu/logon',
        :request_types => {
          'Reading room' => {
            'RequestType' => 'Loan',
            'UserReview' => 'No',
            'SkipOrderEstimate' => ''
          },
          'Copy' => {
            'RequestType' => 'Copy',
            'UserReview' => 'No',
            'SkipOrderEstimate' => 'Yes',
          },
          'Save for Later' => {
            'RequestType' => 'Loan',
            'UserReview' => 'Yes',
            'SkipOrderEstimate' => '',
          }
        },
        :format_options => [
                              'Reference copy',
                              'Publication-quality copy',
                              'Print',
                              'Existing digital file',
                              'Other'
                            ],
        :delivery_options => [
                              'Campus Pickup',
                              'Mail',
                              'Online Delivery'
                             ]
      }                       
    }
  },

  :repositories => {
    :default => {
      :handler => :harvard_test_aeon,
      :opts => {
        :return_link_label => 'Return to HOLLIS'
      }
    },
    'arn' => {
      :item_opts => {
        :repo_fields => {
          'Site' => 'HUH'
        }
      }
    },
    'ecb' => {
      :item_opts => {
        :repo_fields => {
          'Site' => 'HUH'
        }
      }
    },
    'far' => {
      :item_opts => {
        :repo_fields => {
          'Site' => 'HUH'
        }
      }
    },
    'hfa' => {
      :item_opts => {
        :repo_fields => {
          'Site' => 'HOU'
        }
      }
    },
    'orc' => {
      :item_opts => {
        :repo_fields => {
          'Site' => 'HUH',
          'Location' => 'HUH'
        }
      }
    },
    'gra' => {
      :item_opts => {
        :repo_fields => {
          'Site' => 'HUH'
        }
      }
    },
    'art' => {
      :handler => :none,
    },
    'ddo' => {
      :handler => :none,
    },
    'env' => {
      :handler => :none,
    },
    'hsi' => {
      :handler => :none,
    },
    'ora' => {
      :handler => :none,
    },
    'pea' => {
      :handler => :none,
    },
    'uri' => {
      :handler => :none,
    },
    'wid' => {
      :handler => :none,
    },
  }
}

##### NEW CONFIG FROM 3.0.2 UPGRADE: ######
# aspace_jsonmodel_from_format:
AppConfig[:agent_records_default_publish] = false

# Set default/active tab for PUI citation modal. If set to 'true' item citation
# tab will be active by default; if 'false' item description tab will be active.
# AppConfig[:pui_page_actions_cite] must be set to true for this to take effect.
AppConfig[:pui_active_citation_tab_item] = false

AppConfig[:db_pool_timeout] = 5 # number of seconds to wait before raising a PoolTimeout error

# Set the font used to generate PDFs in the PUI
AppConfig[:pui_pdf_font_files] = ["KurintoText-Rg.ttf",
                                  "KurintoText-Bd.ttf",
                                  "KurintoText-It.ttf",
                                  "KurintoTextJP-Rg.ttf",
                                  "KurintoTextJP-Bd.ttf",
                                  "KurintoTextJP-It.ttf",
                                  "KurintoTextKR-Rg.ttf",
                                  "KurintoTextKR-Bd.ttf",
                                  "KurintoTextKR-It.ttf",
                                  "KurintoTextSC-Rg.ttf",
                                  "KurintoTextSC-Bd.ttf",
                                  "KurintoTextSC-It.ttf",
                                  "NotoSerif-Regular.ttf",
                                  "NotoSerif-Bold.ttf",
                                  "NotoSerif-Italic.ttf"]
AppConfig[:pui_pdf_font_name] = "Kurinto Text,Kurinto Text JP,Kurinto Text KR,Kurinto Text SC,Noto Serif"
AppConfig[:pui_pdf_paragraph_line_height] = "125%"
AppConfig[:pui_pdf_title_line_height] = "140%"
AppConfig[:solr_verify_checksums] = false
# Password recovery - requires email configuration
AppConfig[:allow_password_reset] = false
