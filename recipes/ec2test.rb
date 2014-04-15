directory '/etc/chef/ohai/hints' do
  action :nothing
  recursive true
end.run_action(:create)

file '/etc/chef/ohai/hints/ec2.json' do
  content JSON.pretty_generate({})
  action :nothing
end.run_action(:create)

ohai 'ec2_hints' do
  action :nothing
end.run_action(:reload)
