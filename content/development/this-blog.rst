************************
How I Created This Blog?
************************

:date: 2021-01-26 16:47
:updated: 2021-05-05 22:30
:tags: blog, pelican, ssg
:slug: twilight-blog
:category: development
:summary: As you would have guessed by now, this blog is created using one such awesome SSG named **Pelican**. Pelican is simple, customizable and offers lots of themes and plugins. Pelican is python based SSG and is available through :code:`pip`.

.. role:: html-raw(raw)
    :format: html

:html-raw:`<div class="alert alert-info" role="alert">This article may not be for you if you are a web developer. You already got better options. 😉</div>`

There are lots of ways to create a personal website or a blog. You can design your own user interface and write the backend code. But not everyone is a web developer. And here comes :abbr:`SSGs (Static Site Generator)` to the rescue. **Static Site Generators** are little more than just website generators. In general, if you are looking for a simple blog, its better to use SSG than writing a lot of html and css. They are simple and elegant. Easy to maintain and you can add lots of customizations to your site without breaking or bloating your blog. There are lots of SSGs, `Jekyll <https://jekyllrb.com/>`_, `Pelican <https://blog.getpelican.com/>`_ and more complex ones like `Gatsby <https://www.gatsbyjs.com/>`_, `Hugo <https://gohugo.io/>`_ .

As you would have guessed by now, this blog is created using one such awesome SSG named **Pelican**. Pelican is simple, customizable and offers lots of `themes <http://www.pelicanthemes.com/>`_ and `plugins <https://github.com/getpelican/pelican-plugins>`_. Pelican is python based SSG and is available through :code:`pip`. 

.. code-block:: shell

    # for reStructuredText only (recommended)
    python -m pip install pelican

    # for markdown and reStructuredText both
    python -m pip install "pelican[markdown]"

You can start a pelican project by typing following command. It will create a basic template and build configurations.

.. code-block:: shell

    pelican-quickstart

    # output
    yourproject/
    ├── content              # Put your content here
    │   └── (pages)          
    ├── output               # Output files
    ├── tasks.py             
    ├── Makefile             # Makefile to run build and publish command
    ├── pelicanconf.py       # Main settings file
    └── publishconf.py       # Settings to use when ready to publish

Next step is to choose themes. As I said earlier there are lots of `themes <http://www.pelicanthemes.com/>`_ . And it is easy to create your own theme. Check `here <https://docs.getpelican.com/en/latest/themes.html>`_ to create your own theme. My choice of theme was `pelican-alchemy <https://nairobilug.github.io/pelican-alchemy/>`_ . This is a simple and great theme. Installing and removing themes in pelican is very easy. 

.. code-block:: shell

    # list all installed themes
    pelican-themes -l
    # output
    simple
    alchemy
    notmyidea

    # install new theme 
    pelican-themes -i theme-path

    # remove a theme
    pelican-themes -r theme-name

To use a particular theme, set the :code:`THEME` variable in the **pelicanconf.py** file. 

.. code-block:: python

    THEME = 'alchemy'

You can also use a theme that is not installed if you have all the required theme files. Just set this variable to its path.

.. code-block:: python

    THEME = 'path-to-theme-directory'

Various themes will have different feature, choose according to your need, or you can always add a feature through plugin. The next step is to build and check your blog. Pelican got it all set up. 

.. code-block:: shell

    # build your website
    make html
    # output
    "pelican" "/mnt/z/my_git/avinal.github.io/content" -o "/mnt/z/my_git/avinal.github.io/output" -s "/mnt/z/my_git/avinal.github.io/pelicanconf.py" 
    Done: Processed 6 articles, 0 drafts, 1 page, 0 hidden pages and 0 draft pages in 2.43 seconds.

    # build and test/serve on localhost
    make serve
    # output
    "pelican" -l "/mnt/z/my_git/avinal.github.io/content" -o "/mnt/z/my_git/avinal.github.io/output" -s "/mnt/z/my_git/avinal.github.io/pelicanconf.py" 

    Serving site at: 127.0.0.1:8000 - Tap CTRL-C to stop

