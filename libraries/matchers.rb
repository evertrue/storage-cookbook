if defined?(ChefSpec)
  def run_storage_format_mount(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(resource, action, resource_name)
  end
end
