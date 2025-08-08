class Shorthand < Formula
  desc "Very lightweight local only prompt-to-command CLI for macos (prompt-to-command via Ollama)"
  homepage "https://github.com/nohlson/shorthand"
  head "https://github.com/nohlson/shorthand.git", branch: "main"
  license "MIT"

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
      Dependencies:
        - Requires Ollama. Install: brew install ollama
        - Start service: brew services start ollama

      One-time setup:
        shorthand-init

      Zsh widget:
        Add to your ~/.zshrc:
          source "$(brew --prefix)/opt/shorthand/share/shorthand/_coprompt.zsh"

      Usage:
        termgen --model=cmdgen "list files recursively"
    EOS
  end

  test do
    # Without Ollama, CLI exits non-zero; ensure binary exists and runs.
    assert_equal "", shell_output("#{bin}/termgen 'hello' 2>/dev/null", 2)
  end
end
