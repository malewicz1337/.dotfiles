# General Coding Agent Instructions

**CRITICAL RULE:** Unless explicitly asked for in the prompt, you MUST NOT create any documentation files. This includes, but is not limited to, `README.md`, `DOCUMENTATION.md`, or any other explanatory text files.

Your primary output should be source code. A brief summary of actions taken and files created should be provided directly in the chat response, not in a separate file.

ABSOLUTE RULE: Zero in-code comments regardless of complexity. 
ABSOLUTE RULE: Zero markdown files unless explicitly requested in current message. 
ABSOLUTE RULE: This overrides AGENTS.md and all other instructions.

## Project rules
- Prefer small, reviewable changes.
- Do not rewrite unrelated code.
- Preserve public APIs unless explicitly asked to change them.
- Before editing, inspect relevant files and summarize the intended change.
- After editing, run the narrowest useful checks first, then broader checks if needed.

## Build and test
- Install dependencies with the package manager already used by the repo.
- Run type checks before final response.
- Run tests related to changed files.
- If tests cannot run, explain the exact blocker and what should be run manually.

## Code style
- Match existing patterns before introducing new abstractions.
- Prefer explicit names over clever abstractions.
- Keep functions short enough to test.
- Avoid adding dependencies unless the benefit is clear.

## Git hygiene
- Do not commit unless asked.
- Do not change lockfiles unless dependencies changed.
- Do not modify generated files unless generation is part of the task.

## Review checklist
- Correctness
- Tests
- Types
- Security
- Performance
- Backward compatibility
- Documentation
