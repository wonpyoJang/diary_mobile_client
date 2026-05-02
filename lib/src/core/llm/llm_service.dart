// Removed as part of the Issue #33 part B migration.
//
// The legacy `Gemini` (`@singleton`) and `LLMService` classes that lived
// here have been deleted. All callers now go through `LlmRouter` /
// `ILlmProvider` in `lib/src/feature/llm/`. This stub file is kept only
// because the agent that performed the migration was sandboxed and could
// not delete files; it can be `git rm`'d in any follow-up.
