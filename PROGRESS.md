# Library AI — Progress

Rails 8 AI digital library with RAG. Admins upload PDF books → chunk + embed → users read + ask AI grounded questions.

**Stack:** Rails 8 + PostgreSQL (Docker), Tailwind v4, Hotwire/Stimulus, Devise. AI: **Google Gemini** — `text-embedding-004` + `gemini-2.0-flash`, pgvector. App lives in `rails_app/`; `docker-compose.yml` at repo root. Secrets in `rails_app/.env` (gitignored).

## Infra (done)
- Host: Ruby 3.2.2, Rails 8. Docker 26.1.3 + compose v2 plugin. User in docker group.
- `docker-compose.yml`: `postgres` (pgvector/pgvector:pg16, port 5432, db `library_ai_development`, user/pass `library`/`library`) + `ollama` (port 11434, NOT started yet — only postgres running).
- Start DB: `docker compose up -d postgres`. Dev server: `cd rails_app && bin/dev`.

## App (done)
- DB wired to Docker PG via env-overridable `config/database.yml`. Migrated.
- Devise auth. User: email, name, role enum {member, admin}. `nirmalworkspace@gmail.com` auto-admin on signup, others member.
- Interactive login/signup landing = root: tab toggle (`auth-tabs`), show/hide password (`password-visibility`), flash toasts. Devise views reuse `shared/_auth`.
- Book model: title, author, status enum {pending,processing,ready,failed}, belongs_to user, `has_one_attached :pdf`. Validates PDF presence + type.
- Admin area: `Admin::BaseController` (admin guard) + `Admin::BooksController` (index/new/create/destroy), `namespace :admin`.
- Interactive drag-drop PDF upload (`admin/books/new`) via Stimulus `file-upload`. Books index grid w/ status pills.
- Full dark theme (slate-950 + indigo/fuchsia). Shared `_navbar`, `_book_status`.
- Admin login: `sage@library.ai` / `sage123456`.

## Next / TODO
- Wire RAG: extract PDF text → chunk → embed (Gemini text-embedding-004, 768-dim) → store in pgvector. Add BookChunk model + enable `vector` extension migration + `neighbor` gem.
- Gemini HTTP client for embeddings + chat (gemini-2.0-flash). Background job for processing.
- User-facing: library browse, PDF reader, AI chat (retrieval + Gemini Flash), ChatHistory model.
- Google OAuth (OmniAuth).
