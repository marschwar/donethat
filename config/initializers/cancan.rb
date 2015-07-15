# adds support for load_resource with friendly_id
if defined?(CanCan)
  class Object
    def metaclass
      class << self; self; end
      end
  end

  module CanCan
    module ModelAdapters
      class AbstractAdapter
        @@friendly_support = {}

        def self.find(model_class, id)
          Rails.logger.debug "Lookup for #{model_class} and #{id}"
          @@friendly_support[model_class] ||= model_class.respond_to?(:friendly)
          Rails.logger.debug "model_class = #{model_class} == #{@@friendly_support[model_class]}"
          @@friendly_support[model_class] == true ? model_class.friendly.find(id) : model_class.find(id)
        end
      end
    end

    # see https://github.com/ryanb/cancan/issues/835
    # class ControllerResource
    #   alias_method :original_resource_params_by_namespaced, :resource_params_by_namespaced_name

    #   def resource_params_by_namespaced_name
    #     if (@controller && @params && @params[:action] == "create")
    #       strong_params =  @controller.method("#{namespaced_name.name.downcase}_params".to_sym)
    #       params = strong_params.call if defined? strong_params
    #     end
    #     params ||=  original_resource_params_by_namespaced
    #   end
    # end
  end
end