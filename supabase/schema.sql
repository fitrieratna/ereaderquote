-- Marginalia: one table of highlights, private to each signed-in person.
-- Run this once in Supabase: SQL Editor → New query → paste → Run.

create table if not exists public.highlights (
  user_id     uuid        not null default auth.uid() references auth.users (id) on delete cascade,
  id          text        not null,               -- stable id from the e-reader (re-imports skip duplicates)
  text        text        not null,
  note        text        not null default '',
  book        text        not null default '',
  author      text        not null default '',
  color       text        not null default 'yellow' check (color in ('yellow', 'pink', 'blue', 'green')),
  created     timestamptz not null default now(), -- when it was highlighted on the device
  fav         boolean     not null default false,
  source      text        not null default '',    -- kobo | clippings | manual | backup
  inserted_at timestamptz not null default now(),
  primary key (user_id, id)
);

create index if not exists highlights_user_created on public.highlights (user_id, created desc);

alter table public.highlights enable row level security;

drop policy if exists "Read own highlights"   on public.highlights;
drop policy if exists "Add own highlights"    on public.highlights;
drop policy if exists "Change own highlights" on public.highlights;
drop policy if exists "Delete own highlights" on public.highlights;

create policy "Read own highlights"   on public.highlights for select to authenticated using (auth.uid() = user_id);
create policy "Add own highlights"    on public.highlights for insert to authenticated with check (auth.uid() = user_id);
create policy "Change own highlights" on public.highlights for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Delete own highlights" on public.highlights for delete to authenticated using (auth.uid() = user_id);

grant select, insert, update, delete on public.highlights to authenticated;
