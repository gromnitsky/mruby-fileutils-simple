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
      system "touch #{list.join ' '}"
    end

    def self.install src, dest, mode = 755
      dir = dest[-1] == '/' ? dest : File.dirname(dest)
      system "mkdir -p #{dir}"
      system "install -p -m #{mode} #{src} #{dest}"
    end

    def self.mkdir *list
      system "mkdir -p #{list.join ' '}"
    end
    singleton_class.send(:alias_method, :mkdir_p, :mkdir)

    def self.rmdir *list
      system "rmdir #{list.join ' '}"
    end

    def self.rm_rf *list
      system "rm -rf #{list.join ' '}"
    end
    singleton_class.send(:alias_method, :rm_r, :rm_rf)

    def self.ln_f *src, dest
      system "ln -f #{src.join ' '} #{dest}"
    end
    singleton_class.send(:alias_method, :ln, :ln_f)

    def self.ln_sf *src, dest
      system "ln -fs #{src.join ' '} #{dest}"
    end
    singleton_class.send(:alias_method, :ln_s, :ln_sf)

    def self.cp_r *src, dest
      system "cp -rp #{src.join ' '} #{dest}"
    end
    singleton_class.send(:alias_method, :cp, :cp_r)

    def self.mv *src, dest
      system "mv #{src.join ' '} #{dest}"
    end

    def self.chmod mode, *list
      system "chmod #{mode} #{list.join ' '}"
    end

    def self.chmod_R mode, *list
      system "chmod -R #{mode} #{list.join ' '}"
    end

    def self.chown user, group, *list
      system "chown #{user}:#{group} #{list.join ' '}"
    end

    def self.chown_R user, group, *list
      system "chown -R #{user}:#{group} #{list.join ' '}"
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
