/**
 * Single source of truth for all design tokens.
 *
 * To change the entire look of the site, edit this file.
 * To create a new theme, duplicate this file (e.g. theme-nord.ts)
 * and update the import in BaseLayout.astro.
 */

export interface ThemePalette {
  bg: string;
  bgSurface: string;
  bgSurfaceHover: string;
  text: string;
  textSecondary: string;
  textMuted: string;
  accent: string;
  accentHover: string;
  accentSubtle: string;
  border: string;
  borderStrong: string;
  shadow: string;
  shadowMd: string;
}

export interface GraphColors {
  level0: string;
  level1: string;
  level2: string;
  level3: string;
  level4: string;
  wakaLevel1: string;
  wakaLevel2: string;
  wakaLevel3: string;
  wakaLevel4: string;
}

export interface ThemeConfig {
  name: string;

  site: {
    title: string;
    description: string;
    url: string;
    author: string;
    logoText: string;
    listenBrainzUser?: string;
  };

  fonts: {
    sans: string;
    mono: string;
  };

  colors: {
    light: ThemePalette;
    dark: ThemePalette;
    graph: {
      light: GraphColors;
      dark: GraphColors;
    };
  };

  spacing: {
    base: string;
    navHeight: string;
    maxProse: string;
    maxPage: string;
    sectionGap: string;
    cardPadding: string;
  };

  radius: {
    sm: string;
    md: string;
    lg: string;
    full: string;
  };

  typography: {
    lineHeight: string;
    lineHeightTight: string;
    lineHeightRelaxed: string;
    trackingTight: string;
  };

  transitions: {
    fast: string;
    normal: string;
    ease: string;
  };
}

// ---------------------------------------------------------------------------
// Default theme — usememos-inspired clean palette, jay.fish structure
// ---------------------------------------------------------------------------

const theme: ThemeConfig = {
  name: "default",

  site: {
    title: "avinal.space",
    description: "Avinal Kumar — Software Engineer, Open Source Contributor",
    url: "https://avinal.space",
    author: "Avinal Kumar",
    logoText: "avinal.space",
    listenBrainzUser: "avinal",
  },

  fonts: {
    sans: '"Inter", "Segoe UI", system-ui, -apple-system, sans-serif',
    mono: '"JetBrains Mono", "Fira Code", ui-monospace, monospace',
  },

  colors: {
    light: {
      bg: "#fafafa",
      bgSurface: "#ffffff",
      bgSurfaceHover: "#f5f5f5",
      text: "#1a1a1a",
      textSecondary: "#525252",
      textMuted: "#737373",
      accent: "#2563eb",
      accentHover: "#1d4ed8",
      accentSubtle: "#eff6ff",
      border: "#e5e5e5",
      borderStrong: "#d4d4d4",
      shadow: "0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04)",
      shadowMd: "0 4px 6px rgba(0,0,0,0.05), 0 2px 4px rgba(0,0,0,0.04)",
    },
    dark: {
      bg: "#111111",
      bgSurface: "#1a1a1a",
      bgSurfaceHover: "#262626",
      text: "#e5e5e5",
      textSecondary: "#a3a3a3",
      textMuted: "#737373",
      accent: "#60a5fa",
      accentHover: "#93bbfd",
      accentSubtle: "#172554",
      border: "#2e2e2e",
      borderStrong: "#404040",
      shadow: "0 1px 3px rgba(0,0,0,0.3), 0 1px 2px rgba(0,0,0,0.2)",
      shadowMd: "0 4px 6px rgba(0,0,0,0.25), 0 2px 4px rgba(0,0,0,0.15)",
    },
    graph: {
      light: {
        level0: "#ebedf0",
        level1: "#9be9a8",
        level2: "#40c463",
        level3: "#30a14e",
        level4: "#216e39",
        wakaLevel1: "#c4b5fd",
        wakaLevel2: "#a78bfa",
        wakaLevel3: "#8b5cf6",
        wakaLevel4: "#7c3aed",
      },
      dark: {
        level0: "#1e1e1e",
        level1: "#0e4429",
        level2: "#006d32",
        level3: "#26a641",
        level4: "#39d353",
        wakaLevel1: "#2e1065",
        wakaLevel2: "#4c1d95",
        wakaLevel3: "#7c3aed",
        wakaLevel4: "#a78bfa",
      },
    },
  },

  spacing: {
    base: "0.25rem",
    navHeight: "3.5rem",
    maxProse: "48rem",
    maxPage: "64rem",
    sectionGap: "4rem",
    cardPadding: "1.5rem",
  },

  radius: {
    sm: "0.375rem",
    md: "0.5rem",
    lg: "0.75rem",
    full: "9999px",
  },

  typography: {
    lineHeight: "1.6",
    lineHeightTight: "1.2",
    lineHeightRelaxed: "1.75",
    trackingTight: "-0.02em",
  },

  transitions: {
    fast: "150ms",
    normal: "250ms",
    ease: "cubic-bezier(0.16, 1, 0.3, 1)",
  },
};

