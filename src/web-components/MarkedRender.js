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
    attributeChangedCallback(name, oldValue, newValue) {
      this.runMarked();
    }
    runMarked() {
      const renderer = new marked.Renderer();
      const data = this.getAttribute("markdowndata");
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

      marked.setOptions({
        renderer: renderer,
        highlight: function (code, lang) {
          const grammer = Prism.languages[lang];
          if (!grammer) {
            console.warn(`Unable to find prism highlight for '${lang}'`);
            return;
          }
          console.info("Found", lang);
          return Prism.highlight(code, grammer, lang);
        },
      });

      this.innerHTML = marked.parse(data);
      console.log("Markdown rendering complete!");
    }

    static get observedAttributes() {
      return ["markdowndata"];
    }
  }
);
