module Blog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Parser
import Html.Parser.Util



-- MODEL


type alias Model =
    { blog : Blog
    }



-- Blog Post


type alias Blog =
    { title : String
    , url : String
    , description : String
    , content : String
    , category : String
    , tags : List String
    , date : String
    }


view : Model -> Html msg
view model =
    div [ class "foo-interface" ]
        [ div [ class "max-width mx-auto px3 ltr" ]
            [ div [ class "content index py4" ]
                (textToHtml postString)
            ]
        ]


type Msg
    = Nothing


init : () -> ( Model, Cmd Msg )
init _ =
    ( { blog =
            { title = "My First Blog Post"
            , url = "my-first-blog-post"
            , description = "This is my first blog post"
            , content = "This is the content of my first blog post"
            , category = "blog"
            , tags = [ "elm", "blog" ]
            , date = "2018-01-01"
            }
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )


textToHtml : String -> List (Html.Html msg)
textToHtml text =
    case Html.Parser.run text of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []


testString : String
testString =
    """
    <div id="header">
    <a href="/">
        <div id="logo" style="background-image: url(/images/logo.png);"></div>
        <div id="title">
            <h1>Hexo</h1>
        </div>
    </a>
    <div id="nav">
        <ul>
            <li class="icon">
                <a href="#" aria-label="Menu"><i class="fas fa-bars fa-2x"></i></a>
            </li>
            <li><a href="/">Home</a></li>
            <li><a href="/about/">About</a></li>
            <li><a href="/archives/">Writing</a></li>
            <li><a target="_blank" rel="noopener" href="http://github.com/probberechts">Projects</a></li>
        </ul>
    </div>
    </div>
    <section id="about">
        <p>
            Find me on
            <a class="icon" target="_blank" rel="noopener" href="http://github.com/probberechts/cactus-dark"
                aria-label="github">
                <i class="fab fa-github"></i>
            </a>
            <a class="icon" target="_blank" rel="noopener" href="/" aria-label="twitter">
                <i class="fab fa-twitter"></i>
            </a>
            <a class="icon" target="_blank" rel="noopener" href="/" aria-label="facebook">
                <i class="fab fa-facebook"></i>
            </a>
            <a class="icon" target="_blank" rel="noopener" href="/" aria-label="linkedin">
                <i class="fab fa-linkedin"></i>
            </a>and
            <a class="icon" target="_blank" rel="noopener" href="mailto:name@email.com" aria-label="mail">
                <i class="fas fa-envelope"></i>
            </a>
        </p>
    </section>
    <section id="writing">
        <span class="h1"><a href="/archives/">Writing</a></span>
        <ul class="post-list">
            <li class="post-item">
                <div class="meta">
                    <time datetime="2022-09-15T17:21:59.000Z" itemprop="datePublished">2022-09-15</time>
                </div>
                <span>
                    <a class="" href="/posts/techtest/hey-world">Hello</a>
                </span>
            </li>
            <li class="post-item">
                <div class="meta">
                    <time datetime="2022-09-05T17:21:59.000Z" itemprop="datePublished">2022-09-05</time>
                </div>
                <span>
                    <a class="" href="/posts/tech/hello-world">Hello World</a>
                </span>
            </li>
        </ul>
    </section>
    """


postString : String
postString =
    """
    <article class="post" itemscope itemtype="http://schema.org/BlogPosting">
    <div>

        <h1 class="posttitle" itemprop="name headline">
            Hello World
        </h1>



        <div class="meta">
            <span class="author" itemprop="author" itemscope itemtype="http://schema.org/Person">
                <span itemprop="name"></span>
            </span>

            <div class="postdate">

                <time datetime="2016-11-14T12:19:32.000Z" itemprop="datePublished">2016-11-14</time>


            </div>





            <div class="article-tag">
                <i class="fas fa-tag"></i>
                <a class="tag-link-link" href="/tags/example/" rel="tag">example</a>, <a class="tag-link-link"
                    href="/tags/features/" rel="tag">features</a>
            </div>


        </div>
    </div>


    <div class="content" itemprop="articleBody">
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec at dolor a sem consequat facilisis ut et
            augue. Vestibulum vestibulum lectus erat, id tincidunt sapien laoreet non. Ut nec ante eu lorem posuere
            fringilla sit amet in tortor.</p>
        <h2 id="This-is-a-subtitle"><a href="#This-is-a-subtitle" class="headerlink" title="This is a subtitle"></a>This
            is a subtitle</h2>
        <p>Quisque ac maximus ligula, sed sagittis est. Integer venenatis pellentesque elit. Donec molestie turpis sit
            amet sodales cursus. Sed at risus cursus, feugiat lacus sit amet, rutrum sem. Vestibulum accumsan dui urna,
            vel feugiat lectus malesuada id. Quisque in interdum turpis, et pulvinar tortor. Vivamus tincidunt purus eu
            libero viverra, at posuere dolor gravida.</p>
        <figure class="highlight python">
            <figcaption><span>Hello world
                    <http: //github.com /> hello_world.py
                </span></figcaption>
            <table>
                <tr>
                    <td class="gutter">
                        <pre><span class="line">1</span><br><span class="line">2</span><br></pre>
                    </td>
                    <td class="code">
                        <pre><span class="line"><span class="built_in">print</span> <span class="string">&quot;Hello World!&quot;</span></span><br><span class="line">=&gt; <span class="string">&quot;Hello World!&quot;</span></span><br></pre>
                    </td>
                </tr>
            </table>
        </figure>

        <h2 id="This-is-a-second-subtitle"><a href="#This-is-a-second-subtitle" class="headerlink"
                title="This is a second subtitle"></a>This is a second subtitle</h2>
        <p>Donec venenatis eu nunc non accumsan. Etiam elementum dapibus urna, ac mattis tortor volutpat a. Pellentesque
            eu purus metus. Curabitur vel nulla ut odio congue vulputate. Morbi lacinia tellus sit amet facilisis
            dictum. Nullam a erat felis. Vestibulum nec diam ac nisi pharetra tincidunt. Ut vitae ullamcorper ipsum. Sed
            vehicula vehicula dolor. Quisque ac tortor a neque scelerisque venenatis.</p>
        <img src="/assets/wallpaper-878514.jpg" class="" title="Wallpaper">

        <blockquote class="pullquote right">
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque hendrerit lacus ut purus iaculis
                feugiat.</p>
        </blockquote>

        <p>Mauris quis lorem id arcu lobortis finibus in quis mauris. Cras lacinia neque arcu, id viverra nunc pretium
            eget. Aenean eu luctus diam. Maecenas blandit eros in fermentum cursus. Pellentesque hendrerit ipsum orci,
            tempor facilisis est maximus at. Suspendisse potenti. Sed eleifend ullamcorper eleifend. Nullam tincidunt
            eget ex vitae blandit. Donec molestie iaculis elementum. Interdum et malesuada fames ac ante ipsum primis in
            faucibus. Maecenas in suscipit ex. Integer molestie felis mi, in commodo dolor fermentum a. Cras blandit
            auctor enim, eu rhoncus turpis ullamcorper id.</p>

    </div>
</article>
    """
