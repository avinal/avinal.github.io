import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const posts = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/posts" }),
  schema: z.object({
    title: z.string().optional().default("Untitled"),
    date: z.coerce.date().optional().default(new Date("2000-01-01")),
    description: z.string().optional().default(""),
    category: z.string().optional().default("uncategorized"),
    tags: z.array(z.string()).optional().default([]),
    image: z.string().optional().default(""),
    draft: z.boolean().optional().default(false),
    modified: z.coerce.date().optional(),
  }),
});

export const collections = { posts };
