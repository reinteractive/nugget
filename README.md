Nugget
================

Nugget is a minimal gem structure for all those peeps that want to
get a kickstart on creating a gem without going to the hassle
of using the gem authoring tools out there.

"Out of the box", nugget will give you the basic directory structure
for a gem file, with a gemspec and a spec suite to start testing.

Where you go from there is up to you :)

Usage
----------------

    $ bash < <(curl -s git://github.com/rubyx/nugget/raw/master/install.sh)

You will be asked for the gem name of your gem which must be a valid ruby
variable name, for example:

    my_gem            # <= OK
    supergem          # <= OK
    Super Awesome Gem # <= not this, kittehs will die

You will also need the read write SSH git repository URL of your gem, such as:

    git@github.com:mikel/nugget.git

Nugget will then build a basic gem folder structure using RSpec for you and setup
everything you need to start writing failing specs.

Writing a Gem
----------------

First things first, fill in the README in your new gem and commit the changes, see
(README Driven Development)[http://tom.preston-werner.com/2010/08/23/readme-driven-development.html] by
Tom Preston-Werner for more info.  Once done, push your changes, congrats :)

Write your specs and write your code.

Once done, use the standard gem tools to deploy:

    $ vi lib/<yourgem>/version.rb   # Edit to suit
    $ git tag v0.0.1
    $ git push
    $ git push --tags
    $ gem build <yourgem>.gemspec
    $ gem push <yourgem>.gemspec

And you are done.


Enjoy.