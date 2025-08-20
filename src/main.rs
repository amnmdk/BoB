use anyhow::{anyhow, Result};
use clap::{Parser, Subcommand};
use serde::Deserialize;
use std::path::PathBuf;
use tokio::process::Command;

#[derive(Debug, Deserialize)]
struct Personality {
    professional_vs_relaxed: f32,
    funny_vs_serious: f32,
    fast_vs_slow: f32,
}

#[derive(Debug, Deserialize)]
struct Profile {
    name: String,
    color: String,
    voice_path: String, // chemin vers .onnx
    voice_config: String, // chemin vers .json
    default_volume: u8, // 0..100
    personality: Personality,
}

#[derive(Debug, Deserialize)]
struct Config {
    active_profile: String,
    profiles: Vec<Profile>,
    piper_bin: String,
}

#[derive(Parser)]
#[command(name = "bob", version, about = "BoB Assistant – Jour 1 TTS demo")] 
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Faire parler BoB via Piper
    Say { text: Vec<String> },
    /// Afficher le profil actif
    Whoami,
}

fn load_config() -> Result<Config> {
    let path = std::env::var("BOB_CONFIG").unwrap_or_else(|_| "config/bob.yaml".into());
    let s = std::fs::read_to_string(path)?;
    let cfg: Config = serde_yaml::from_str(&s)?;
    Ok(cfg)
}

async fn piper_say(cfg: &Config, text: &str) -> Result<()> {
    let profile = cfg
        .profiles
        .iter()
        .find(|p| p.name == cfg.active_profile)
        .ok_or_else(|| anyhow!("profil actif introuvable"))?;

    // On pipe en WAV vers stdout et on lit via ffplay/aplay (simple pour Jour 1)
    // Option 1: ffplay (ffmpeg)
    let piper = PathBuf::from(&cfg.piper_bin);
    if !piper.exists() { return Err(anyhow!("piper introuvable: {}", cfg.piper_bin)); }

    let mut child = Command::new(&cfg.piper_bin)
        .args(["--model", &profile.voice_path, "--config", &profile.voice_config, "--output_raw"])
        .stdin(std::process::Stdio::piped())
        .stdout(std::process::Stdio::piped())
        .spawn()?;

    // Écrire le texte dans stdin de piper
    {
        use std::io::Write;
        let mut stdin = child.stdin.take().ok_or_else(|| anyhow!("stdin piper"))?;
        stdin.write_all(text.as_bytes())?;
    }

    let piper_out = child.stdout.take().ok_or_else(|| anyhow!("stdout piper"))?;

    // Lire via ffplay (ou aplay si WAV 16k mono). Ici ffplay :
    let mut play = Command::new("ffplay")
        .args(["-autoexit", "-nodisp", "-f", "s16le", "-ar", "22050", "-ac", "1", "-"])
        .stdin(piper_out)
        .spawn()?;

    let status_piper = child.wait().await?;
    let status_play = play.wait().await?;

    if !status_piper.success() { return Err(anyhow!("piper a échoué")); }
    if !status_play.success() { return Err(anyhow!("lecture audio a échoué")); }
    Ok(())
}

#[tokio::main]
async fn main() -> Result<()> {
    let cli = Cli::parse();
    let cfg = load_config()?;

    match cli.command {
        Commands::Say { text } => {
            let phrase = text.join(" ");
            piper_say(&cfg, &phrase).await?
        }
        Commands::Whoami => {
            let profile = cfg
                .profiles
                .iter()
                .find(|p| p.name == cfg.active_profile)
                .ok_or_else(|| anyhow!("profil actif introuvable"))?;
            println!("Profil: {} | Couleur: {} | Volume par défaut: {}", profile.name, profile.color, profile.default_volume);
            println!("Personnalité => pro/détendu: {:.2}, drôle/sérieux: {:.2}, rapide/lent: {:.2}",
                profile.personality.professional_vs_relaxed,
                profile.personality.funny_vs_serious,
                profile.personality.fast_vs_slow
            );
        }
    }
    Ok(())
}
