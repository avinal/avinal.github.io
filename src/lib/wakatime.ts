const SHARE_URL =
  "https://wakatime.com/share/@Avinal/13174f97-2646-484b-9644-bc3c07315068.json";

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

interface RawCategory {
  name: string;
  total: number;
}

interface RawDay {
  date: string;
  total: number;
  categories?: RawCategory[];
}

function totalSeconds(day: RawDay): number {
  return day.total ?? 0;
}

function formatSeconds(s: number): string {
  const h = Math.floor(s / 3600);
  const m = Math.floor((s % 3600) / 60);
  if (h === 0) return `${m}m`;
  if (m === 0) return `${h}h`;
  return `${h}h ${m}m`;
}

export async function fetchWakaTimeData(): Promise<WakaTimeData | null> {
  try {
    const res = await fetch(SHARE_URL);
    if (!res.ok) return null;
    const json = await res.json();

    const rawDays: RawDay[] = json.days ?? [];
    if (rawDays.length === 0) return null;

    const days = new Map<string, WakaTimeDaySummary>();
    let total = 0;
    let bestDay = 0;
    let activeDays = 0;

    for (const d of rawDays) {
      const secs = totalSeconds(d);
      total += secs;
      if (secs > bestDay) bestDay = secs;
      if (secs > 0) activeDays++;

      days.set(d.date, {
        date: d.date,
        totalSeconds: secs,
        text: secs > 0 ? formatSeconds(secs) : "0m",
      });
    }

    const dailyAvg = activeDays > 0 ? total / activeDays : 0;

    return {
      totalSeconds: total,
      totalText: formatSeconds(total),
      dailyAvgText: formatSeconds(dailyAvg),
      bestDayText: formatSeconds(bestDay),
      days,
      topLangs: [],
    };
  } catch {
    return null;
  }
}
