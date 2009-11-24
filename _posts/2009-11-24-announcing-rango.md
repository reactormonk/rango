---
title: Announcing Rango
layout: blog
tags: [announcement]
---

I am happy to announce the first usable release of my new framework Rango. Rango is small MVC framework inspired by Merb and Django builded on top of Rack. It's clean, simple and it's trying to be as agnostic as possible.

Why I decided to Write Rango?
-----------------------------
For few years I was happily using Merb and I has absolutely no intention to write my own framework. But then we received the "Christmas gift" from Engine Yard telling us Merb won't be developed and supported anymore. Mery Christmas really. So I started to look for a new framework.

There are more than few Ruby frameworks, but just few of them are propriete for developing big applications. You like Sinatra, do you? You can write your blog in it, but would you like to write bigger e-shop in Sinatra? I guess not.

And this is where Rango comes. It's lightweight framework, but it's intended to be decent solution even for big sites. But because it's still lightweight and very flexible, you can build small applications in it and it won't be an overkill.

Why You May Be Interested In Using Rango?
-----------------------------------------

The killer feature is certainly [template inheritance](http://wiki.github.com/botanicus/rango/template-inheritance)
Rango is the only framework in Ruby supporting this cool feature.

{% highlight ruby %}
- extends "base.html" unless request.ajax?
- block "head" do
= block "content" do
  %h1 The Page
{% endhighlight %}

The [boot process](http://wiki.github.com/botanicus/rango/rango-boot-process) is also pretty unique: instead of having bunch of stupid scripts in `bin/` or `script/` directory, or executable script somewhere in system when you can't hook it, you get
an executables `init.rb` and `config.ru`.

{% highlight bash %}
config.ru
#!/usr/bin/env ./init.rb -p 4000 -s webrick

init.rb
#!/usr/bin/env ruby1.9 --disable-gems
{% endhighlight %}

Some other notable features are dead-simple-to-write [generators](http://wiki.github.com/botanicus/rango/generators), [generic views](http://wiki.github.com/botanicus/rango/generic-views) and very powerful and flexible [errors handling](http://wiki.github.com/botanicus/rango/errors-handling).

*More at Rango wiki in [Why use Rango](http://wiki.github.com/botanicus/rango/why-use-rango) chapter.*

Lets Start!
-----------
* Clone Rango repository: `git clone git://github.com/botanicus/rango.git `
* Go to the examples directory: `cd rango/examples/blog`
* Bundle dependencies `gem bundle` (this will require bundler)
* Run the application: `./config.ru`

Discovering Rango
----------------

There is quite a lot documentation on [Rango Wiki](http://wiki.github.com/botanicus/rango). If you are interested in contributing to Rango, go for it! I will give you commit access for the first accepted commit.

You can look forward to the tutorial and screencast which will be released pretty soon, so stay tuned and add this blog into your RSS or follow [@RangoProject](http://twitter.com/rangoproject) on Twitter! Enjoy Rango!