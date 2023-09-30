import { marked } from "marked";
import { markedHighlight } from "marked-highlight";
import Prism from "prismjs";

import "./Prism";

customElements.define(
  "rendered-md",
  class extends HTMLElement {
    constructor() {
      super();
      this.lead = 0; // Moved lead here
    }

    connectedCallback() {
      this.runMarked();
    }

    updateMeta(title, description) {
      const metaInfo = {
        'meta[name="title"]': `${title} | Avinal Kumar | Personal Website`,
        'meta[name="description"]': description,
        'meta[property="og:title"]': `${title} | Avinal Kumar | Personal Website`,
        'meta[property="og:description"]': description,
        'meta[property="og:url"]': window.location,
        'meta[property="twitter:title"]': `${title} | Avinal Kumar | Personal Website`,
        'meta[property="twitter:description"]': description,
        'meta[property="twitter:url"]': window.location,
      };

      for (const [selector, content] of Object.entries(metaInfo)) {
        const element = document.querySelector(selector);
        if (element) {
          element.setAttribute("content", content);
        } else {
          console.warn(`Element ${selector} not found`);
        }
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
      const {
        markdowndata: data,
        fragment,
        title,
        description,
      } = this.attributes;
      this.updateMeta(title.value, description.value);

      const renderer = new marked.Renderer();

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
        this.lead++;
        return this.lead === 1
          ? `<p class="lead">${text}</p>`
          : `<p>${text}</p>`;
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
      });

      marked.use(
        markedHighlight({
          highlight(code, lang) {
            const grammer = Prism.languages[lang];
            if (!grammer) {
              console.warn(`Unable to find prism highlight for '${lang}'`);
              return;
            }
            return Prism.highlight(code, grammer, lang);
          },
        })
      );

      this.innerHTML = marked(data.value);
      this.addComments();

      if (fragment && fragment.value) {
        window.location = `#${fragment.value}`;
      }
    }

    static get observedAttributes() {
      return ["markdowndata", "fragment", "title", "description"];
    }
  }
);
