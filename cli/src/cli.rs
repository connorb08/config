use crate::core::AppCommand;
use clap::Parser;

#[derive(Parser)]
#[command(name = "my-hybrid-app", about = "Run commands via CLI or interactive TUI")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Option<AppCommand>,
}

