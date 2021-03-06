require 'thor'

module CloudConductorCli
  class Client < Thor
    register Models::Account, 'account', 'account', 'Subcommand to manage accounts'
    register Models::Project, 'project', 'project', 'Subcommand to manage projects'
    register Models::Cloud, 'cloud', 'cloud', 'Subcommand to manage clouds'
    register Models::BaseImage, 'base_image', 'base_image', 'Subcommand to manage base_image'
    register Models::Blueprint, 'blueprint', 'blueprint', 'Subcommand to manage blueprints'
    register Models::System, 'system', 'system', 'Subcommand to manage systems'
    register Models::Environment, 'environment', 'environment', 'Subcommand to manage environments'
    register Models::Application, 'application', 'application', 'Subcommand to manage applications'

    desc 'version', 'Show version number'
    def version
      puts "CloudConductor CLI Version #{VERSION}"
    end
    map %w(-v --version) => :version
  end
end
