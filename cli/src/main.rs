mod cli;
mod core;
mod tui;

use clap::Parser;
use cli::Cli;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Cli::parse();

    match args.command {
        Some(cmd) => println!("{}", cmd.execute()),
        None => tui::run()?,
    }

    Ok(())
}

