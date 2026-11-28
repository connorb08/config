use crate::core::AppCommand;
use crossterm::event::{self, Event, KeyCode};
use ratatui::{
    layout::{Constraint, Layout},
    style::{Color, Modifier, Style, Stylize},
    widgets::{Block, List, ListItem, ListState, Paragraph},
    DefaultTerminal,
};
use std::io;

pub fn run() -> io::Result<()> {
    ratatui::run(app_loop)
}

fn app_loop(terminal: &mut DefaultTerminal) -> io::Result<()> {
    let commands = AppCommand::all();
    let mut state = ListState::default();
    state.select(Some(0));
    let mut output = String::from("Select a command and press Enter to run it.");

    loop {
        terminal.draw(|frame| {
            // Split screen: top for command list, bottom for command output
            let [top, bottom] = Layout::vertical([
                Constraint::Percentage(50),
                Constraint::Percentage(50),
            ])
            .areas(frame.area());

            let items: Vec<ListItem> = commands
                .iter()
                .map(|cmd| ListItem::new(cmd.label()))
                .collect();

            let list = List::new(items)
                .block(Block::bordered().title(" Commands (↑/↓: Navigate, Enter: Run, q: Quit) "))
                .highlight_style(
                    Style::default()
                        .fg(Color::Black)
                        .bg(Color::Cyan)
                        .add_modifier(Modifier::BOLD),
                )
                .highlight_symbol(">> ");

            frame.render_stateful_widget(list, top, &mut state);

            let output_box = Paragraph::new(output.as_str())
                .block(Block::bordered().title(" Output "))
                .green();

            frame.render_widget(output_box, bottom);
        })?;

        if let Event::Key(key) = event::read()? {
            match key.code {
                KeyCode::Char('q') | KeyCode::Esc => break Ok(()),
                KeyCode::Down | KeyCode::Char('j') => state.select_next(),
                KeyCode::Up | KeyCode::Char('k') => state.select_previous(),
                KeyCode::Enter => {
                    if let Some(i) = state.selected() {
                        output = commands[i].execute();
                    }
                }
                _ => {}
            }
        }
    }
}

