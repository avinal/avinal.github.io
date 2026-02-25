import type { ContributionData, ContributionDay } from "./github";
import type { WakaTimeData } from "./wakatime";

export interface ActivityDay {
  date: string;
  githubCount: number;
  githubLevel: number; // 0-4
  wakaSeconds: number;
  wakaText: string;
  /** Combined level 0-4 for coloring (higher of the two sources) */
  combinedLevel: number;
}

export interface ActivityData {
  weeks: ActivityDay[][];
  github: {
    total: number;
  };
  wakatime: {
    totalText: string;
    dailyAvgText: string;
    bestDayText: string;
    available: boolean;
  };
}

function wakaLevel(seconds: number): number {
  if (seconds <= 0) return 0;
  if (seconds < 1800) return 1; // < 30min
  if (seconds < 3600) return 2; // < 1h
  if (seconds < 7200) return 3; // < 2h
  return 4; // 2h+
}

/**
 * Merge GitHub contributions and WakaTime daily summaries into
 * a unified per-day activity dataset for the graph.
 */
export function mergeActivity(
  gh: ContributionData | null,
  waka: WakaTimeData | null,
): ActivityData {
  const weeks: ActivityDay[][] = [];

  if (gh) {
    for (const week of gh.weeks) {
      const merged: ActivityDay[] = [];
      for (const day of week) {
        const ws = waka?.days.get(day.date);
        const wSecs = ws?.totalSeconds ?? 0;
        const wLvl = wakaLevel(wSecs);

        merged.push({
          date: day.date,
          githubCount: day.count,
          githubLevel: day.level,
          wakaSeconds: wSecs,
          wakaText: ws?.text ?? "0m",
          combinedLevel: Math.max(day.level, wLvl),
        });
      }
      weeks.push(merged);
    }
  }

  return {
    weeks,
    github: {
      total: gh?.total ?? 0,
    },
    wakatime: {
      totalText: waka?.totalText ?? "—",
      dailyAvgText: waka?.dailyAvgText ?? "—",
      bestDayText: waka?.bestDayText ?? "—",
      available: waka !== null,
    },
  };
}