export default theme;

// ---------------------------------------------------------------------------
// Utility: convert the theme config to CSS custom properties
// ---------------------------------------------------------------------------

function paletteToVars(p: ThemePalette): string {
  return `
    --bg: ${p.bg};
    --bg-surface: ${p.bgSurface};
    --bg-surface-hover: ${p.bgSurfaceHover};
    --text: ${p.text};
    --text-secondary: ${p.textSecondary};
    --text-muted: ${p.textMuted};
    --accent: ${p.accent};
    --accent-hover: ${p.accentHover};
    --accent-subtle: ${p.accentSubtle};
    --border: ${p.border};
    --border-strong: ${p.borderStrong};
    --shadow: ${p.shadow};
    --shadow-md: ${p.shadowMd};
  `;
}

function graphToVars(g: GraphColors): string {
  return `
    --graph-0: ${g.level0};
    --graph-1: ${g.level1};
    --graph-2: ${g.level2};
    --graph-3: ${g.level3};
    --graph-4: ${g.level4};
    --waka-1: ${g.wakaLevel1};
    --waka-2: ${g.wakaLevel2};
    --waka-3: ${g.wakaLevel3};
    --waka-4: ${g.wakaLevel4};
  `;
}

export function generateThemeCSS(t: ThemeConfig): string {
  return `
    :root {
      --font-sans: ${t.fonts.sans};
      --font-mono: ${t.fonts.mono};

      --text-xs:  clamp(0.75rem, 0.7rem + 0.25vw, 0.8125rem);
      --text-sm:  clamp(0.8125rem, 0.78rem + 0.2vw, 0.875rem);
      --text-base: clamp(0.9375rem, 0.9rem + 0.2vw, 1rem);
      --text-lg:  clamp(1.125rem, 1.05rem + 0.4vw, 1.25rem);
      --text-xl:  clamp(1.25rem, 1.1rem + 0.75vw, 1.5rem);
      --text-2xl: clamp(1.5rem, 1.2rem + 1.5vw, 2rem);
      --text-3xl: clamp(1.875rem, 1.4rem + 2.4vw, 2.5rem);
      --text-4xl: clamp(2.25rem, 1.6rem + 3.2vw, 3.25rem);

      --leading-tight: ${t.typography.lineHeightTight};
      --leading-normal: ${t.typography.lineHeight};
      --leading-relaxed: ${t.typography.lineHeightRelaxed};
      --tracking-tight: ${t.typography.trackingTight};
      --tracking-normal: 0;

      --space-1: ${t.spacing.base};
      --space-2: calc(${t.spacing.base} * 2);
      --space-3: calc(${t.spacing.base} * 3);
      --space-4: calc(${t.spacing.base} * 4);
      --space-5: calc(${t.spacing.base} * 5);
      --space-6: calc(${t.spacing.base} * 6);
      --space-8: calc(${t.spacing.base} * 8);
      --space-10: calc(${t.spacing.base} * 10);
      --space-12: calc(${t.spacing.base} * 12);
      --space-16: calc(${t.spacing.base} * 16);
      --space-20: calc(${t.spacing.base} * 20);
      --space-24: calc(${t.spacing.base} * 24);

      --max-w-prose: ${t.spacing.maxProse};
      --max-w-page: ${t.spacing.maxPage};
      --nav-height: ${t.spacing.navHeight};

      --radius-sm: ${t.radius.sm};
      --radius-md: ${t.radius.md};
      --radius-lg: ${t.radius.lg};
      --radius-full: ${t.radius.full};

      --duration-fast: ${t.transitions.fast};
      --duration-normal: ${t.transitions.normal};
      --ease-out: ${t.transitions.ease};

      ${paletteToVars(t.colors.light)}
      ${graphToVars(t.colors.graph.light)}
    }

    [data-theme="dark"] {
      ${paletteToVars(t.colors.dark)}
      ${graphToVars(t.colors.graph.dark)}
    }

    @media (prefers-color-scheme: dark) {
      :root:not([data-theme="light"]) {
        ${paletteToVars(t.colors.dark)}
        ${graphToVars(t.colors.graph.dark)}
      }
    }
  `;
}
