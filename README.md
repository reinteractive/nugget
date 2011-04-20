Nugget
================

Nugget is a minimal gem structure for all those peeps that want to
get a kickstart on creating a gem without having a development or
test dependency on external tools like hoe, jeweller or the like.

"Out of the box", nugget will give you the basic directory structure
for a gem file, with a gemspec and a spec suite to start testing.

Where you go from there is up to you :)

Usage
----------------

    $ ruby -s <(curl -s https://github.com/rubyx/nugget/raw/master/install.rb)

You will be asked for the following:

* Gem name
* Your name
* Your email
* Git SSH read/write path for your gem

The gem name of your gem must be a valid ruby variable name, for example:

    my_gem            # <= OK
    supergem          # <= OK
    Super Awesome Gem # <= not this, kittehs will die

The read write SSH git repository URL of your gem looks something like this:

    git@github.com:mikel/nugget.git

Providing your name and your email allows us to populate your gemspec file correctly.

Nugget will then build a basic gem folder structure using RSpec for you and setup
everything you need to start writing failing specs.

First Steps
----------------

Now that you have a gem directory, what should you do?  I recommend this:

* Edit the README in your new gem and commit the changes, see
(README Driven Development)[http://tom.preston-werner.com/2010/08/23/readme-driven-development.html] by
Tom Preston-Werner for more info.  Once done, do the following:

    $ git add README.md
    $ git commit README.md -m "First commit"
    $ git push origin master

* Modify the gemspec to update the description and summary info
* Commit and push the rest of the code:

    $ git add .
    $ git commit -m "Basic gem structure from nugget"
    $ git push

Now you will have a basic library structure to start editing your gem with no external dependencies.

Writing a Gem
----------------

First things first,

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