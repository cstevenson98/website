---
layout: layouts/base.njk
title: Home
---

# {{ site.title }}

<p class="lede">{{ site.description }} Notes, math, and projects — written in Markdown, built with Eleventy, rendered with KaTeX.</p>

## Recent posts

{% if collections.posts.length %}
<ul class="post-list">
  {% for post in collections.posts %}
  <li>
    <a href="{{ post.url | url }}">{{ post.data.title }}</a>
    <p class="post-meta"><time datetime="{{ post.date | isoDate }}">{{ post.date | readableDate }}</time></p>
  </li>
  {% endfor %}
</ul>
{% else %}
<p>No posts yet.</p>
{% endif %}
