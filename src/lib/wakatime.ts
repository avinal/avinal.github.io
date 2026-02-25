export interface WakaTimeDaySummary {
  date: string;
  totalSeconds: number;
  text: string;
}

export interface WakaTimeData {
  totalSeconds: number;
  totalText: string;
  dailyAvgText: string;
  bestDayText: string;
  days: Map<string, WakaTimeDaySummary>;
  topLangs: string[];
}

function formatSeconds(s: number): string {
  const h = Math.floor(s / 3600);
  const m = Math.floor((s % 3600) / 60);
  if (h === 0) return `${m}m`;
  if (m === 0) return `${h}h`;
  return `${h}h ${m}m`;
}

function wakaAuth(): string | null {
  const key = import.meta.env.WAKATIME_API_KEY;
  if (!key) return null;
  return `Basic ${btoa(key)}`;
}

async function fetchStats(auth: string) {
  const res = await fetch(
    "https://wakatime.com/api/v1/users/current/stats/last_year",
    { headers: { Authorization: auth } },
  );
  if (!res.ok) return null;
  return (await res.json()).data;
}

async function fetchSummaries(auth: string): Promise<Map<string, WakaTimeDaySummary>> {
  const end = new Date();
  const start = new Date();
  start.setDate(end.getDate() - 14);
  const fmt = (d: Date) => d.toISOString().slice(0, 10);

  const days = new Map<string, WakaTimeDaySummary>();
  try {
    const res = await fetch(
      `https://wakatime.com/api/v1/users/current/summaries?start=${fmt(start)}&end=${fmt(end)}`,
      { headers: { Authorization: auth } },
    );
    if (!res.ok) return days;
    const json = await res.json();
    for (const day of json.data ?? []) {
      const secs = day.grand_total?.total_seconds ?? 0;
      days.set(day.range.date, {
        date: day.range.date,
        totalSeconds: secs,
        text: secs > 0 ? formatSeconds(secs) : "0m",
      });
    }
  } catch { /* graceful degrade */ }
  return days;
}

export async function fetchWakaTimeData(): Promise<WakaTimeData | null> {
  const auth = wakaAuth();
  if (!auth) return null;

  try {
    const [stats, days] = await Promise.all([
      fetchStats(auth),
      fetchSummaries(auth),
    ]);
    if (!stats) return null;

    return {
      totalSeconds: stats.total_seconds ?? 0,
      totalText: stats.human_readable_total ?? "—",
      dailyAvgText: stats.human_readable_daily_average ?? "—",
      bestDayText: stats.best_day?.text ?? "—",
      days,
      topLangs: (stats.languages ?? []).slice(0, 5).map((l: { name: string }) => l.name),
    };
  } catch {
    return null;
  }
}
