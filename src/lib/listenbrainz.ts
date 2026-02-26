import theme from "@/config/theme";

const LB_API = "https://api.listenbrainz.org/1";
const USERNAME = theme.site.listenBrainzUser ?? "avinal";

export interface LBTrack {
  trackName: string;
  artistName: string;
  releaseName?: string;
  listenedAt?: number;
  coverArtUrl?: string;
  listenUrl?: string;
}

export interface LBData {
  available: boolean;
  username: string;
  nowPlaying: LBTrack | null;
  recentTracks: LBTrack[];
}

function parseTrack(listen: any): LBTrack {
  const meta = listen.track_metadata ?? {};
  const info = meta.additional_info ?? {};
  const mbids = meta.mbid_mapping ?? {};

  const releaseMbid = mbids.release_mbid ?? info.release_mbid;
  const coverArtUrl = releaseMbid
    ? `https://coverartarchive.org/release/${releaseMbid}/front-250`
    : undefined;

  const listenUrl =
    info.origin_url ??
    info.spotify_id ??
    (mbids.recording_mbid
      ? `https://listenbrainz.org/player?recording_mbids=${mbids.recording_mbid}`
      : undefined);

  return {
    trackName: meta.track_name ?? "Unknown",
    artistName: meta.artist_name ?? "Unknown",
    releaseName: meta.release_name,
    listenedAt: listen.listened_at,
    coverArtUrl,
    listenUrl,
  };
}

export async function fetchListenBrainzData(): Promise<LBData> {
  const empty: LBData = {
    available: false,
    username: USERNAME,
    nowPlaying: null,
    recentTracks: [],
  };

  if (!USERNAME) return empty;

  try {
    const [nowRes, listensRes] = await Promise.all([
      fetch(`${LB_API}/user/${USERNAME}/playing-now`),
      fetch(`${LB_API}/user/${USERNAME}/listens?count=5`),
    ]);

    let nowPlaying: LBTrack | null = null;
    if (nowRes.ok) {
      const nowData = await nowRes.json();
      const np = nowData?.payload?.listens?.[0];
      if (np) nowPlaying = parseTrack(np);
    }

    let recentTracks: LBTrack[] = [];
    if (listensRes.ok) {
      const listensData = await listensRes.json();
      const listens = listensData?.payload?.listens ?? [];
      recentTracks = listens.map(parseTrack);
    }

    return {
      available: true,
      username: USERNAME,
      nowPlaying,
      recentTracks,
    };
  } catch (e) {
    console.warn("ListenBrainz fetch failed:", e);
    return empty;
  }
}
