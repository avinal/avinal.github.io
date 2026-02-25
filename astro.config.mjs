import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import rehypeImageAlign from "./src/lib/rehype-image-align.ts";
import rehypeSlug from "rehype-slug";
import rehypeAutolinkHeadings from "rehype-autolink-headings";

export default defineConfig({
  site: "https://avinal.space",
  output: "static",
  integrations: [sitemap()],
  markdown: {
    shikiConfig: {
      theme: "github-dark-default",
    },
    rehypePlugins: [
      rehypeImageAlign,
      rehypeSlug,
      [
        rehypeAutolinkHeadings,
        {
          behavior: "append",
          properties: { className: ["heading-anchor"], ariaLabel: "Link to this section" },
          content: { type: "text", value: "#" },
        },
      ],
    ],
  },
});
