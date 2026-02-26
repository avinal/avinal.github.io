# avinal.space

Personal website and blog built with [Astro](https://astro.build). Minimal, fast, and almost entirely HTML & CSS with zero-JS by default.

**Live:** [avinal.space](https://avinal.space)

## Design Inspiration

- [jay.fish](https://jay.fish/) — homepage layout, activity graph, bento grid
- [usememos.com](https://usememos.com/) — clean typography, color palette, overall theme

## Pages

| Route | Description |
|-------|-------------|
| `/` | Homepage with hero card, GitHub/WakaTime activity graph, ListenBrainz music widget, recent posts, and pinned repos |
| `/posts/` | Blog index with category filters and featured images |
| `/posts/<category>/` | Category-filtered post listings |
| `/posts/<category>/<slug>/` | Individual blog posts |
| `/resume/` | Resume page (data driven from `src/data/resume.json`) |
| `/events/` | Conferences and events timeline |
| `/meeting/` | Book a meeting via [Cal.com](https://cal.com) embed |
| `/setup/` | Hardware and software setup |
| `/rss.xml` | RSS feed |

## Prerequisites

- [Node.js](https://nodejs.org/) 22+
- npm

## Getting Started

```bash
git clone https://github.com/avinal/avinal.github.io.git
cd avinal.github.io
make install
```

No environment variables are required. All external data is fetched from public APIs:

- **GitHub** — contributions graph and user info (public API)
- **WakaTime** — coding stats via public share URL
- **ListenBrainz** — music listening activity (public API, username in `src/config/theme.ts`)
- **Cal.com** — meeting booking (embedded via CDN)

## Development

```bash
make dev        # Start dev server with hot reload
make build      # Build for production
make preview    # Preview production build locally
make check      # Run Astro type checking
make clean      # Remove build artifacts
make nuke       # Full clean (includes node_modules)
make fresh      # Clean install from scratch
```

## Project Structure

```
src/
├── components/     # Reusable Astro components
├── config/         # Theme tokens and site config
├── content/posts/  # Blog posts (Markdown)
├── data/           # JSON data (resume, repos, events)
├── layouts/        # Page layouts
├── lib/            # Utilities and rehype plugins
├── pages/          # Route pages
└── styles/         # Global CSS
public/             # Static assets (images, favicons)
```

## Configuration

- **Theme & colors:** `src/config/theme.ts` — single file for all design tokens, easily swap the entire color palette
- **Repos:** `src/data/repos.json` — pinned repositories shown on the homepage
- **Resume:** `src/data/resume.json` — JSON Resume format, drives the `/resume/` page

## Deployment

The site is deployed via [Netlify](https://netlify.com). Any push to `main` triggers a build automatically. See `netlify.toml` for the build config.

## License

See [LICENSE](LICENSE) for details.
