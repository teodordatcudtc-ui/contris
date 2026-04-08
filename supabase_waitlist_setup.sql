-- Setup pentru tabela de waitlist din Supabase
-- Ruleaza acest script in SQL Editor (Supabase)

create table if not exists public.waitlist_emails (
  id bigint generated always as identity primary key,
  email text not null,
  source text not null default 'landing',
  created_at timestamptz not null default now()
);

-- Previne duplicatele de email indiferent de litere mari/mici
create unique index if not exists waitlist_emails_email_lower_uq
  on public.waitlist_emails (lower(email));

-- Activeaza Row Level Security
alter table public.waitlist_emails enable row level security;

-- Permite insert din frontend (anon + authenticated)
drop policy if exists "Allow insert for anon and authenticated" on public.waitlist_emails;
create policy "Allow insert for anon and authenticated"
on public.waitlist_emails
for insert
to anon, authenticated
with check (true);

-- Optional: permite citire doar utilizatorilor autentificati
-- (poti sterge acest bloc daca nu ai nevoie de SELECT din app)
drop policy if exists "Allow select for authenticated" on public.waitlist_emails;
create policy "Allow select for authenticated"
on public.waitlist_emails
for select
to authenticated
using (true);
