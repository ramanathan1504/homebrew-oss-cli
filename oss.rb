class Oss < Formula
  desc "Maintainer workbench: reads any repo, runs what needs running, remembers what you worked out"
  homepage "https://ubuos.com"
  license "Apache-2.0"
  version "4.10.5"

  # Self-contained: the archive carries its own Java runtime, so there is no
  # depends_on "openjdk" any more. "First install Java 17" was a strange thing to
  # ask from a tool whose claim is that it needs almost nothing.
  #
  # Apple Silicon only for now. GitHub retired the Intel macOS runners, so there
  # is nothing to build an x64 archive ON -- and shipping one built elsewhere
  # would produce a runtime that looks right and does not run.
  on_macos do
    on_arm do
      url "https://github.com/ramanathan1504/oss-cli/releases/download/v4.10.5/oss-macos-arm64.tar.gz"
      sha256 "294b8105a2a8e247a387f6b8537b89bdecb903fd4081f01c6f877c7b9a7c6660"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ramanathan1504/oss-cli/releases/download/v4.10.5/oss-linux-x64.tar.gz"
      sha256 "bc453dc36ac7a48e95e9d698648616313cd8523c1c7762ca37e0f7599def3a52"
    end
  end

  def install
    libexec.install Dir["*"]
    # A symlink, not a copy: the launcher resolves its own directory to find the
    # bundled runtime beside it, so it has to keep living next to it.
    bin.install_symlink libexec/"oss"
  end

  def caveats
    <<~EOS
      Start here:

        oss doctor      # every prerequisite at once, with the fix for each

      Nothing but a GitHub token is required -- no Java, no model, no account.
      Search works with none of it; a model only makes it better:

        oss search "rollover compression" --global

      Prefer your own name for it?  oss alias buddy
    EOS
  end

  test do
    system bin/"oss", "--version"
  end
end
