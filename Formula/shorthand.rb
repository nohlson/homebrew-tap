class Shorthand < Formula
  desc "Very lightweight local only prompt-to-command CLI for macos (prompt-to-command via Ollama)"
  homepage "https://github.com/nohlson/shorthand"
  url "https://github.com/nohlson/shorthand/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "<FILL_ME_AFTER_TAGGING_RELEASE>"
  license "MIT"

  head "https://github.com/nohlson/shorthand.git", branch: "main"

  depends_on "node"

  def install
    bin.install "bin/termgen"
    bin.install "bin/shorthand-init"
    chmod 0555, bin/"termgen"
    chmod 0555, bin/"shorthand-init"

    (share/"shorthand").install "Modelfile"
    (share/"shorthand").install "zsh/_coprompt.zsh"
    prefix.install "README.md"
  end

  def caveats
    <<~EOS
      Quick start:
        1) Install and start Ollama:
           brew install ollama && brew services start ollama
        2) One-time model setup:
           shorthand-init
        3) Add the Zsh widget to ~/.zshrc:
           source "$(brew --prefix)/opt/shorthand/share/shorthand/_coprompt.zsh"
        4) Use it: open a new terminal, press Ctrl+G, type your prompt. Command is inserted into the buffer (not auto-run).
    EOS
  end

  test do
    # Without Ollama running, the CLI should exit non-zero (2)
    output = shell_output("#{bin}/termgen 'hello' 2>/dev/null", 2)
    assert_equal "", output
  end
end


