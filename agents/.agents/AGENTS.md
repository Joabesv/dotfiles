# Code Style (MANDATORY)

All generated code must follow these patterns. Write the simplest, most readable code possible — explicit, step-by-step logic over clever one-liners. Every line should be understandable without decoding it.

- **Function names**: `verb_noun` (`get_users`/`getUsers`), not bare nouns. Python: snake_case. TypeScript: camelCase.
- **Variable names**: self-explanatory, never single-letter or abbreviations (`validation_result`, not `r`).
- **Explicit iteration over comprehensions**: prefer plain loops (with early return/break) over list/dict comprehensions, `.filter().map()` chains, or `next()` on generators — even though these are idiomatic, they trade readability for brevity here.
- **No late/nested imports** — imports at top of file.
- **No ternaries for complex logic.**

## Dependency Approval Gate

Before adding any new pip/pnpm package or external module not already in the project: stop, list each new dependency with a one-line justification, and wait for explicit approval before installing/importing. If rejected, propose an alternative using existing dependencies or the standard library.

## Security — Critical Rules

- NEVER hardcode secrets in source. Use environment variables / config.
- NEVER use `print()`/`console.log()` in production code — use a structured logger with lazy evaluation.
- NEVER log PII, credentials, tokens, or financial identifiers, including via string interpolation into log messages.
- All user input MUST be validated (jsonschema/zod or equivalent).
- SQL queries MUST use an ORM or parameterized queries — no raw string-formatted SQL.
- Authentication/authorization MUST be verified on every endpoint.
- Error messages MUST NOT leak internal data (stack traces, DB errors, secret values).

If a security issue is found: stop and fix before continuing.
