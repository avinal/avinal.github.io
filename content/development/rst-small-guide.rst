**************************
reStructuredText in GitHub
**************************

:date: 2021-02-14 22:47
:slug: rst-guide
:category: development
:tags: rst, github
:summary: reStructuredText syntax

- Headers
  
  .. code-block:: rst
    
    Top Title
    =========

    Sub Title
    ---------

    Sub Sub Title
    ^^^^^^^^^^^^^

- Images
  
  - Direct
    
    .. code-block:: rst

        .. figure:: image-path-or-url
            :align: center
            :target: link-to-go-when-image-is-clicked
            :alt: alternative-text-if-any
        
  - Indirect
    
    .. code-block:: rst

        .. |substitution| image:: image-path-or-url
            :target: link-to-go-when-image-is-clicked

    You can use :code:`|substitution|` where you want to put your image.

- Links
  
  .. code-block:: rst
    
    `Link Text <link-itself>`__

- Lists
  
  .. code-block:: rst

    - item 1 
    - item 2

    * item 1
    * itme 2
  
    #. item 1
    #. item 2

    1. item 1
    2. item 2

  First two lists are unordered next two are ordered.

- Code
  
  - Inline

    .. code-block:: rst

        :code:`your-code`

  - Code block
    
    .. code-block:: rst

        .. code-block:: language(optional)

            Your code 
            in multiple lines. You may enable line numbers too.

- Tables
  
  .. code-block:: rst

    +----------------+----------------+
    | Header Cell    | Header Cell    |
    +================+================+
    | Data cell      | Data Cell      |
    +----------------+----------------+
    | Header Cell    | Header Cell    |
    +----------------+----------------+

- Raw HTML block
  
  .. code-block:: rst

    .. raw:: html

        <put>
            your html code here
        </put>

- Notes, warnings
  
  .. code-block:: rst

    .. note::

        Put your note here.

    .. warning::

        Put your warning here.

    .. important::

        Put instructions here.

    .. admonition:: custom-text

        Custom description here.
    

These all are supported by GitHub very well. For more exhautive list specific to Sphinx see `this <https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html>`__ link.

Tips
----

- There must be a blank line before and after any directive. Such as after title or code block, tables etc.
- The options and content of a directives must be 1 tab indented to the directives.
