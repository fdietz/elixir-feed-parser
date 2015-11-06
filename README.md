# Elixir Feed Parser
[![Build Status](https://travis-ci.org/fdietz/elixir-feed-parser.svg?branch=master)](https://travis-ci.org/fdietz/elixir-feed-parser)

Elixir Atom/RSS Parser. Depends on Erlang's **xmerl** xml parser.

It is basically a port of the excellent Ruby [Feed Jira](https://github.com/feedjira/feedjira) gem.

Supports specifically Feedburner Atom/RSS2 feeds, [iTunes Podcast](http://www.apple.com/itunes/whatson/podcasts/specs.html) and Google Docs
feeds.

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

# Contribute
I appreciate any contribution to elixir-feed-parser. Open a pull request or file issues if you got feedback!

I'm new to Elixir and would love to get some feedback on how to improve this codebase.

# Credits
Since this is my first Elixir project I've taken lots of ideas from existing projects. In particular I'd like to mention [FeederEx](https://github.com/manukall/feeder_ex), [Feedme](https://github.com/umurgdk/elixir-feedme) and [Quinn](https://github.com/nhu313/Quinn).
