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
    bin.install "bin/shorthand-model"
    bin.install "bin/shorthand-common.sh"
    chmod 0555, bin/"termgen"
    chmod 0555, bin/"shorthand-init"
    chmod 0555, bin/"shorthand-model"
    chmod 0444, bin/"shorthand-common.sh"

    (share/"shorthand").install "Modelfile.system"
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

      Switch base models or edit the prompt anytime with:
        shorthand-model list           # suggested base models + current one
        shorthand-model use <model>    # pulls (if needed) and rebuilds cmdgen from <model>
        shorthand-model status         # show current base model + prompt file path
        shorthand-model edit-prompt    # opens the system prompt in $EDITOR, then rebuilds
        shorthand-model rebuild        # rebuild cmdgen after manually editing the prompt
    EOS
  end

  test do
    # Without Ollama running, the CLI should exit non-zero (2)
    output = shell_output("#{bin}/termgen 'hello' 2>/dev/null", 2)
    assert_equal "", output
  end
end
