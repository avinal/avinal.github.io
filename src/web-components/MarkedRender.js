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
    runMarked() {
      const renderer = new marked.Renderer();
      const data = this.getAttribute("markdowndata");
      const fragment = this.getAttribute("fragment");
      var lead = 0;
      renderer.heading = (text, level) => {
        if (level === 1) {
          return `<header class="text-center w-full">
            <h1>
                ${text}</h1>
            </header>`;
        }
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
        return `<img class="max-w-xs grow-0 shrink-0 basis-auto w-full" src=${href} alt="${text}">`;
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
      if (fragment) {
        console.log("Fragment found, scrolling to: #", fragment);
        window.location = "#" + fragment;
      }
    }

    static get observedAttributes() {
      return ["markdowndata", "fragment"];
    }
  }
);
