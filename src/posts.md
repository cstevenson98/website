---
layout: layouts/base.njk
title: Posts
permalink: /posts/
---

# Posts

<ul class="post-list">
  {% for post in collections.posts %}
  <li>
    <a href="{{ post.url }}">{{ post.data.title }}</a>
    <p class="post-meta"><time datetime="{{ post.date | isoDate }}">{{ post.date | readableDate }}</time></p>
  </li>
  {% endfor %}
</ul>
