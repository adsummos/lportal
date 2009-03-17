require 'find'
require 'active_record'

file = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
this_dir = File.dirname(File.expand_path(file))

require File.join(this_dir,'version')

# set the migrations directory
LPORTAL_MIGRATIONS=File.expand_path(
  File.join(this_dir,'migrations')
              )

require File.join(this_dir,'lib','acts','resourceful')
# make models able to act resourceful
ActiveRecord::Base.class_eval { include Acts::Resourceful }

# Liferay portlet functionalities
require File.join(this_dir,'portlets')

# include all ruby files
Find.find(File.join(this_dir,'lib')) do |file|
  if FileTest.directory?(file)
    if File.basename(file) == "deprecated"
      Find.prune # Don't look any further into this directory.
    else
      next
    end
  else
    require file if file[/.rb$/]
  end
end

# define the schema
require File.join(this_dir,'schema')
release = Release.current
last_supported_release = 5201
Lportal::Schema.buildnumber = (release ? release.buildnumber : last_supported_release)

msg = 'Using Liferay schema build %i, version %s' % [
  Lportal::Schema.buildnumber, Lportal::Schema.version]

puts msg

defined?(RAILS_DEFAULT_LOGGER) ?
  RAILS_DEFAULT_LOGGER.info(msg) : STDOUT.puts(msg)
