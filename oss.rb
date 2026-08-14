class Oss < Formula
  desc "Maintainer workbench: reads any repo, runs what needs running, remembers what you worked out"
  homepage "https://ubuos.com"
  license "Apache-2.0"
  version "1.11.6"

  # Self-contained: the archive carries its own Java runtime, so there is no
  # depends_on "openjdk" any more. "First install Java 17" was a strange thing to
  # ask from a tool whose claim is that it needs almost nothing.
  #
  # Apple Silicon only for now. GitHub retired the Intel macOS runners, so there
  # is nothing to build an x64 archive ON -- and shipping one built elsewhere
  # would produce a runtime that looks right and does not run.
  on_macos do
    on_arm do
      url "https://github.com/ramanathan1504/oss-cli/releases/download/v1.11.6/oss-macos-arm64.tar.gz"
      sha256 "48e58d6179bddc5f5be480f0e6c3dd2d7aec1a397d69bfba70f2854cedbd3689"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ramanathan1504/oss-cli/releases/download/v1.11.6/oss-linux-x64.tar.gz"
      sha256 "615aa7fc57783070fbc71fc28e6e61e5bacbabbc4e04bcd69fdb1ca42d36f799"
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
