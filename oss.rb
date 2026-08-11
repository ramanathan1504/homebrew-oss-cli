class Oss < Formula
  desc "Maintainer workbench: reads any repo, runs what needs running, remembers what you worked out"
  homepage "https://github.com/ramanathan1504/oss-cli"
  url "https://github.com/ramanathan1504/oss-cli/releases/download/v1.6.0/oss-cli-1.6.0.jar"
  sha256 "0194673a63baac91c600ca8691f79d2faa42b38325d04a40246fe9bf99703305"
  license "Apache-2.0"

  depends_on "openjdk@17"

  def install
    # Derived from the URL, so a version bump means editing url + sha256 only.
    libexec.install File.basename(stable.url) => "oss-cli.jar"

    # One name, always. A second built-in name is a second thing to keep working,
    # document and reason about forever -- and anyone who wants a different one
    # can make it themselves with `oss alias`, which is theirs to maintain rather
    # than ours.
    (bin/"oss").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Formula["openjdk@17"].opt_prefix}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/oss-cli.jar" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Start here:

        oss doctor      # every prerequisite at once, with the fix for each
        oss setup       # optional: models, tokens, note folders

      Nothing beyond Java and a GitHub token is required. A local model server
      and a cloud key each add something, and it works without either:

        brew install ollama && ollama serve    # optional: local answers, search by meaning

      Prefer your own name for it?

        oss alias buddy

      Upgrading from oss-cli, self-analyse or issue-ai? Your data relocates
      automatically on first run -- nothing to move by hand.
    EOS
  end

  test do
    system "#{bin}/oss", "--help"
  end
end
