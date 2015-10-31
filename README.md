# Elixir Feed Parser
[![Build Status](https://travis-ci.org/fdietz/elixir-feed-parser.svg?branch=master)](https://travis-ci.org/fdietz/elixir-feed-parser)

Elixir Atom/RSS Parser. Depends on Erlang's **xmerl** xml parser.

# Current status
The code is currently in alpha state and my first ever written piece of Elixir
code.

# Setup

Add elixir-feed-parser to your mix dependencies and application.

```elixir
def application do
  [applications: [:"elixir_feed_parser"]]
end

defp deps do
  [{:"elixir_feed_parser", "~> 0.0.1"}]
end
```

Then run ```mix deps.get``` to install it.

# Parsing feeds

```elixir
feed = ElixirFeedParser.parse(xml_string)
title = feed.title
```
The `feed` map provides the following properties which is a normalization based
on the Atom and RSS2 standards. Whenever an attribute is normalized the
original attribute is provided with a corresponding namespace.

For example the `url` attribute is actually a `link` element as defined by the
RSS2 standard, therefore we additionally expose the `rss2:link` attribute.

## List of feed properties
* title
* id (a unique identifier)
* description
* url
* links (array of strings)
* feed_url (the canonical link to the feed)
* updated (most recent update)
* authors
* language
* icon
* logo
* copyright
* generator
* categories (an array of strings)

## List of article properties
* title
* id (a unique identifier)
* description
* url
* links (array of strings)
* updated (most recent update)
* published
* authors
* categories (an array of strings)
* source
