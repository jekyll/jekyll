# Code Highlighting

Jekyll has built in support for syntax highlighting of over 100 languages via Pygments. In order to take advantage of this you’ll need to have Pygments installed, and the pygmentize binary must be in your path. When you run Jekyll, make sure you run it with Pygments support

To denote a code block that should be highlighted:

{% highlight ruby %}
def foo
  puts 'foo'
end
{% endhighlight %}

The argument to highlight is the language identifier. To find the appropriate identifier to use for your favorite language, look for the “short name” on the Lexers page.

## Line number

There is a second argument to highlight called linenos that is optional. Including the linenos argument will force the highlighted code to include line numbers. For instance, the following code block would include line numbers next to each line:

{% highlight ruby linenos %}
def foo
  puts 'foo'
end
{% endhighlight %}