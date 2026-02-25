import type { Root, Element } from "hast";
import { visit } from "unist-util-visit";

/**
 * Rehype plugin that converts Hugo-style image alignment hints
 * (`:left` / `:right` suffixes in alt text) into CSS classes.
 *
 * `![Caption:left](/img.webp)` → `<img class="img-left" alt="Caption" …>`
 */
export default function rehypeImageAlign() {
  return (tree: Root) => {
    visit(tree, "element", (node: Element) => {
      if (node.tagName !== "img") return;

      const alt = (node.properties?.alt as string) ?? "";
      const match = alt.match(/^(.+):(left|right)$/);
      if (!match) return;

      node.properties!.alt = match[1].trim();
      const cls = `img-${match[2]}`;
      const existing = (node.properties!.className as string[]) ?? [];
      node.properties!.className = [...existing, cls];
    });
  };
}
