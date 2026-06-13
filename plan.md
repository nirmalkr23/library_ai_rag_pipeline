# AI Library RAG Pipeline - Project Plan

## Vision
Build an AI-powered digital library using Ruby on Rails where:
- Admins upload PDF books
- PDFs are chunked and embedded into a vector database
- Users can read books and ask AI questions about them
- Answers are grounded in book content using RAG

---

## Tech Stack

### Frontend
- Ruby on Rails Views
- Tailwind CSS
- Hotwire / Turbo

### Backend
- Ruby on Rails
- PostgreSQL

### Authentication
- Devise
- Google OAuth (OmniAuth)

### AI Stack
- Ollama
- Llama 3
- Nomic Embed Text

### Vector Database
- pgvector

---

## Roles

### Admin
- Upload PDF
- View processing status
- Manage library
- Read books
- Ask AI

### User
- Browse library
- Read PDFs
- Ask AI questions

---

## Pages

### Public
1. Landing Page
2. Login
3. Signup

### User
1. Library Dashboard
2. Book Details
3. PDF Reader
4. AI Chat

### Admin
1. Upload Dashboard
2. Library Dashboard
3. Book Management
4. Processing Status

---

## RAG Pipeline

### Step 1
Upload PDF

### Step 2
Extract Text

### Step 3
Chunk Text

### Step 4
Generate Embeddings

### Step 5
Store in pgvector

### Step 6
Question Answering

---

## Database Models

### User
- email
- password
- role

### Book
- title
- author
- pdf_path

### BookChunk
- book_id
- content
- embedding

### ChatHistory
- user_id
- book_id
- question
- answer

---

## MVP Milestone

Week 1
- Authentication
- Roles
- Dashboard Layout

Week 2
- PDF Upload
- PDF Extraction
- Chunking

Week 3
- Embeddings
- pgvector Integration

Week 4
- AI Chat
- Retrieval Pipeline

Week 5
- UI Polish
- Testing
- Deployment

---

## Future Features

- Voice Chat
- Flashcards
- Quiz Generation
- Notes
- Bookmarks
- Multi-book Search
- AI Summaries
