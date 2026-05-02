// Removed as part of the Issue #33 part B migration.
//
// The legacy `LLMResponse` data class that lived here has been deleted.
// Provider results now flow through `Either<LlmFailure, String>` from the
// new `ILlmProvider` API. This stub file is kept only because the agent
// that performed the migration was sandboxed and could not delete files;
// it can be `git rm`'d in any follow-up.
