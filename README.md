[![Gem Version](https://badge.fury.io/rb/chemistrykit.png)](http://badge.fury.io/rb/chemistrykit)
[![Code Climate](https://codeclimate.com/github/arrgyle/chemistrykit.png)](https://codeclimate.com/github/arrgyle/chemistrykit)

Master branch: [![Build Status](https://travis-ci.org/arrgyle/chemistrykit.png?branch=master)](https://travis-ci.org/jrobertfox/chef-broiler-platter)

Develop branch: [![Build Status](https://travis-ci.org/arrgyle/chemistrykit.png?branch=develop)](https://travis-ci.org/jrobertfox/chef-broiler-platter)

#ChemistryKit

### A simple and opinionated web testing framework for Selenium WebDriver

This framework was designed to help you get started with Selenium WebDriver quickly, to grow as needed, and to avoid common pitfalls by following convention over configuration.

ChemistryKit's inspiration comes from the Saunter Selenium framework which is available in Python and PHP. You can find more about it [here](http://element34.ca/products/saunter).

All the documentation for ChemistryKit can be found in this README, organized as follows:

- [Getting Started](#getting-started)
- [Building a Test Suite](#building-a-test-suite)
- [Configuration](#configuration)
- [Command Line Usage](#command-line-usage)
- [Contribution Guidelines](#contribution-guidelines)
- [Deployment](#deployment)

##Getting Started

    $ gem install chemistrykit
    $ ckit new framework_name

This will create a new folder with the name you provide and it will contain all of the bits you'll need to get started.

    $ cd framework_name
    $ ckit generate beaker beaker_name

This will generate a beaker file (a.k.a. test script) with the name you provide (e.g. hello_world). Add your Selenium actions and assertions to it.

    $ ckit brew

This will run ckit and execute your beakers. By default it will run the tests locally by default. But you can change where the tests run and all other relevant bits in `config.yaml` file detailed below.

##Building a Test Suite

###Spec Discovery

ChemistryKit is built on top of RSpec. All specs are in the _beaker_ directory and end in _beaker.rb. Rather than being discovered via class or file name as some systems they are by identified by tag.

```ruby
it 'with invalid credentials', :depth => 'shallow' do

end

it 'with invalid credentials', :depth => 'deep' do

end
```

All specs should have at least a :depth tag. The depth should either be 'shallow' or 'deep'. Shallow specs are the ones that are the absolute-must-pass ones. And there will only be a few of them typically. Deep ones are everything else.

You can add multiple tags as well.

```ruby
it 'with invalid credentials', :depth => 'shallow', :authentication => true do

end
```

By default ChemistryKit will discover and run the _:depth => 'shallow'_ scripts. To run different ones you use the --tag option.

    ckit brew --tag authentication

    ckit brew --tag depth:shallow --tag authentication

To exclude a tag, put a ~ in front of it.

    ckit brew --tag depth:shallow --tag ~authentication

During development it is often helpful to just run a specific beaker, this can be accomplished with the `--beakers` flag:

    ckit brew --beakers=beakers/wip_beaker.rb


###Formula Loading
Code in the `formula` directory can be used to build out page objects and helper functions to facilitate your testing. The files are loaded in a particular way:

- Files in any `lib` directory are loaded before other directories.
- Files in child directories are loaded before those in parent directories.
- Files are loaded in alphabetical order.

So for example if you have a `alpha_page.rb` file in your formulas directory that depends on a `helpers.rb` file, then you best put the `helpers.rb` file in the `lib` directory so it is loaded before the file that depends on it.

###Execution Order
Chemistry Kit executes specs in a random order. This is intentional. Knowing the order a spec will be executed in allows for dependencies between them to creep in. Sometimes unintentionally. By having them go in a random order parallelization becomes a much easier.

###Before and After
Chemistry Kit uses the 4-phase model for scripts with a chunk of code that gets run before and after each method. By default, it does nothing more than launch a browser instance that your configuration says you want. If you want to do something more than that, just add it to your spec.

```ruby
before(:each) do
    # something here
end
```

You can even nest them inside different describe/context blocks and they will get executed from the outside-in.

###Logs and CI Integration
Each run of Chemistry Kit saves logging and test output to the _evidence_ directory by default. And in there will be the full set of JUnit Ant XML files that may be consumed by your CI.

##Configuration
ChemistryKit is configured by default with a `config.yaml` file that is created for you when you scaffold out a test harness. Relevant configuration options are detailed below:

`base_url:` The base url of your app, stored to the ENV for access in your beakers and formulas.

`concurrency:` You may override the default concurrency of 1 to run the tests in parallel

`log: path:` You may override the default log path 'evidence'

`log: results_file:` You may override the default file name 'results_junit.xml'

`log: format:` You may override the default format 'junit' to an alternative like 'doc' or 'html'

`selenium_connect:` Options in this node override the defaults for the [Selenium Connect](https://github.com/arrgyle/selenium-connect) gem.
##Command Line Usage

###new
Creates a new ChemistryKit project.

Usage:

    ckit new [NAME]

###brew
Executes your test cases.

Usage:

    ckit brew [OPTIONS]

Available options for the `brew` command:

```
-a, --all                   Run every beaker regardless of tag.
-b, --beakers [BEAKERS]     Pass a list of beaker paths to be executed.
-c, --config [PATH]         Pass the path to an alternative config.yaml file.
-r, --results_file [NAME]   Specify the name of your results file.
--tag [TAGS]                Specify a list of tags to run or exclude.
--params [HASH]             Send a list of "key:value" parameters to the ENV.
```

###generate forumla
Creates a new boilerplate formula object.

Usage:

    ckit generate formula [NAME]


###generate beaker
Creates a new boilerplate beaker object.

Usage:

    ckit generate beaker [NAME]

###tags
Lists all the tags you have used in your beakers.

Usage:

    ckit tags

##Contribution Guidelines
This project conforms to the [neverstopbuilding/craftsmanship](https://github.com/neverstopbuilding/craftsmanship) guidelines. Please see them for details on:
- Branching theory
- Documentation expectations
- Release process

###It's simple

1. Create a feature branch from develop: `git checkout -b feature/myfeature develop` or `git flow feature start myfeature`
2. Do something awesome.
3. Submit a pull request.

All issues and questions related to this project should be logged using the [github issues](https://github.com/arrgyle/chemistrykit/issues) feature.

### Install Dependencies

    bundle install

### Run rake task to test code

    rake build

### Run the local version of the executable:

    ckit

##Deployment
The release process is rather automated, just use one rake task with the new version number:

    rake release_start['2.1.0']

And another to finish the release:

    rake release_finish['A helpful tag message that will be included in the gemspec.']

This handles updating the change log, committing, and tagging the release.
