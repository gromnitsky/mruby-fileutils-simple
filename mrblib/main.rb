module FileUtilsSimple

  module Commands
    # Those are non-destructive & can be run always.
    NOOP_IGNORE = [
                   :pwd,
                   :cd,
                  ]

    def self.pwd
      Dir.pwd
    end

    def self.cd dir, &block
      Dir.chdir dir, &block
    end

    def self.touch *list
      list.each do |file|
        system "touch #{file}"
      end
    end

  end

  module Delegator
    class << self
      attr_accessor :stdout
    end
    Delegator.stdout = $stdout

    def self.wrap opt, name, *args, &block
      if args.last.is_a? Hash
        args = args[0..-2]
      end

      args.map! {|idx| idx.to_s.shellescape }
      Delegator.stdout.puts "#{name} #{args.join ', '}" if opt[:verbose]
      return if opt[:noop] && !Commands::NOOP_IGNORE.index(name)

      Commands.send name, *args, &block
    end
  end

  # Generate singleton methods
  Commands.methods(false).each do |name|
    module_eval do
      define_method(name) do |*args, &block|
        opt = args.last.is_a?(Hash) ? args.last : {}
        Delegator.wrap(opt, name, *args, &block)
      end

      module_function name
    end
  end

end



# Do you see a pattern here?

module FileUtilsSimple

  module DryRun
    FileUtilsSimple::Commands.methods(false).each do |name|
      module_eval do
        define_method(name) do |*args, &block|
          opt = {
            verbose: true,
            noop: true,
          }
          FileUtilsSimple::Delegator.wrap(opt, name, *args, &block)
        end

        module_function name
      end
    end
  end

end
