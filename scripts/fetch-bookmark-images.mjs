#!/usr/bin/env node
import fs from "fs";
import https from "https";
import http from "http";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const jsonPath = path.join(root, "src/data/bookmarks.json");
const imgDir = path.join(root, "public/images/bookmarks");

fs.mkdirSync(imgDir, { recursive: true });

function slugify(title) {
  return title.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
}

function httpGet(url, options = {}) {
  return new Promise((resolve, reject) => {
    const proto = url.startsWith("https") ? https : http;
    proto.get(url, options, resolve).on("error", reject);
  });
}

function download(url, dest, redirects = 5) {
  return new Promise((resolve, reject) => {
    if (redirects <= 0) return reject(new Error("Too many redirects"));
    const proto = url.startsWith("https") ? https : http;
    proto
      .get(url, { headers: { "User-Agent": "Mozilla/5.0" } }, (res) => {
        if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
          const next = new URL(res.headers.location, url).href;
          download(next, dest, redirects - 1).then(resolve).catch(reject);
          return;
        }
        if (res.statusCode !== 200) {
          reject(new Error(`HTTP ${res.statusCode}`));
          return;
        }
        const ct = res.headers["content-type"] || "";
        const ext = ct.includes("png") ? ".png" : ct.includes("webp") ? ".webp" : ".jpg";
        const finalDest = dest + ext;
        const ws = fs.createWriteStream(finalDest);
        res.pipe(ws);
        ws.on("finish", () => {
          ws.close();
          resolve("/images/bookmarks/" + path.basename(finalDest));
        });
        ws.on("error", reject);
      })
      .on("error", reject);
  });
}

async function fetchPosterFromOMDB(title, year) {
  const query = encodeURIComponent(title);
  const url = `https://www.omdbapi.com/?t=${query}&y=${year}&apikey=trilogy`;
  try {
    const res = await httpGet(url);
    let body = "";
    for await (const chunk of res) body += chunk;
    const data = JSON.parse(body);
    if (data.Poster && data.Poster !== "N/A") return data.Poster;
  } catch {}
  return null;
}

function delay(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

async function main() {
  const data = JSON.parse(fs.readFileSync(jsonPath, "utf8"));
  let fetched = 0;
  let skipped = 0;
  let failed = 0;

  for (const item of data) {
    const slug = slugify(item.title);
    const existing = fs.readdirSync(imgDir).find((f) => f.startsWith(slug + "."));
    if (existing) {
      item.image = "/images/bookmarks/" + existing;
      skipped++;
      continue;
    }

    if (item.image && item.image.startsWith("/images/")) {
      skipped++;
      continue;
    }

    let imageUrl = item.image;
    if (!imageUrl || imageUrl.startsWith("http")) {
      const omdbUrl = await fetchPosterFromOMDB(item.title, item.year);
      if (omdbUrl) imageUrl = omdbUrl;
      await delay(200);
    }

    if (!imageUrl) {
      console.error(`  SKIP  ${item.title}: no image URL found`);
      failed++;
      continue;
    }

    try {
      const localPath = await download(imageUrl, path.join(imgDir, slug));
      console.log(`  OK  ${item.title} -> ${localPath}`);
      item.image = localPath;
      fetched++;
    } catch (e) {
      const omdbUrl = await fetchPosterFromOMDB(item.title, item.year);
      if (omdbUrl) {
        try {
          const localPath = await download(omdbUrl, path.join(imgDir, slug));
          console.log(`  OK  ${item.title} -> ${localPath} (via OMDB fallback)`);
          item.image = localPath;
          fetched++;
          continue;
        } catch {}
      }
      console.error(`  FAIL  ${item.title}: ${e.message}`);
      failed++;
    }
  }

  fs.writeFileSync(jsonPath, JSON.stringify(data, null, 2) + "\n");
  console.log(`\nDone. Fetched: ${fetched}, Skipped: ${skipped}, Failed: ${failed}`);
}

main();
