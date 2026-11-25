class Agentbox < Formula
  desc "Profiles, scoped credentials and host tools for AI agents in Docker Sandboxes"
  homepage "https://github.com/sedurCode/agentbox"
  url "https://github.com/sedurCode/agentbox/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "befed7973df2495715370e8d1b96a1d00426de8f17759af20146686b8474fc6c"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "python@3.15"

  def install
    # the layout agentbox expects: bin/agentbox.py next to share/ (it finds share/ from the script)
    (libexec/"bin").install "bin/agentbox" => "agentbox.py"
    libexec.install "share"
    chmod 0755, libexec/"share/hosttool"
    # always brew's Python, by its opt path, whatever is first on PATH
    (bin/"agentbox").write <<~SH
      #!/bin/sh
      exec "#{formula_opt_bin("python@3.15")}/python3.15" "#{opt_libexec}/bin/agentbox.py" "$@"
    SH
    chmod 0755, bin/"agentbox"
  end

  def caveats
    <<~EOS
      agentbox runs agents in Docker Sandboxes (sbx; macOS on Apple silicon). If you don't have it:
        brew install --cask docker/tap/sbx && sbx login

      Then, and after every upgrade:
        agentbox setup
    EOS
  end

  test do
    assert_match "agentbox #{version}", shell_output("#{bin}/agentbox --version")
  end
end