Now open your browser and open `127.0.0.1:8000 <127.0.0.1:8000>`_ or `localhost:8000 <localhost:8000>`_. You should be able to see your new blog. Stop local server using :code:`CTRL+C`. Next step is to publish it to github pages. Pelican has tools for this too. But wait we can do something more interesting here. Why not let GitHub take care of both building and publishing? Just push this project to a GitHub repository and set up GitHub pages. See `this <https://pages.github.com/>`_ help for instructions on that. Before pushing to GitHub add this little script to your project.

.. code-block:: shell

    #! /bin/bash
    ## file: publi.sh

    # install tools
    sudo apt-get install -y git make python3 python3-pip python3-setuptools python3-wheel

    # setup github config
    git config user.email "your-email"
    git config user.name "your-username"

    # install dependencies
    sudo pip3 install -r requirements.txt

    # pelican commands - install theme put your theme in themes directory
    pelican-themes --install themes/theme-name

    # publish to github pages
    ghp-import -m "Generate Pelican site" -b gh-pages output
	git push -f origin gh-pages

Now once your project is on GitHub, go to the **Actions** tab and click on *set up a workflow yourself* and paste the following code into the file and commit it.

.. code-block:: yaml

    # file: publish.yml
    name: Publish Blog
    on:
      push:
        branches: [ main ]
      pull_request:
        branches: [ main ]

    jobs:
      build:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v2
          - name: set up permissions
            run: chmod +x publi.sh
          - name: Run a multi-line script
            run: ./publi.sh

If you have done everything correctly then go to *https://username.github.io* and you should see your blog. From now on whenever you want to add an article, just write it, test locally and push. Yay your blog is ready.

:html-raw:`<h2 style=font-family:Exodar;font-weight:lighter;">But My Blog is Special 🥰</h2>`

My blog looks different, that is because I customized this theme a lot, especially headers, footers, and link appearance. And sorry I won't be publish my theme any time sooner. But I am listing down all the resources I have used for finally getting this result. You can always get my help by sending me a :html-raw:`<a href="mailto:avinal.xlvii@gmail.com" class="fa fa-envelope" style="text-decoration: none;"></a>` or starting a discussion on :html-raw:`<a href="https://github.com/avinal/avinal/discussions/2" class="fab fa-github" style="text-decoration: none;"></a>`.

* `Pelican Blog <https://blog.getpelican.com/>`_
* `Pelican Docs <https://docs.getpelican.com/en/latest/>`_
* `Pelican Themes <http://www.pelicanthemes.com/>`_
* `Pelican Alchemy Theme <https://github.com/nairobilug/pelican-alchemy>`_
* `Parallax Star background in CSS <https://codepen.io/saransh/pen/BKJun>`_
* `Solar System animation <https://codepen.io/kowlor/pen/ZYYQoy>`_
* :html-raw:`<a href="https://www.dafont.com/exodar.font" style="font-family: Exodar;font-weight: lighter;text-decoration: none;">EXODAR Font</a>`
* `Overpass Mono <https://fonts.google.com/specimen/Overpass+Mono>`_
* `Font Awesome <https://fontawesome.com/how-to-use/on-the-web/setup/hosting-font-awesome-yourself>`_

:html-raw:`<div class="alert alert-warning" role="alert">Some of the fonts I have used in my blog may not be available for commercial use. Please check if you intend to do so. Alternatively you may use fonts from this wonderful collection, <a href="https://www.websiteplanet.com/blog/best-free-fonts/">70+ Best Free Fonts for Designers – Free for Commercial Use in 2021</a> <i>(Thanks Ritta Blens for this suggestion)</i></div>`


:html-raw:`<p align=center>Thanks!</p>`

