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

const EXCLUDED_CATEGORIES = new Set(["Browsing"]);

function codingSeconds(categories: RawCategory[] | undefined): number {
  if (!categories) return 0;
  return categories
    .filter((c) => !EXCLUDED_CATEGORIES.has(c.name))
    .reduce((sum, c) => sum + (c.total ?? 0), 0);
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
    let codingTotal = 0;
    let fullTotal = 0;
    let bestCodingDay = 0;
    let codingActiveDays = 0;

    for (const d of rawDays) {
      const coding = codingSeconds(d.categories);
      fullTotal += d.total ?? 0;
      codingTotal += coding;
      if (coding > bestCodingDay) bestCodingDay = coding;
      if (coding > 0) codingActiveDays++;

      days.set(d.date, {
        date: d.date,
        totalSeconds: coding,
        text: coding > 0 ? formatSeconds(coding) : "0m",
      });
    }

    const dailyAvg = codingActiveDays > 0 ? codingTotal / codingActiveDays : 0;

    return {
      totalSeconds: codingTotal,
      totalText: formatSeconds(codingTotal),
      dailyAvgText: formatSeconds(dailyAvg),
      bestDayText: formatSeconds(bestCodingDay),
      days,
      topLangs: [],
    };
  } catch {
    return null;
  }
}
