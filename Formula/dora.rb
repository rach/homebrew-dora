class Dora < Formula
  desc "Personal semantic memory for notes and code — single binary, MCP-first"
  homepage "https://github.com/rach/dora"
  version "0.9.0"
  license "MIT"

  # Apple Silicon ships a prebuilt binary from the GitHub release.
  # Intel macOS + Linux aren't published as bottles yet; users on those
  # platforms should build from source: `cargo install --git https://github.com/rach/dora`.
  on_macos do
    on_arm do
      url "https://github.com/rach/dora/releases/download/v0.9.0/dora-fs-v0.9.0-macos-arm64.tar.gz"
      sha256 "f05e8ea2759a4b75f388b276b4c8187d226927295d1f8620714860480ce09f31"

      def install
        bin.install "dora"
      end
    end

    on_intel do
      odie <<~EOS
        dora doesn't publish an Intel macOS bottle yet.
        Build from source instead:
          cargo install --git https://github.com/rach/dora --tag v0.9.0
      EOS
    end
  end

  on_linux do
    odie <<~EOS
      dora doesn't publish a Linux bottle yet.
      Build from source instead:
        cargo install --git https://github.com/rach/dora --tag v0.9.0
    EOS
  end

  # `brew services start dora` runs the MCP HTTP daemon — one persistent process that all
  # MCP clients (Claude Code, Cursor, Codex) share. Embedders stay loaded across requests so
  # client startups aren't paying the ~80 MB ONNX reload each. v0.2.1–v0.4.x users whose
  # brew-service was running `dora watch` need to restart that themselves after upgrading
  # (e.g. `nohup dora watch > /tmp/dora-watch.log 2>&1 &`).
  service do
    run [opt_bin/"dora", "mcp", "--http"]
    keep_alive true
    log_path var/"log/dora-mcp.log"
    error_log_path var/"log/dora-mcp.log"
  end

  test do
    assert_match "dora #{version}", shell_output("#{bin}/dora --version")
  end
end
