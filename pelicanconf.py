#!/usr/bin/env python
# -*- coding: utf-8 -*- #
AUTHOR = 'Avinal'
HIDE_AUTHORS = True
SITENAME = 'Be My SpaceTime'
SITESUBTITLE = '눈치'
SITEURL = 'https://blog.avinal.space'
THEME = 'themes/alchemy'
PATH = 'content'
MAIL = 'avinal.xlvii@gmail.com'
TIMEZONE = 'Asia/Kolkata'
DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None


# URL Flexibility
ARTICLE_URL = 'posts/{category}/{slug}.html'
ARTICLE_SAVE_AS = ARTICLE_URL
PAGE_URL = 'pages/{slug}.html'
PAGE_SAVE_AS = PAGE_URL

# static content setting
STATIC_PATHS = ['extras', 'images']
EXTRA_PATH_METADATA = {
    'extras/android-chrome-192x192.png': {'path': 'android-chrome-192x192.png'},
    'extras/android-chrome-512x512.png': {'path': 'android-chrome-512x512.png'},
    'extras/apple-touch-icon.png': {'path': 'apple-touch-icon.png'},
    'extras/browserconfig.xml': {'path': 'browserconfig.xml'},
    'extras/favicon-16x16.png': {'path': 'favicon-16x16.png'},
    'extras/favicon-32x32.png': {'path': 'favicon-32x32.png'},
    'extras/favicon.ico': {'path': 'favicon.ico'},
    'extras/site.webmanifest': {'path': 'site.webmanifest'},
    'extras/mstile-150x150.png': {'path': 'mstile-150x150.png'},
    'extras/mstile-70x70.png': {'path': 'mstile-70x70.png'},
    'extras/mstile-310x310.png': {'path': 'mstile-310x310.png'},
    'extras/mstile-144x144.png': {'path': 'mstile-144x144.png'},
    'extras/safari-pinned-tab.svg': {'path': 'safari-pinned-tab.svg'},
}

RFG_FAVICONS = False

# icons
ICONS = [
    ('github', "https://github.com/avinal"),
    ('linkedin', 'https://www.linkedin.com/in/avinal/')
]

LINKS = [
    ('feedback', "https://github.com/avinal/avinal/discussions/2")
]

DEFAULT_PAGINATION = 10

PYGMENTS_STYLE = 'monokai'

# disqus integration
# DISQUS_SITENAME = "avinal"