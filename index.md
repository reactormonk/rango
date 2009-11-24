---
title: Home
layout: default
---

Rango
=====

* Start: [Tutorial](http://wiki.github.com/botanicus/rango/tutorial)
* Learn: [Wiki](http://botanicus.github.com/rango/faq.html), [API](http://rdoc.info/projects/botanicus/rango)
* [Contribute](http://github.com/botanicus/rango)

Latest Posts on Rango Blog
--------------------------
<ul>
  {% for post in site.posts limit:5 %}
    <li><a href="/rango{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

Latest Tweets
-------------
<div id="tweets"></div>
