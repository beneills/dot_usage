# dot_usage

_a file format and utility to control building, running and testing source code_

1) __Define__ some targets for your project either explicitly, or by pointing to existing documentation:

```yaml
# .usage.yml

install:
  - gem install dot_usage

test:
  - rake test

help:
  README.md: "## Getting Help"
```

2) Then your users can safely __execute__ the targets:

```shell
$ gem install dot_usage

$ cd my_project && ls -a
.usage.yml ...

$ dot_usage install
Installing dot_usage (guided)
> Run `gem install dot_usage` [Y/n]? y
Successfully installed.
```

## Rationale

We present a single interface for users to interact with your repository, without learning/remembering incantations for twenty different build systems.  This makes is quicker for them to get started using or contributing.

## Features

*dot_usage* allows project maintainers to easily communicate how to interact with a repository, in a way that a machine can understand.  This can be used to supplement the usual human-readable instructions in _README.md_.  Crucially, we permit linking to code snippets in Markdown documents, meaning no code duplication.

We allow arbitrary targets, but recommend using __install__, __build__, __test__, and __help__.

### Target Recipes
```yaml
# Define recipes as a list of shell commands
target-one:
  - echo "command one"
  - echo "command two"

# Or as a link to a Markdown section with a single code snippet
target-two:
  README.md: "### Doing thing two"
```

### Guided Invocation
```shell
# Prompt before every command
$ dot_usage install
Installing dot_usage (guided)
> Run `gem install dot_usage` [Y/n]? y
Successfully installed.

# Or run them blindly
$ dot_usage install -y
Installing dot_usage (guided)
> Running `gem install dot_usage`
Successfully installed.
```

### Listing Targets
```
# Run with -v for full command listing
$ dot_usage
Available targets:
 - install
 - test
 - help
```

### Generating a dotfile
```
$ cd my_project
$ dot_usage
Generated .usage.yml
```

## Getting Help

```shell
dot_usage -h
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beneills/dot_usage.
