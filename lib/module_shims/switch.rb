module ModuleShims
  module Switch
    def enable_shim(shadow_target = true)
      insert_shim unless @inserted
      target_const.prefix_existing_instance_methods('__module_switch', self) if shadow_target
      shim_const.copy_existing_instance_methods(self)
    end

    def disable_shim
      target_const.prefix_existing_instance_methods('__module_switch', self, true)
      target_const.remove_instance_methods_from_ancestors("#{name}::SHIM")
    end

    def insert_shim
      @inserted ||=
        begin
          target_const.send(:prepend, shim_const)
          true
        end
    end

    def shim_const
      return const_get('SHIM') if const_defined?('SHIM')

      # use predefined_method to look up SHIM module. It's to support "reload!" in rails console
      predefined_method = "#{self.name.downcase.gsub(/::/, '_')}_shim"
      existing_shim = target_const.ancestors.find { |anc| anc.respond_to? predefined_method }

      unless existing_shim
        existing_shim = Module.new
        existing_shim.singleton_class.send(:define_method, predefined_method) {}
      end
      const_set('SHIM', existing_shim)
    end

    def target_const
      @target ||= default_target
    end

    def target_const=(target = default_target)
      @target = target
    end

    def default_target
      const_get(name.gsub(/\A[^:]*/, ''))
    end
  end
end