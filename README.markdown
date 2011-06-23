A script to setup a complete rails 3.1 stack.

Created to experiment with various new tools.

Installing
___

    bin/install_patched_ruby # install 1.9.2 with load patch (15-25% faster)
    rvm ruby-1.9.2-patched@global
    gem install bundler -v 1.1.pre.5
    rvm ruby-1.9.2-patched@app_builder --create
    bundle

Building an app
___

    bin/app_builder new app

Add some specs and code
___

    bin/app_builder scaffold app

Gotchas
___

* This creates an app with nulldb enabled by default, specs that require a real database will fail. Add :db => true to the describe blocks where nessesary.

