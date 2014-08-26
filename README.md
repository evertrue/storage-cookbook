# storage-cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/storage.svg?style=flat)](https://supermarket.getchef.com/cookbooks/storage)
[![Build Status](http://img.shields.io/travis/evertrue/storage-cookbook.svg?style=flat)](https://travis-ci.org/evertrue/storage-cookbook)
[![Coverage Status](http://img.shields.io/coveralls/evertrue/storage-cookbook.svg?style=flat)](https://coveralls.io/r/evertrue/storage-cookbook)

A cookbook for mounting all available EC2 ephemeral volumes and saving their
respective mount points into node attributes.

## Supported Platforms

EC2 only (but it will fail cleanly on other platforms).

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['storage']['ephemeral_mounts']</tt></td>
    <td>Array</td>
    <td>An array of strings, set automatically by the recipe, to be used by other cookbooks, which lists the mount points of ephemeral storage devices.</td>
    <td><tt>automatic</tt></td>
  </tr>
</table>

## Usage

### storage::default

Include `storage` in a wrapper cookbook:

```ruby
include_recipe 'storage::default'
```

...or include `storage` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[storage::default]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: EverTrue, Inc. (<eric.herot@evertrue.com>)
