# Wiki Agent Instructions

This wiki is a private research workspace plus a carefully gated public publishing source.

## Hard Rules

- Treat `data/fulltext/`, `data/files/`, and `wiki/private/` as internal-only.
- Never copy raw source paragraphs into `wiki/public/`.
- Public pages must be original synthesis, not source text.
- Use `source_basis` article references, such as `article:f4b86384`, for traceability.
- Prefer updating existing pages over creating duplicates.
- Do not set `publish: true` unless the user explicitly asks for publication readiness.
- Do not set `public_safety.copyright_review: passed` unless lint passes and human review is complete.
- Update `wiki/log.md` after ingest, promotion, or public build actions.

## Public Page Requirements

Public pages must have:

- `visibility: public`
- `status: ready` or `status: published`
- `publish: true`
- `public_safety.source_policy: synthesis_only`
- `public_safety.copyright_review: passed`
- `public_safety.raw_excerpt_word_count: 0`

Public pages must not include:

- Local paths
- PDF paths
- Markdown source paths
- Blockquotes from sources
- Sections titled `Excerpt`, `Quote`, or `Original Text`
