class Dora < Formula
  desc "Personal semantic memory for notes and code — single binary, MCP-first"
  homepage "https://github.com/rach/dora"
  version "0.2.5"
  license "MIT"

  # Apple Silicon ships a prebuilt binary from the GitHub release.
  # Intel macOS + Linux aren't published as bottles yet; users on those
  # platforms should build from source: `cargo install --git https://github.com/rach/dora`.
  on_macos do
    on_arm do
      url "https://github.com/rach/dora/releases/download/v0.2.5/dora-fs-v0.2.5-macos-arm64.tar.gz"
      sha256 "3200753608125c50b29a939204a283bf1a67ef8edd0ea76cfc9374d9b0f99a31"

      def install
        bin.install "dora"
      end
    end

    on_intel do
      odie <<~EOS
        dora doesn't publish an Intel macOS bottle yet.
        Build from source instead:
          cargo install --git https://github.com/rach/dora --tag v0.2.5
      EOS
    end
  end

  on_linux do
    odie <<~EOS
      dora doesn't publish a Linux bottle yet.
      Build from source instead:
        cargo install --git https://github.com/rach/dora --tag v0.2.5
    EOS
  end

  service do
    run [opt_bin/"dora", "watch"]
    keep_alive true
    log_path var/"log/dora-watch.log"
    error_log_path var/"log/dora-watch.log"
  end

  test do
    assert_match "dora #{version}", shell_output("#{bin}/dora --version")
  end
end
