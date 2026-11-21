# Marginalia

Keep every highlight from your e-reader and turn any of them into a quote card for Instagram, TikTok, Threads and X.

- **Import** from a Kobo (`KoboReader.sqlite`), an Xteink X4 Pro running CrossPoint Reader (`My Clippings.txt`), a Kindle (`My Clippings.txt`), or a Marginalia backup (`.json`). Re-importing only adds new highlights.
- **Library**: search, filter by book or Kobo highlight colour, favourites, shuffle.
- **Quote studio**: 10 card styles, 4 sizes (Story 9:16, Post 4:5, Square, Wide 16:9), 3 typefaces, your @handle. On a phone, **Save image** opens the share sheet so you can send the card straight to Instagram, TikTok, Threads or X.
- **Sync**: sign in with your email (magic link) and your library follows you to every device. Signed out, highlights stay in that browser.

It is one static page (`index.html`) plus a Supabase database. No build step.

## 1. Set up Supabase (free)

1. Create a project at [supabase.com](https://supabase.com).
2. **SQL Editor → New query**: paste [`supabase/schema.sql`](supabase/schema.sql) and click **Run**. This creates the `highlights` table with Row Level Security, so each person can only read and change their own highlights.
3. **Project Settings → API** (or **Data API**): copy the **Project URL** and the **anon / public key** into [`config.js`](config.js). The anon key is meant to be public; it cannot read anyone's data without their sign-in.
4. **Authentication → URL Configuration**:
   - **Site URL**: your site's address, e.g. `https://quotes.yourdomain.com`
   - **Redirect URLs**: add the same address (and `http://localhost:8000` if you test locally).

Sign-in links are sent by Supabase's built-in email, which is rate-limited (a few emails per hour). For more, add your own SMTP under **Authentication → Emails**.

## 2. Publish with GitHub Pages

1. In this repo: **Settings → Pages → Build and deployment → Source: Deploy from a branch**, branch `main`, folder `/ (root)`, **Save**.
2. After a minute the site is live at `https://<your-user>.github.io/ereaderquote/`.

## 3. Connect your own domain

1. **Settings → Pages → Custom domain**: type your domain (e.g. `quotes.yourdomain.com`) and **Save**. GitHub adds a `CNAME` file to the repo.
2. At your domain registrar, add a DNS record:
   - Subdomain (`quotes.yourdomain.com`): **CNAME** `quotes` → `<your-user>.github.io`
   - Apex domain (`yourdomain.com`): **A** records to `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`
3. When the DNS check passes, tick **Enforce HTTPS**.
4. Put the new address in Supabase's **Site URL** and **Redirect URLs** (step 1.4).

## Moving your library from the claude.ai version

In the claude.ai version open **Import → Save backup**, then on your new site sign in, open **Import** and drop the backup `.json` into either import box. Highlight ids are kept, so later Kobo or Xteink imports won't create duplicates.

## Getting your highlights off the device

**Kobo**: connect by USB, show hidden files, pick `.kobo/KoboReader.sqlite` from the KOBOeReader drive. Eject the Kobo first so the database is up to date.

**Xteink X4 Pro**: needs the [CrossPoint Reader](https://github.com/crosspoint-reader/crosspoint-reader) firmware, which adds every saved clipping to `My Clippings.txt` at the top of the SD card. Use USB Drive mode or a card reader.

## Run locally

```bash
python3 -m http.server 8000
```

Then open http://localhost:8000. Without Supabase settings in `config.js`, the app runs in browser-only mode.

## Files

| File | What it is |
| --- | --- |
| `index.html` | The whole app |
| `config.js` | Your Supabase URL and anon key |
| `supabase/schema.sql` | Database table and access rules |
| `manifest.webmanifest`, `icon*` | Lets phones add it to the home screen as an app |
