class Agentbox < Formula
  desc "Profiles, scoped credentials and host tools for AI agents in Docker Sandboxes"
  homepage "https://github.com/sedurCode/agentbox"
  url "https://github.com/sedurCode/agentbox/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "cc4d63540578ec0e74a4dc9933498b5f83aa6bb2d2b90c7d106ad749acc190d5"
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
    # Started by a GUI app (Rex, an IDE), PATH may be just /usr/bin:/bin:/usr/sbin:/sbin, without sbx:
    # add Homebrew's bin after whatever the caller has. Then always brew's Python, by its opt path.
    (bin/"agentbox").write <<~SH
      #!/bin/sh
      case ":$PATH:" in *":#{HOMEBREW_PREFIX}/bin:"*) ;; *) PATH="$PATH:#{HOMEBREW_PREFIX}/bin" ;; esac
      export PATH
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
    # a GUI app's minimal PATH gets Homebrew's bin (where sbx is) added
    assert_match ":#{HOMEBREW_PREFIX}/bin\"", (bin/"agentbox").read
  end
end
