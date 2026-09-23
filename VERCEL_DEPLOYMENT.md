# Vercel test deployment

This branch is an isolated deployment experiment for the legacy Rails 3.0 CMMS.

Required Vercel environment variables:

- `DATABASE_URL`: PostgreSQL connection URL for a TEST database only.
- `SECRET_TOKEN`: random string at least 64 characters long.
- `SEED_DEMO_DATA`: set to `true` for the initial demo deployment only. Seeding runs only when no users exist.

The container listens on Vercel's `PORT` variable.

## Important

Do not point this branch at any production CMMS, Task Manager, Supabase, or Neon database.
The upstream project explicitly states that it is not production-ready.
