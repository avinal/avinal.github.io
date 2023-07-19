import "./prism.js";
customElements.define(
  "rendered-md",
  class extends HTMLElement {
    constructor() {
      super();
    }
    connectedCallback() {
      this.runMarked();
    }

    updateMeta(title, description) {
      document
        .querySelector('meta[name="title"]')
        .setAttribute("content", title + " | Avinal Kumar | Personal Website");
      document
        .querySelector('meta[name="description"]')
        .setAttribute("content", description);
      document
        .querySelector('meta[property="og:title"]')
        .setAttribute("content", title + " | Avinal Kumar | Personal Website");
      document
        .querySelector('meta[property="og:description"]')
        .setAttribute("content", description);
      document
        .querySelector('meta[property="og:url"]')
        .setAttribute("content", window.location);
      document
        .querySelector('meta[property="twitter:title"]')
        .setAttribute("content", title + " | Avinal Kumar | Personal Website");
      document
        .querySelector('meta[property="twitter:description"]')
        .setAttribute("content", description);
      document
        .querySelector('meta[property="twitter:url"]')
        .setAttribute("content", window.location);
    }

    addLineNumber() {
      var env = {
        container: document,
        selector:
          'code[class*="language-"], [class*="language-"] code, code[class*="lang-"], [class*="lang-"] code',
      };

      env.elements = Array.prototype.slice.apply(
        env.container.querySelectorAll(env.selector)
      );

      for (var i = 0, element; (element = env.elements[i++]); ) {
        highlightElement(element);
      }
      function highlightElement(element) {
        var language = Prism.util.getLanguage(element);
        if (language == "bash") {
          return;
        }
        var grammar = Prism.languages[language];

        var parent = element.parentElement;
        if (parent && parent.nodeName.toLowerCase() === "pre") {
          Prism.util.setLanguage(parent, language);
        }
        var code = element.textContent;
        var env = {
          element: element,
          language: language,
          grammar: grammar,
          code: code,
        };
        Prism.hooks.run("complete", env);
      }
    }

    addComments() {
      window.remark_config = {
        host: "https://remark42.avinal.space",
        site_id: "remark",
        theme: "dark",
        show_rss_subscription: false,
        no_footer: true,
      };

      !(function (e, n) {
        for (var o = 0; o < e.length; o++) {
          var r = n.createElement("script"),
            c = ".js",
            d = n.head || n.body;
          "noModule" in r
            ? ((r.type = "module"), (c = ".mjs"))
            : (r.async = !0),
            (r.defer = !0),
            (r.src = remark_config.host + "/web/" + e[o] + c),
            d.appendChild(r);
        }
      })(remark_config.components || ["embed"], document);
    }

    runMarked() {
      const renderer = new marked.Renderer();
      const data = this.getAttribute("markdowndata");
      const fragment = this.getAttribute("fragment");
      const title = this.getAttribute("title");
      const description = this.getAttribute("description");
      this.updateMeta(title, description);

      var lead = 0;
      renderer.heading = (text, level) => {
        const escapedText = text
          .trim()
          .toLowerCase()
          .replace(/[^\w]+/g, "-");

        return `<h${level} id="${escapedText}">
        ${text}
          <a title="Permalink to ${text}" href="#${escapedText}">
           #
          </a>
          </h${level}>`;
      };

      renderer.paragraph = (text) => {
        lead++;
        if (lead === 1) {
          return `<p class="lead">${text}</p>`;
        }
        return `<p>${text}</p>`;
      };

      renderer.image = (href, title, text) => {
        let pos = text.search(":");
        let direction = text.substr(pos + 1);
        text = text.substr(0, pos);
        let put = "max-w-xs ";
        switch (direction) {
          case "right":
            put += "float-right ";
            break;
          case "left":
            put += "float-left ";
            break;
          default:
            put = "float-none ";
        }
        return `<img class="${put} grow-0 shrink-0 basis-auto w-full px-3" src=${href} alt="${text}">`;
      };

      marked.setOptions({
        renderer: renderer,
        highlight: function (code, lang) {
          const grammer = Prism.languages[lang];
          if (!grammer) {
            console.warn(`Unable to find prism highlight for '${lang}'`);
            return;
          }
          return Prism.highlight(code, grammer, lang);
        },
      });

      this.innerHTML = marked.parse(data);
      console.log("Markdown rendering complete!");
      this.addLineNumber();
      this.addComments();

      if (fragment) {
        console.log(
          `Fragment found, scrolling to: ${window.location}#${fragment}`
        );
        window.location = "#" + fragment;
      }
    }

    static get observedAttributes() {
      return ["markdowndata", "fragment", "title", "description"];
    }
  }
);
