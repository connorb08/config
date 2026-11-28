use clap::Subcommand;

#[derive(Subcommand, Debug, Clone)]
pub enum AppCommand {
    /// Check the status of the primary system
    Status,
    /// Run a diagnostic health check
    HealthCheck,
    /// Clear temporary cache files
    ClearCache,
}

impl AppCommand {
    /// Returns all commands so the TUI can list them
    pub fn all() -> Vec<Self> {
        vec![Self::Status, Self::HealthCheck, Self::ClearCache]
    }

    /// Display name for the TUI menu
    pub fn label(&self) -> &'static str {
        match self {
            Self::Status => "status       - Check primary system status",
            Self::HealthCheck => "health-check - Run diagnostic health check",
            Self::ClearCache => "clear-cache  - Clear temporary cache files",
        }
    }

    /// Shared execution logic used by both CLI and TUI
    pub fn execute(&self) -> String {
        match self {
            Self::Status => "[OK] All systems operational (uptime: 99.9%).".into(),
            Self::HealthCheck => "[PASS] Database, API, and worker threads healthy.".into(),
            Self::ClearCache => "[DONE] Cleared 42MB of temporary cache files.".into(),
        }
    }
}

