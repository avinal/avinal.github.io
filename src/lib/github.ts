const GITHUB_USER = "avinal";

export interface GitHubUser {
  login: string;
  name: string;
  bio: string;
  avatar_url: string;
  public_repos: number;
  followers: number;
}

export interface GitHubRepo {
  name: string;
  description: string | null;
  html_url: string;
  stargazers_count: number;
  language: string | null;
  fork: boolean;
  topics: string[];
}

export interface ContributionDay {
  date: string;
  count: number;
  level: number; // 0-4
}

export interface ContributionData {
  total: number;
  weeks: ContributionDay[][];
}

export async function fetchGitHubUser(): Promise<GitHubUser | null> {
  try {
    const res = await fetch(`https://api.github.com/users/${GITHUB_USER}`, {
      headers: { Accept: "application/vnd.github.v3+json" },
    });
    if (!res.ok) return null;
    return await res.json();
  } catch {
    return null;
  }
}

export async function fetchGitHubRepos(): Promise<GitHubRepo[]> {
  try {
    const res = await fetch(
      `https://api.github.com/users/${GITHUB_USER}/repos?sort=stars&per_page=8&type=owner`,
      { headers: { Accept: "application/vnd.github.v3+json" } },
    );
    if (!res.ok) return [];
    const repos: GitHubRepo[] = await res.json();
    return repos.filter((r) => !r.fork).sort((a, b) => b.stargazers_count - a.stargazers_count);
  } catch {
    return [];
  }
}

export async function fetchContributions(): Promise<ContributionData | null> {
  try {
    const res = await fetch(
      `https://github-contributions-api.jogruber.de/v4/${GITHUB_USER}?y=last`,
    );
    if (!res.ok) return null;
    const data = await res.json();

    const contributions: ContributionDay[][] = [];
    let weekBucket: ContributionDay[] = [];
    let total = 0;

    for (const c of data.contributions) {
      total += c.count;
      const day: ContributionDay = {
        date: c.date,
        count: c.count,
        level: c.level,
      };
      weekBucket.push(day);
      if (weekBucket.length === 7) {
        contributions.push(weekBucket);
        weekBucket = [];
      }
    }
    if (weekBucket.length > 0) contributions.push(weekBucket);

    return { total, weeks: contributions };
  } catch {
    return null;
  }
}
