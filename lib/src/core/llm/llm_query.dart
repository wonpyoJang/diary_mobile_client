// Removed as part of the Issue #33 part B migration.
//
// The legacy `LLMQuery` data class that lived here has been deleted. The
// only caller (`WriteMomentExternalProvider.describeImage`) now builds an
// `LlmRequest` with `LlmImagePart`s instead. This stub file is kept only
// because the agent that performed the migration was sandboxed and could
// not delete files; it can be `git rm`'d in any follow-up.
